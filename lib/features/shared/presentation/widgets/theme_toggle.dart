import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/providers/theme_mode_provider.dart';
import '../../../../l10n/app_localizations.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<ThemeModeProvider>(
      builder: (context, themeModeProvider, _) {
        return DropdownButton<ThemeMode>(
          value: themeModeProvider.themeMode,
          underline: const SizedBox(),
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(l10n?.systemDefault ?? 'System'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(l10n?.light ?? 'Light'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(l10n?.dark ?? 'Dark'),
            ),
          ],
          onChanged: (newMode) {
            if (newMode != null) {
              themeModeProvider.changeThemeMode(newMode);
            }
          },
        );
      },
    );
  }
}
