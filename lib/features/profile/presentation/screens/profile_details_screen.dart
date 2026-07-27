import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:crafty_bay/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/profile/presentation/providers/profile_provider.dart';
import 'package:crafty_bay/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/language_toggle.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/snack_bar_message.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/theme_toggle.dart';
import 'package:crafty_bay/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  static const String name = '/profile-details';

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.myProfile ?? 'My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n?.editProfile ?? 'Edit Profile',
            onPressed: _navigateToEditProfile,
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          if (profileProvider.isLoading) {
            return const CenteredProcessIndicator();
          }

          final user = profileProvider.userModel;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n?.noDataFound ?? 'No profile data found'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      profileProvider.getProfileData();
                    },
                    child: Text(l10n?.retry ?? 'Retry'),
                  ),
                ],
              ),
            );
          }

          String initials = '';
          if (user.firstName.isNotEmpty) {
            initials += user.firstName[0].toUpperCase();
          }
          if (user.lastName.isNotEmpty) {
            initials += user.lastName[0].toUpperCase();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.themeColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.themeColor,
                        child: Text(
                          initials.isNotEmpty ? initials : 'U',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildProfileTile(
                        context: context,
                        icon: Icons.person_outline,
                        title: l10n?.firstName ?? 'First Name',
                        value: user.firstName,
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        context: context,
                        icon: Icons.person_outline,
                        title: l10n?.lastName ?? 'Last Name',
                        value: user.lastName,
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        context: context,
                        icon: Icons.email_outlined,
                        title: l10n?.email ?? 'Email Address',
                        value: user.email,
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        context: context,
                        icon: Icons.phone_outlined,
                        title: l10n?.phoneNumber ?? 'Phone Number',
                        value: (user.phone != null && user.phone!.isNotEmpty)
                            ? user.phone!
                            : 'Not set',
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        context: context,
                        icon: Icons.location_city_outlined,
                        title: l10n?.city ?? 'City',
                        value: (user.city != null && user.city!.isNotEmpty)
                            ? user.city!
                            : 'Not set',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.palette_outlined, color: AppColors.themeColor),
                        title: Text(l10n?.themeMode ?? 'Theme Mode'),
                        trailing: const ThemeToggle(),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.language_outlined, color: AppColors.themeColor),
                        title: Text(l10n?.language ?? 'Language'),
                        trailing: const LanguageToggle(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _navigateToEditProfile,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: Text(
                          l10n?.editProfile ?? 'Edit Profile',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _onTapLogout,
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: Text(
                          l10n?.logOut ?? 'Log Out',
                          style: const TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: AppColors.themeColor),
      title: Text(
        title,
        style: textTheme.labelLarge,
      ),
      subtitle: Text(
        value,
        style: textTheme.titleMedium?.copyWith(fontSize: 15),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.pushNamed(context, EditProfileScreen.name);
  }

  Future<void> _onTapLogout() async {
    await AuthController.clearUserData();
    if (mounted) {
      showSnackBarMessage(context, 'Logged out successfully');
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.name,
        (route) => false,
      );
    }
  }
}
