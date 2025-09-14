import 'package:ecoroute/dependency_injection.dart';
import 'package:ecoroute/models/user_model.dart';
import 'package:ecoroute/services/firebase_authentication_service.dart';
import 'package:ecoroute/services/firebase_firestore_service.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  initial,
  verificationProcess,
  unVerified,
  signIn,
  resetPassword,
  signOut,
  failure,
}

class AuthViewModel extends ChangeNotifier {
  AuthStatus status = AuthStatus.initial;
  final FirebaseAuthenticationService _firebaseAuthService = sl
      .get<FirebaseAuthenticationService>();
  final FirebaseFirestoreService _firebaseFirestoreService = sl
      .get<FirebaseFirestoreService>();
  UserModel? userData;
  String? error;

  Future<bool> authCheck() async {
    final response = await _firebaseAuthService.authCheck();
    return response;
  }

  Future signUp(String email, String password) async {
    final response = await _firebaseAuthService.signUp(email, password);
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (UserCredential userCredential) {
        final UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          fullName: userCredential.user!.displayName,
          signInMethod: userCredential.credential?.signInMethod,
        );
        userData = userModel;
        status = AuthStatus.verificationProcess;
      },
    );
    notifyListeners();
  }

  Future sendEmailVerificationLink() async {
    final response = _firebaseAuthService.sendEmailVerificationLink();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.verificationProcess;
      },
    );
    notifyListeners();
  }

  Future storeUserData() async {
    final response = await _firebaseFirestoreService.storeUserData(userData!);
    print(userData!);

    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
        print("store data failure");

        notifyListeners();
      },
      (_) {
        print(userData!.email);
      },
    );
  }

  Future signIn(String email, String password) async {
    final response = await _firebaseAuthService.signIn(email, password);
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (User? user) {
        if (user != null) {
          if (user.emailVerified) {
            status = AuthStatus.signIn;
          } else {
            status = AuthStatus.unVerified;
          }
        } else {
          status = AuthStatus.failure;
        }
      },
    );
    notifyListeners();
  }

  Future getUserData() async {
    final response = await _firebaseFirestoreService.getUserData();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
        print("failure");

        notifyListeners();
      },
      (UserModel userModel) {
        userData = userModel;
        print(userData!.email);
      },
    );
  }

  Future sendPasswordResetEmail(String email) async {
    final response = await _firebaseAuthService.sendPasswordResetEmail(email);
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.resetPassword;
      },
    );
    notifyListeners();
  }

  Future signOut() async {
    final response = await _firebaseAuthService.signOut();
    response.fold(
      (String errorMessage) {
        error = errorMessage;
        status = AuthStatus.failure;
      },
      (_) {
        status = AuthStatus.signOut;
      },
    );
    notifyListeners();
  }
}
