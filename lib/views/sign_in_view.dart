import 'package:ecoroute/core/widgets/ecoroute_button.dart';
import 'package:ecoroute/core/widgets/ecoroute_google_apple_sign_in.dart';
import 'package:ecoroute/core/widgets/ecoroute_textformfield.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/views/forgot_password_view.dart';
import 'package:ecoroute/views/home_view.dart';
import 'package:ecoroute/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  AuthViewModel? _authViewModel;

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

  void authListener() {
    final status = context.read<AuthViewModel>().status;
    if (status == AuthStatus.failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_authViewModel!.error!)));
    } else if (status == AuthStatus.signIn) {
      _authViewModel!.getUserData();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
        (route) => false,
      );
    } else if (status == AuthStatus.unVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseVerifyYourEmail),
        ),
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AssetConstants.ecorouteTransparent,
                  height: SizeConstants.s200,
                ),
                SignInForm(),
                SizedBox(height: SizeConstants.s24),
                Text(AppLocalizations.of(context)!.orContinueWith),
                SizedBox(height: SizeConstants.s48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EcorouteGoogleAppleSignIn(
                      onTap: () async {
                        await context.read<AuthViewModel>().appleSignIn();
                      },
                      name: AssetConstants.appleLogo,
                      width: 54,
                    ),
                    SizedBox(width: SizeConstants.s48),
                    EcorouteGoogleAppleSignIn(
                      onTap: () async {
                        await context.read<AuthViewModel>().googleSignIn();
                      },
                      name: AssetConstants.googleLogo,
                      width: 54,
                    ),
                  ],
                ),
                SizedBox(height: SizeConstants.s48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.ifYouDontHaveAnAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpView()),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.signUp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          EcorouteTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourPassword;
              }

              return null;
            },
            hintText: AppLocalizations.of(context)!.password,
            controller: _passwordController,
            obscureText: true,
          ),
          Padding(
            padding: const EdgeInsets.only(right: SizeConstants.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordView(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.forgotPassword),
                ),
              ],
            ),
          ),
          EcorouteButton(
            isLoading: isLoading,
            onTap: () async {
              if (_globalKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await context.read<AuthViewModel>().signIn(
                  _emailController.text,
                  _passwordController.text,
                );

                setState(() {
                  isLoading = false;
                });
              }
            },
            text: AppLocalizations.of(context)!.signIn,
          ),
        ],
      ),
    );
  }
}
