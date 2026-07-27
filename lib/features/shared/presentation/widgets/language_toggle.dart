import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/providers/locale_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return DropdownButton<Locale>(
          value: localeProvider.currentLocale,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
              value: Locale('en'),
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: Locale('bn'),
              child: Text('বাংলা'),
            ),
          ],
          onChanged: (newLocale) {
            if (newLocale != null) {
              localeProvider.changeLocale(newLocale);
            }
          },
        );
      },
    );
  }
}
