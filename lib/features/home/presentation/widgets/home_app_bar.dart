import 'package:crafty_bay/app/providers/auth_controller.dart';
import 'package:crafty_bay/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/profile/presentation/screens/profile_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/asset_paths.dart';
import 'circle_icon_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(AssetPaths.navLogoSvg),
      actions: [
        CircleIconButton(
          icon: Icons.person_outline,
          onTap: () async {
            if (await AuthController.isLoggedIn() == false) {
              if (!context.mounted) return;
              Navigator.pushNamed(context, SignInScreen.name);
              return;
            }
            if (!context.mounted) return;
            Navigator.pushNamed(context, ProfileDetailsScreen.name);
          },
        ),
        const SizedBox(width: 8),
        CircleIconButton(icon: Icons.call, onTap: () {}),
        const SizedBox(width: 8),
        CircleIconButton(
          icon: Icons.notifications_active_outlined,
          onTap: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
