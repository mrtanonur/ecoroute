import 'package:ecoroute/core/widgets/ecoroute_button.dart';
import 'package:ecoroute/core/widgets/ecoroute_google_apple_sign_in.dart';
import 'package:ecoroute/core/widgets/ecoroute_textformfield.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/views/email_verification_view.dart';
import 'package:ecoroute/views/home_view.dart';
import 'package:ecoroute/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
    if (status == AuthStatus.verificationProcess) {
      _authViewModel!.storeUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.checkYourEmail)),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationView()),
        (route) => false,
      );
    } else if (status == AuthStatus.signIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
        (route) => false,
      );
    } else if (status == AuthStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AssetConstants.ecorouteTransparent,
                  height: SizeConstants.s200,
                ),
                SignUpForm(),

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
                    Text(AppLocalizations.of(context)!.ifYouHaveAnAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInView()),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.signIn),
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

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
          EcorouteTextFormfield(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterYourConfirmPassword;
              }

              return null;
            },
            hintText: AppLocalizations.of(context)!.confirmPassword,
            controller: _confirmPasswordController,
            obscureText: true,
          ),

          EcorouteButton(
            isLoading: isLoading,
            onTap: () async {
              if (_confirmPasswordController.text == _passwordController.text) {
                if (_globalKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  await context.read<AuthViewModel>().signUp(
                    _emailController.text,
                    _passwordController.text,
                  );

                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
            text: AppLocalizations.of(context)!.signUp,
          ),
        ],
      ),
    );
  }
}
