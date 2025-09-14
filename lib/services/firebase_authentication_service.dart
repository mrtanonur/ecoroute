import 'package:ecoroute/dependency_injection.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _firebaseAuth = sl.get<FirebaseAuth>();

  Future<bool> authCheck() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser != null) {
      if (firebaseUser.emailVerified) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Either<String, UserCredential>> signUp(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return Right(userCredential);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> sendEmailVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, User>> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  //google sign in
  Future<Either<String, void>> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      print(googleSignIn);

      final GoogleSignInAccount? googleUser = await googleSignIn
          .attemptLightweightAuthentication();
      print(googleUser);

      googleUser ?? await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser!.authentication;

      final userCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(userCredential);

      return const Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  // apple sign in
  Future<Either<String, User?>> appleSignIn() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        oAuthCredential,
      );
      return Right(userCredential.user);
    } on FirebaseAuthException catch (exception) {
      print(exception.message);
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> sendPasswordResetEmail(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
      return Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }

  Future<Either<String, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Right(null);
    } on FirebaseAuthException catch (exception) {
      return Left(exception.message!);
    }
  }
}
