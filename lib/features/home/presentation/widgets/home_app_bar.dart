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
        CircleIconButton(icon: Icons.person, onTap: () {}),
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
