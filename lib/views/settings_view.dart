import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/core/widgets/ecoroute_button.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/view_models/main_view_model.dart';
import 'package:ecoroute/views/langauge_view.dart';
import 'package:ecoroute/views/profile_view.dart';
import 'package:ecoroute/views/sign_in_view.dart';
import 'package:ecoroute/views/theme_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  AuthViewModel? _authViewModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<AuthViewModel>();
    _authViewModel!.addListener(authListener);
  }

  @override
  void dispose() {
    _authViewModel!.removeListener(authListener);
    super.dispose();
  }

  Future authListener() async {
    AuthStatus status = context.read<AuthViewModel>().status;
    if (status == AuthStatus.signOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInView()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.youAreSignedOut)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: EcorouteAppBar(
        color: Theme.of(context).colorScheme.surfaceBright,
        title: AppLocalizations.of(context)!.settings,
        hasLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.person,
              text: AppLocalizations.of(context)!.profile,
              page: ProfileView(),
            ),
            SettingsTile(
              icon: Icons.contrast,
              text: AppLocalizations.of(context)!.theme,
              page: ThemeView(),
            ),
            SettingsTile(
              icon: Icons.language,
              text: AppLocalizations.of(context)!.language,
              page: LanguageView(),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: SizeConstants.s24),
              child: EcorouteButton(
                isLoading: isLoading,
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  context.read<MainViewModel>().resetNavigationIndex();
                  await context.read<AuthViewModel>().signOut();
                  setState(() {
                    isLoading = false;
                  });
                },

                text: AppLocalizations.of(context)!.signOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget page;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.text,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      leading: Icon(icon),
      title: Text(text),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
