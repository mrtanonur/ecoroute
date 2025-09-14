import 'package:ecoroute/core/utils/constants/size_constants.dart';
import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: EcorouteAppBar(
        color: Theme.of(context).colorScheme.surfaceBright,
        title: AppLocalizations.of(context)!.language,
        hasLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SizeConstants.s24),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox.adaptive(
                    value:
                        context.watch<MainViewModel>().language == Languages.en,
                    onChanged: (value) {
                      context.read<MainViewModel>().changeLanguage(
                        Languages.en,
                      );
                    },
                  ),
                  Text("English"),
                ],
              ),
              Row(
                children: [
                  Checkbox.adaptive(
                    value:
                        context.watch<MainViewModel>().language == Languages.tr,
                    onChanged: (value) {
                      context.read<MainViewModel>().changeLanguage(
                        Languages.tr,
                      );
                    },
                  ),
                  Text("Turkish"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
