import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/core/widgets/ecoroute_button.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EcorouteAppBar(
        title: AppLocalizations.of(context)!.emailVerification,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetConstants.ecorouteTransparent),
          SizedBox(height: SizeConstants.s36),

          Text(
            AppLocalizations.of(context)!.weHaveSentYouAnEmailVerificationLink,
          ),
          SizedBox(height: SizeConstants.s48),
          Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.ifYouHaventReceivedOne,
          ),
          SizedBox(height: SizeConstants.s24),
          EcorouteButton(
            onTap: () async {
              await context.read<AuthViewModel>().sendEmailVerificationLink();
            },
            text: AppLocalizations.of(context)!.sendAgain,
          ),

          SizedBox(height: SizeConstants.s48),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInView()),
              );
            },
            child: Text(AppLocalizations.of(context)!.goToSignInPage),
          ),
        ],
      ),
    );
  }
}
