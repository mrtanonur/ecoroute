import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class ThemeView extends StatefulWidget {
  const ThemeView({super.key});

  @override
  State<ThemeView> createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: EcorouteAppBar(
        color: Theme.of(context).colorScheme.surfaceBright,
        title: AppLocalizations.of(context)!.theme,
        hasLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SizeConstants.s24),
          child: Column(
            children: [
              themeTile(
                context.watch<MainViewModel>().theme == ThemeMode.system,
                (value) {
                  context.read<MainViewModel>().changeTheme(ThemeMode.system);
                },
                ThemeMode.system.name,
              ),
              themeTile(
                context.watch<MainViewModel>().theme == ThemeMode.light,
                (value) {
                  context.read<MainViewModel>().changeTheme(ThemeMode.light);
                },
                ThemeMode.light.name,
              ),
              themeTile(
                context.watch<MainViewModel>().theme == ThemeMode.dark,
                (value) {
                  context.read<MainViewModel>().changeTheme(ThemeMode.dark);
                },
                ThemeMode.dark.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget themeTile(bool value, void Function(bool?)? onChanged, String name) {
  return Row(
    children: [
      Checkbox.adaptive(value: value, onChanged: onChanged),
      Text(name),
    ],
  );
}
