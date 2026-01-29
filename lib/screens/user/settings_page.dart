import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/components/custom_snack_bar.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collective_action_frontend/api/lib/api.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends ConsumerState<SettingsPage> {
  UserType? _userType;
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
  final ValueNotifier<Set<String>> _dirtyFields = ValueNotifier({});

  String? _currentUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authUser = ref.watch(authStateProvider).value;
    final userId = authUser?.uid;
    if (_currentUserId != userId && userId != null) {
      _currentUserId = userId;
      final user = ref.read(userProvider(userId)).value;
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
        _userType = user.userType ?? UserType.person;
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
        _dirtyFields.value = {};
      }
    }
  }

  @override
  void dispose() {
    _dirtyFields.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    final user = ref.read(currentUserProvider).value;
    if (user == null || user.id == null) return;

    String? nullIfBlank(String? v) =>
        (v == null || v.trim().isEmpty) ? null : v.trim();
    final userData = UserCreate(
      email: _email!,
      name: nullIfBlank(_name),
      photoUrl: nullIfBlank(_photoUrl),
      userType: _userType ?? user.userType,
      location: LocationSchema(
        city: nullIfBlank(_city),
        state: nullIfBlank(_state),
        country: nullIfBlank(_country),
      ),
      socialLinks: SocialLinksSchema(
        youtube: nullIfBlank(_youtube),
        instagram: nullIfBlank(_instagram),
        tiktok: nullIfBlank(_tiktok),
        website: nullIfBlank(_website),
      ),
      firebaseUserId: user.firebaseUserId,
      isActive: user.isActive,
    );

    try {
      await ref.read(userProvider(user.id!).notifier).updateUser(userData);
      if (mounted) {
        // Reset dirty fields after save
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
        _dirtyFields.value = {};
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.success('Settings saved!'),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.error('Failed to save settings'),
        );
      }
    }
  }

  void onChanged(String field, String? value) {
    if (field == 'userType') {
      _userType = value == 'group' ? UserType.group : UserType.person;
    }
    final initial = _initialValues[field] ?? '';
    final newDirtyFields = Set<String>.from(_dirtyFields.value);

    if ((value ?? '') != initial) {
      newDirtyFields.add(field);
    } else {
      newDirtyFields.remove(field);
    }

    _dirtyFields.value = newDirtyFields;
  }

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave without saving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warningOrange,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _dirtyFields.value.isEmpty,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        final shouldPop = await _showUnsavedChangesDialog();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: ref
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
                      .read(userProvider(firebaseUser.uid).notifier)
                      .build();
                  if (!mounted) return;
                  if (appUser != null) {
                    await ref
                        .read(currentUserProvider.notifier)
                        .setUser(appUser);
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
              final isMobile = AppConstants.isMobile(context);
              final cardMaxWidth = isMobile ? 500.0 : 900.0;
              final cardPadding = isMobile
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
                  : const EdgeInsets.symmetric(horizontal: 48, vertical: 48);
              final innerPadding = isMobile
                  ? const EdgeInsets.all(20.0)
                  : const EdgeInsets.all(40.0);
              return Scaffold(
                appBar: const CustomAppBar(),
                body: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    padding: cardPadding,
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: _dirtyFields,
                      builder: (context, dirtyFields, child) {
                        // Ensure userType always reflects loaded user data unless user has changed it
                        if (!dirtyFields.contains('userType') &&
                            user.userType != null &&
                            _userType != user.userType) {
                          _userType = user.userType;
                        }
                        return Container(
                          decoration: dirtyFields.isNotEmpty
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.warningOrange,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                )
                              : null,
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 18.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest
                                                  .withAlpha(179),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withAlpha(46),
                                                width: 1.2,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 6,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _userType =
                                                            UserType.person;
                                                        onChanged(
                                                          'userType',
                                                          'person',
                                                        );
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 180,
                                                      ),
                                                      curve: Curves.ease,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            (_userType ??
                                                                    UserType
                                                                        .person) ==
                                                                UserType.person
                                                            ? Theme.of(context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withAlpha(33)
                                                            : Colors
                                                                  .transparent,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 0,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .person_outline,
                                                            color:
                                                                (_userType ??
                                                                        UserType
                                                                            .person) ==
                                                                    UserType
                                                                        .person
                                                                ? Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary
                                                                : Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .onSurface
                                                                      .withAlpha(
                                                                        153,
                                                                      ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            'Person',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  (_userType ??
                                                                          UserType
                                                                              .person) ==
                                                                      UserType
                                                                          .person
                                                                  ? Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .primary
                                                                  : Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .onSurface
                                                                        .withAlpha(
                                                                          179,
                                                                        ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _userType =
                                                            UserType.group;
                                                        onChanged(
                                                          'userType',
                                                          'group',
                                                        );
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 180,
                                                      ),
                                                      curve: Curves.ease,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            (_userType ??
                                                                    UserType
                                                                        .person) ==
                                                                UserType.group
                                                            ? Theme.of(context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withAlpha(33)
                                                            : Colors
                                                                  .transparent,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 0,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .groups_outlined,
                                                            color:
                                                                (_userType ??
                                                                        UserType
                                                                            .person) ==
                                                                    UserType
                                                                        .group
                                                                ? Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary
                                                                : Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .onSurface
                                                                      .withAlpha(
                                                                        153,
                                                                      ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            'Group',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  (_userType ??
                                                                          UserType
                                                                              .person) ==
                                                                      UserType
                                                                          .group
                                                                  ? Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .primary
                                                                  : Theme.of(
                                                                          context,
                                                                        )
                                                                        .colorScheme
                                                                        .onSurface
                                                                        .withAlpha(
                                                                          179,
                                                                        ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0,
                                            ),
                                            child: Text(
                                              'A "Person" account is for individuals. A "Group" account is for organizations, collectives, or teams.',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withAlpha(174),
                                                fontSize: 13.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          UserAvatar(
                                            userId: user.id,
                                            radius: 50,
                                            borderWidth: 1,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF4FC3F7),
                                                          Color(0xFF1976D2),
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                  border: Border.all(
                                                    color: AppColors.white,
                                                    width: 2.2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(46),
                                                      blurRadius: 10,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 17,
                                                  ),
                                                  onPressed: () {
                                                    // Optionally implement photo picker
                                                  },
                                                  tooltip: 'Change Photo',
                                                  splashRadius: 18,
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _userType == UserType.group
                                          ? 'Group Profile'
                                          : 'Profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (_userType == UserType.group)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Text(
                                          'This account represents a group or organization. Some fields may be different.',
                                          style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontSize: 13,
                                          ),
                                          // textAlign: TextAlign.center,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        if (dirtyFields.isEmpty) {
                                          return const SizedBox.shrink();
                                        }
                                        return _unsavedChangesWarning();
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        return TextFormField(
                                          initialValue: user.name,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            prefixIcon: const Icon(
                                              Icons.person_outline,
                                            ),
                                            enabledBorder:
                                                dirtyFields.contains('name')
                                                ? const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .warningOrange,
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          onChanged: (v) =>
                                              onChanged('name', v),
                                          onSaved: (v) => _name = v,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        return TextFormField(
                                          initialValue: user.email,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: const Icon(
                                              Icons.email_outlined,
                                            ),
                                            enabledBorder:
                                                dirtyFields.contains('email')
                                                ? const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .warningOrange,
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          onChanged: (v) =>
                                              onChanged('email', v),
                                          onSaved: (v) => _email = v,
                                        );
                                      },
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ValueListenableBuilder<Set<String>>(
                                            valueListenable: _dirtyFields,
                                            builder: (context, dirtyFields, child) {
                                              return TextFormField(
                                                initialValue:
                                                    user.location?.city,
                                                decoration: InputDecoration(
                                                  labelText: 'City',
                                                  enabledBorder:
                                                      dirtyFields.contains(
                                                        'city',
                                                      )
                                                      ? const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: AppColors
                                                                .warningOrange,
                                                            width: 2,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                onChanged: (v) =>
                                                    onChanged('city', v),
                                                onSaved: (v) => _city = v,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ValueListenableBuilder<Set<String>>(
                                            valueListenable: _dirtyFields,
                                            builder: (context, dirtyFields, child) {
                                              return TextFormField(
                                                initialValue:
                                                    user.location?.state,
                                                decoration: InputDecoration(
                                                  labelText: 'State',
                                                  enabledBorder:
                                                      dirtyFields.contains(
                                                        'state',
                                                      )
                                                      ? const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: AppColors
                                                                .warningOrange,
                                                            width: 2,
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                                onChanged: (v) =>
                                                    onChanged('state', v),
                                                onSaved: (v) => _state = v,
                                              );
                                            },
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
                                            _country = country.name;
                                            onChanged('country', country.name);
                                          },
                                          favorite: const ['US'],
                                          useSafeArea: true,
                                        );
                                      },
                                      child: AbsorbPointer(
                                        child: ValueListenableBuilder<Set<String>>(
                                          valueListenable: _dirtyFields,
                                          builder: (context, dirtyFields, child) {
                                            return TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Country',
                                                enabledBorder:
                                                    dirtyFields.contains(
                                                      'country',
                                                    )
                                                    ? const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: AppColors
                                                              .warningOrange,
                                                          width: 2,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              controller: TextEditingController(
                                                text:
                                                    _country ??
                                                    user.location?.country ??
                                                    '',
                                              ),
                                              onSaved: (v) => _country = v,
                                            );
                                          },
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const Text(
                                      'Please enter only your username, not the full link, for each social platform.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        return TextFormField(
                                          initialValue:
                                              user.socialLinks?.youtube,
                                          decoration: InputDecoration(
                                            labelText: 'YouTube Username',
                                            hintText:
                                                'Enter your YouTube username',
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 8,
                                              ),
                                              child: FaIcon(
                                                FontAwesomeIcons.youtube,
                                                size: 22,
                                                color: Color(
                                                  0xFFFF0000,
                                                ), // YouTube Red
                                              ),
                                            ),

                                            enabledBorder:
                                                dirtyFields.contains('youtube')
                                                ? const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .warningOrange,
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return null;
                                            }
                                            final valid = RegExp(
                                              r'^[A-Za-z0-9._-]{3,}$',
                                            ).hasMatch(v);
                                            if (!valid) {
                                              return 'Enter a valid YouTube username';
                                            }
                                            return null;
                                          },
                                          onChanged: (v) =>
                                              onChanged('youtube', v),
                                          onSaved: (v) => _youtube = v,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        return TextFormField(
                                          initialValue:
                                              user.socialLinks?.instagram,
                                          decoration: InputDecoration(
                                            labelText: 'Instagram Username',
                                            hintText:
                                                'Enter your Instagram username',
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                              ),
                                              child: FaIcon(
                                                FontAwesomeIcons.instagram,
                                                size: 22,
                                                color: Color(
                                                  0xFFE1306C,
                                                ), // Instagram pink
                                              ),
                                            ),
                                            enabledBorder:
                                                dirtyFields.contains(
                                                  'instagram',
                                                )
                                                ? const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .warningOrange,
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return null;
                                            }
                                            final valid = RegExp(
                                              r'^[A-Za-z0-9._]{1,30}$',
                                            ).hasMatch(v);
                                            if (!valid) {
                                              return 'Enter a valid Instagram username';
                                            }
                                            return null;
                                          },
                                          onChanged: (v) =>
                                              onChanged('instagram', v),
                                          onSaved: (v) => _instagram = v,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        return TextFormField(
                                          initialValue:
                                              user.socialLinks?.tiktok,
                                          decoration: InputDecoration(
                                            labelText: 'TikTok Username',
                                            hintText:
                                                'Enter your TikTok username',
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                              ),
                                              child: FaIcon(
                                                FontAwesomeIcons.tiktok,
                                                size: 22,
                                                color: Colors.black,
                                                // TikTok black
                                              ),
                                            ),
                                            enabledBorder:
                                                dirtyFields.contains('tiktok')
                                                ? const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .warningOrange,
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return null;
                                            }
                                            final valid = RegExp(
                                              r'^[A-Za-z0-9._]{2,24}$',
                                            ).hasMatch(v);
                                            if (!valid) {
                                              return 'Enter a valid TikTok username';
                                            }
                                            return null;
                                          },
                                          onChanged: (v) =>
                                              onChanged('tiktok', v),
                                          onSaved: (v) => _tiktok = v,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        return TextFormField(
                                          initialValue:
                                              user.socialLinks?.website,
                                          decoration: InputDecoration(
                                            labelText: 'Website',
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                              ),
                                              child: FaIcon(
                                                FontAwesomeIcons.link,
                                                size: 22,
                                              ),
                                            ),
                                            enabledBorder:
                                                dirtyFields.contains('website')
                                                ? const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .warningOrange,
                                                      width: 2,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          onChanged: (v) =>
                                              onChanged('website', v),
                                          onSaved: (v) => _website = v,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    ValueListenableBuilder<Set<String>>(
                                      valueListenable: _dirtyFields,
                                      builder: (context, dirtyFields, child) {
                                        if (dirtyFields.isEmpty) {
                                          return const SizedBox.shrink();
                                        }
                                        return _unsavedChangesWarning();
                                      },
                                    ),
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                Scaffold(body: Center(child: Text('Error: $err'))),
          ),
    );
  }
}
