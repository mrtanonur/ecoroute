import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/core/widgets/ecoroute_button.dart';
import 'package:ecoroute/core/widgets/ecoroute_textformfield.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: EcorouteAppBar(
        title: AppLocalizations.of(context)!.forgotPassword,
        color: Theme.of(context).colorScheme.surfaceBright,
        hasLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetConstants.ecorouteTransparent,
                height: SizeConstants.s200,
              ),
              SizedBox(height: SizeConstants.s36),
              Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.inOrderToGetAResetEmail,
              ),
              SizedBox(height: SizeConstants.s36),

              ForgotPasswordForm(),
              SizedBox(height: SizeConstants.s36),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInView()),
                    (route) => false,
                  );
                },
                child: Text(AppLocalizations.of(context)!.goToSignInPage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          EcorouteTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourEmail;
              }
              return null;
            },
            hintText: AppLocalizations.of(context)!.email,
            controller: _emailController,
            obscureText: false,
          ),
          SizedBox(height: SizeConstants.s24),

          EcorouteButton(
            isLoading: isLoading,
            onTap: () {
              if (_globalKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                context.read<AuthViewModel>().sendPasswordResetEmail(
                  _emailController.text,
                );
                setState(() {
                  isLoading = false;
                });
              }
            },
            text: AppLocalizations.of(context)!.sendEmail,
          ),
        ],
      ),
    );
  }
}
