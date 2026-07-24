import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:crafty_bay/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/profile/presentation/providers/profile_provider.dart';
import 'package:crafty_bay/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/centered_progress_indicator.dart';
import 'package:crafty_bay/features/shared/presentation/widgets/snack_bar_message.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
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
                  const Text('No profile data found'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      profileProvider.getProfileData();
                    },
                    child: const Text('Retry'),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildProfileTile(
                        icon: Icons.person_outline,
                        title: 'First Name',
                        value: user.firstName,
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        icon: Icons.person_outline,
                        title: 'Last Name',
                        value: user.lastName,
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        icon: Icons.email_outlined,
                        title: 'Email Address',
                        value: user.email,
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        icon: Icons.phone_outlined,
                        title: 'Phone Number',
                        value: (user.phone != null && user.phone!.isNotEmpty)
                            ? user.phone!
                            : 'Not set',
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildProfileTile(
                        icon: Icons.location_city_outlined,
                        title: 'City',
                        value: (user.city != null && user.city!.isNotEmpty)
                            ? user.city!
                            : 'Not set',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _navigateToEditProfile,
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
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
                        label: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.red),
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
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.themeColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
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
