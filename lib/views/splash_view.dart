import 'dart:async';

import 'package:ecoroute/core/utils/constants/constants.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:ecoroute/views/home_view.dart';
import 'package:ecoroute/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  AuthViewModel? _authViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<AuthViewModel>();
    _timer = Timer(Duration(seconds: 2), () async {
      if (await authCheck()) {
        _authViewModel!.getUserData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignUpView()),
          (route) => false,
        );
      }
    });
  }

  Future<bool> authCheck() async {
    final response = await _authViewModel!.authCheck();
    return response;
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AssetConstants.ecorouteTransparent)),
    );
  }
}
