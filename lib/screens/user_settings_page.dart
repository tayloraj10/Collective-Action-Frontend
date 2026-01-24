import 'package:collective_action_frontend/app/theme.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class UserSettingsPage extends ConsumerStatefulWidget {
  const UserSettingsPage({super.key});

  @override
  ConsumerState<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends ConsumerState<UserSettingsPage> {
  Widget _unsavedChangesWarning() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warningOrange,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You have unsaved changes. Please save.',
              style: TextStyle(
                color: AppColors.warningOrange,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isRedirecting = false;
  void _redirectIfNotLoggedIn() {
    if (_isRedirecting) return;
    _isRedirecting = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go('/');
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _photoUrl;
  String? _city;
  String? _state;
  String? _country;
  String? _youtube;
  String? _instagram;
  String? _tiktok;
  String? _website;

  // Track initial values for dirty check
  Map<String, String?> _initialValues = {};
  final Set<String> _dirtyFields = {};

  String? _currentUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authUser = ref.watch(authStateProvider).value;
    final userId = authUser?.uid;
    if (_currentUserId != userId && userId != null) {
      _currentUserId = userId;
      final user = ref.read(activeUserProvider(userId)).value;
      if (user != null) {
        _name = user.name;
        _email = user.email;
        _photoUrl = user.photoUrl;
        _city = user.location?.city;
        _state = user.location?.state;
        _country = user.location?.country;
        _youtube = user.socialLinks?.youtube;
        _instagram = user.socialLinks?.instagram;
        _tiktok = user.socialLinks?.tiktok;
        _website = user.socialLinks?.website;
        // Store initial values for dirty check
        _initialValues = {
          'name': _name,
          'email': _email,
          'photoUrl': _photoUrl,
          'city': _city,
          'state': _state,
          'country': _country,
          'youtube': _youtube,
          'instagram': _instagram,
          'tiktok': _tiktok,
          'website': _website,
        };
        _dirtyFields.clear();
      }
    }
  }

  void _saveSettings() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    final user = ref.read(currentUserProvider).value;
    if (user == null || user.id == null) return;

    final userData = UserCreate(
      email: _email!,
      name: _name,
      photoUrl: _photoUrl,
      userType: user.userType,
      location: LocationSchema(city: _city, state: _state, country: _country),
      socialLinks: SocialLinksSchema(
        youtube: _youtube,
        instagram: _instagram,
        tiktok: _tiktok,
        website: _website,
      ),
      firebaseUserId: user.firebaseUserId,
    );

    try {
      await ref
          .read(activeUserProvider(user.id!).notifier)
          .updateUser(userData);
      if (mounted) {
        // Reset dirty fields after save
        setState(() {
          _initialValues = {
            'name': _name,
            'email': _email,
            'photoUrl': _photoUrl,
            'city': _city,
            'state': _state,
            'country': _country,
            'youtube': _youtube,
            'instagram': _instagram,
            'tiktok': _tiktok,
            'website': _website,
          };
          _dirtyFields.clear();
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings saved!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save settings: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder? getBorder(String field) {
      if (!_dirtyFields.contains(field)) return null;
      return const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.warningOrange, width: 2),
      );
    }

    // Card border for any dirty field
    BoxDecoration? getCardBorder() {
      if (_dirtyFields.isEmpty) return null;
      return BoxDecoration(
        border: Border.all(color: AppColors.warningOrange, width: 2),
        borderRadius: BorderRadius.circular(18),
      );
    }

    void onChanged(String field, String? value) {
      final initial = _initialValues[field] ?? '';
      if ((value ?? '') != (initial)) {
        setState(() {
          _dirtyFields.add(field);
        });
      } else {
        setState(() {
          _dirtyFields.remove(field);
        });
      }
    }

    return ref
        .watch(authStateProvider)
        .when(
          data: (firebaseUser) {
            if (firebaseUser == null) {
              if (!_isRedirecting) {
                _redirectIfNotLoggedIn();
              }
              return const Scaffold();
            }
            final user = ref.watch(currentUserProvider).value;
            if (user == null) {
              Future.microtask(() async {
                if (!mounted) return;
                final appUser = await ref
                    .read(activeUserProvider(firebaseUser.uid).notifier)
                    .build();
                if (!mounted) return;
                if (appUser != null) {
                  await ref.read(currentUserProvider.notifier).setUser(appUser);
                }
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            String? displayPhotoUrl = user.photoUrl;
            if ((displayPhotoUrl == null || displayPhotoUrl.isEmpty) &&
                firebaseUser.photoURL != null &&
                firebaseUser.photoURL!.isNotEmpty) {
              displayPhotoUrl = firebaseUser.photoURL;
            }
            final width = MediaQuery.of(context).size.width;
            final isMobile = width < 600;
            final cardMaxWidth = isMobile ? 500.0 : 700.0;
            final cardPadding = isMobile
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
                : const EdgeInsets.symmetric(horizontal: 48, vertical: 48);
            final innerPadding = isMobile
                ? const EdgeInsets.all(20.0)
                : const EdgeInsets.all(40.0);
            return Scaffold(
              appBar: AppBar(
                title: const Text('User Settings'),
                elevation: 2,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              body: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: cardMaxWidth),
                  padding: cardPadding,
                  child: Container(
                    decoration: getCardBorder(),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: innerPadding,
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 48,
                                      backgroundImage:
                                          displayPhotoUrl != null &&
                                              displayPhotoUrl.isNotEmpty
                                          ? NetworkImage(displayPhotoUrl)
                                          : null,
                                      child:
                                          displayPhotoUrl == null ||
                                              displayPhotoUrl.isEmpty
                                          ? Icon(
                                              Icons.person,
                                              size: 48,
                                              color: Colors.grey.shade400,
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          ),
                                          onPressed: () {
                                            // Optionally implement photo picker
                                          },
                                          tooltip: 'Change Photo',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                'Profile',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              if (_dirtyFields.isNotEmpty)
                                _unsavedChangesWarning(),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: user.name,
                                decoration: InputDecoration(
                                  labelText: 'Name',

                                  prefixIcon: const Icon(Icons.person_outline),
                                  enabledBorder: getBorder('name'),
                                ),

                                onChanged: (v) => onChanged('name', v),
                                onSaved: (v) => _name = v,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: user.email,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  enabledBorder: getBorder('email'),
                                ),
                                onChanged: (v) => onChanged('email', v),
                                onSaved: (v) => _email = v,
                              ),
                              const SizedBox(height: 28),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey.shade200,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Location',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: user.location?.city,
                                      decoration: InputDecoration(
                                        labelText: 'City',
                                        enabledBorder: getBorder('city'),
                                      ),
                                      onChanged: (v) => onChanged('city', v),
                                      onSaved: (v) => _city = v,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: user.location?.state,
                                      decoration: InputDecoration(
                                        labelText: 'State',
                                        enabledBorder: getBorder('state'),
                                      ),
                                      onChanged: (v) => onChanged('state', v),
                                      onSaved: (v) => _state = v,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: false,
                                    onSelect: (Country country) {
                                      setState(() {
                                        _country = country.name;
                                        onChanged('country', country.name);
                                      });
                                    },
                                    favorite: const ['US'],
                                    useSafeArea: true,
                                  );
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Country',
                                      enabledBorder: getBorder('country'),
                                    ),
                                    controller: TextEditingController(
                                      text:
                                          _country ??
                                          user.location?.country ??
                                          '',
                                    ),
                                    onChanged: (v) => onChanged('country', v),
                                    onSaved: (v) => _country = v,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey.shade200,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Social Links',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Please enter only your username, not the full link, for each social platform.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: user.socialLinks?.youtube,
                                decoration: InputDecoration(
                                  labelText: 'YouTube Username',
                                  hintText: 'Enter your YouTube username',
                                  prefixIcon: const Icon(Icons.ondemand_video),
                                  enabledBorder: getBorder('youtube'),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return null;
                                  final valid = RegExp(
                                    r'^[A-Za-z0-9._-]{3,}$',
                                  ).hasMatch(v);
                                  if (!valid) {
                                    return 'Enter a valid YouTube username';
                                  }
                                  return null;
                                },
                                onChanged: (v) => onChanged('youtube', v),
                                onSaved: (v) => _youtube = v,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: user.socialLinks?.instagram,
                                decoration: InputDecoration(
                                  labelText: 'Instagram Username',
                                  hintText: 'Enter your Instagram username',
                                  prefixIcon: const Icon(
                                    Icons.camera_alt_outlined,
                                  ),
                                  enabledBorder: getBorder('instagram'),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return null;
                                  final valid = RegExp(
                                    r'^[A-Za-z0-9._]{1,30}$',
                                  ).hasMatch(v);
                                  if (!valid) {
                                    return 'Enter a valid Instagram username';
                                  }
                                  return null;
                                },
                                onChanged: (v) => onChanged('instagram', v),
                                onSaved: (v) => _instagram = v,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: user.socialLinks?.tiktok,
                                decoration: InputDecoration(
                                  labelText: 'TikTok Username',
                                  hintText: 'Enter your TikTok username',
                                  prefixIcon: const Icon(Icons.music_note),
                                  enabledBorder: getBorder('tiktok'),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return null;
                                  final valid = RegExp(
                                    r'^[A-Za-z0-9._]{2,24}$',
                                  ).hasMatch(v);
                                  if (!valid) {
                                    return 'Enter a valid TikTok username';
                                  }
                                  return null;
                                },
                                onChanged: (v) => onChanged('tiktok', v),
                                onSaved: (v) => _tiktok = v,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: user.socialLinks?.website,
                                decoration: InputDecoration(
                                  labelText: 'Website',
                                  prefixIcon: const Icon(Icons.link),
                                  enabledBorder: getBorder('website'),
                                ),
                                onChanged: (v) => onChanged('website', v),
                                onSaved: (v) => _website = v,
                              ),
                              const SizedBox(height: 32),
                              if (_dirtyFields.isNotEmpty)
                                _unsavedChangesWarning(),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.save_alt),
                                  label: const Text(
                                    'Save Settings',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  onPressed: _saveSettings,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Error: $err'))),
        );
  }
}
