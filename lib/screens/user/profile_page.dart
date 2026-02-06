import 'package:collective_action_frontend/app/constants.dart';
import 'package:collective_action_frontend/app/theme.dart';
import 'package:collective_action_frontend/components/custom_app_bar.dart';
import 'package:collective_action_frontend/providers/user_provider.dart';
import 'package:collective_action_frontend/screens/dashboard/components/social/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, required this.userId});

  final String userId;

  /// Shows the user profile in a dialog
  static void showProfileDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: UserProfileView(userId: userId, embedded: true),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: UserProfileView(userId: userId, showViewFullProfileButton: false),
    );
  }
}

class UserProfileView extends ConsumerWidget {
  const UserProfileView({
    super.key,
    required this.userId,
    this.showViewFullProfileButton = true,
    this.embedded = false,
  });

  final String userId;
  final bool showViewFullProfileButton;

  /// When true, renders without the outer Center/page padding.
  /// Useful for embedding inside a modal bottom sheet.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getAccountTypeWidget(String? userType) {
      IconData icon;
      String label;
      Color color;

      switch (userType?.toLowerCase()) {
        case 'person':
        case 'individual':
          icon = Icons.person;
          label = 'Person';
          color = Colors.blue.shade700;
          break;
        case 'group':
        case 'organization':
          icon = Icons.groups;
          label = 'Group';
          color = Colors.green.shade700;
          break;
        default:
          icon = Icons.account_circle;
          label = userType ?? 'User';
          color = Colors.grey.shade700;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // Widget socialLinkButton({
    //   required String label,
    //   required String displayText,
    //   required String url,
    //   required IconData icon,
    //   required Color color,
    // }) {
    //   return InkWell(
    //     onTap: () => AppConstants.openUrl(url),
    //     borderRadius: BorderRadius.circular(12),
    //     child: Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //       decoration: BoxDecoration(
    //         color: color.withAlpha(26),
    //         borderRadius: BorderRadius.circular(12),
    //         border: Border.all(color: color.withAlpha(130), width: 1),
    //       ),
    //       child: Row(
    //         children: [
    //           FaIcon(icon, size: 18, color: color),
    //           const SizedBox(width: 12),
    //           Expanded(
    //             child: Text(
    //               displayText,
    //               style: TextStyle(color: color, fontWeight: FontWeight.bold),
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //           Icon(Icons.open_in_new, size: 16, color: color.withAlpha(179)),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    final userAsync = ref.watch(userProvider(userId));
    final isMobile = AppConstants.isMobile(context);
    final cardMaxWidth = isMobile ? 520.0 : 900.0;
    final cardPadding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
        : const EdgeInsets.symmetric(horizontal: 48, vertical: 40);
    final innerPadding = isMobile
        ? const EdgeInsets.all(20)
        : const EdgeInsets.all(40);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Failed to load profile',
          style: TextStyle(color: AppColors.errorRed),
        ),
      ),
      data: (user) {
        if (user == null) return const Center(child: Text('User not found'));

        final name = (user.name ?? '').trim();
        final email = (user.email ?? '').trim();
        final city = user.location?.city?.trim();
        final state = user.location?.state?.trim();
        final country = user.location?.country?.trim();
        final location = [
          city,
          state,
          country,
        ].whereType<String>().where((s) => s.isNotEmpty).join(', ');

        final social = user.socialLinks;

        // Widget infoRow(String label, String value) {
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 6),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         SizedBox(
        //           width: isMobile ? 96 : 140,
        //           child: Text(
        //             label,
        //             style: TextStyle(
        //               color: Colors.grey.shade600,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //           child: Text(
        //             value,
        //             style: const TextStyle(fontWeight: FontWeight.w600),
        //           ),
        //         ),
        //       ],
        //     ),
        //   );
        // }

        // Core profile content (used for both full page and modal).
        final content = Padding(
          padding: innerPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatar(
                    userId: userId,
                    radius: isMobile ? 30 : 34,
                    borderWidth: 1.2,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Unnamed user' : name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (email.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              email,
                              style: TextStyle(
                                color: const Color.fromRGBO(97, 97, 97, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (showViewFullProfileButton)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: OutlinedButton(
                                onPressed: () => context.go('/profile/$userId'),
                                child: const Text('View full profile'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
              const SizedBox(height: 18),
              Text(
                'Details',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (location.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: isMobile ? 96 : 140,
                        child: Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 24,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                location,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (user.userType != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: isMobile ? 96 : 140,
                        child: Text(
                          'Account Type',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      getAccountTypeWidget(user.userType?.value),
                    ],
                  ),
                ),
              const SizedBox(height: 18),
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
              const SizedBox(height: 18),
              Text(
                'Social Links',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final socialIcons = <Widget>[];

                  if (social?.youtube != null &&
                      social!.youtube!.trim().isNotEmpty) {
                    socialIcons.add(
                      Tooltip(
                        message: social.youtube!.trim(),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => AppConstants.openUrl(
                              'https://youtube.com/@${social.youtube!.trim()}',
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF0000).withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFF0000).withAlpha(130),
                                  width: 1,
                                ),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.youtube,
                                size: 20,
                                color: const Color(0xFFFF0000),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (social?.instagram != null &&
                      social!.instagram!.trim().isNotEmpty) {
                    socialIcons.add(
                      Tooltip(
                        message: social.instagram!.trim(),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => AppConstants.openUrl(
                              'https://instagram.com/${social.instagram!.trim()}',
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE1306C).withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE1306C).withAlpha(130),
                                  width: 1,
                                ),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.instagram,
                                size: 20,
                                color: const Color(0xFFE1306C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (social?.tiktok != null &&
                      social!.tiktok!.trim().isNotEmpty) {
                    socialIcons.add(
                      Tooltip(
                        message: social.tiktok!.trim(),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => AppConstants.openUrl(
                              'https://tiktok.com/@${social.tiktok!.trim()}',
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black87.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black87.withAlpha(130),
                                  width: 1,
                                ),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.tiktok,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (social?.website != null &&
                      social!.website!.trim().isNotEmpty) {
                    socialIcons.add(
                      Tooltip(
                        message: social.website!.trim(),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                AppConstants.openUrl(social.website!.trim()),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue.shade700.withAlpha(130),
                                  width: 1,
                                ),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.link,
                                size: 20,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (socialIcons.isEmpty) {
                    return Text(
                      'No social links added',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: socialIcons,
                  );
                },
              ),
            ],
          ),
        );

        if (embedded) {
          // Modal: dialog provides the "card" chrome; keep this compact.
          return SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(24), child: content),
          );
        }

        // Full page: show the content inside a card, centered and scrollable.
        final card = Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: content,
        );

        final wrappedCard = Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: cardMaxWidth),
            padding: cardPadding,
            child: card,
          ),
        );

        return SingleChildScrollView(child: wrappedCard);
      },
    );
  }
}
