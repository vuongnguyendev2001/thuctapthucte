import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/enums/snack_bar_type.dart';
import '../constants/phone_util.dart';
import '../constants/ui_helper.dart';
import '../controllers/route_manager.dart';
import '../models/user/user_model.dart';
import '../views/screens/layout_screen.dart';
import '../views/screens/login/login_screen.dart';

class LoginService {
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  /// Google sign in
  Future<UserCredential> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ["email"]).signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // postDetailsToFirestore();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendOTP(String phone) async {
    if (phone.isEmpty == true) {
      UIHelper.showSnackBar(
        message: 'Vui lòng nhập số điện thoại',
        type: SnackBarType.error,
      );
      return;
    }
    final isValid = await PhoneUtil.validatePhone(phone: phone);
    if (!isValid) {
      UIHelper.showSnackBar(
        message: 'Số điện thoại không hợp lệ',
        type: SnackBarType.error,
      );
      return;
    }
    final parsePhone = await PhoneUtil.parsePhone(phone: phone);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: parsePhone.international.removeAllWhitespace,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        LoginScreen.verify = verificationId;
        Get.toNamed(
          RouteManager.otpScreen,
          arguments: phone,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(minutes: 1),
    );
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  /// Google sign out
  Future<GoogleSignInAccount?> handleGoogleSignOut() async {
    try {
      return GoogleSignIn(scopes: ["email"]).signOut();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> handleSignOut() async {
    try {
      return FirebaseAuth.instance.signOut();
    } catch (error) {
      rethrow;
    }
  }

  //Handle Auth State
  Future<StreamBuilder<Object?>> handleAuthState() async {
    FirebaseAuth.instance.authStateChanges();
    return StreamBuilder(
      stream: null,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return const NavbarScreen();
        } else {
          return const LoginScreen();
        }
      }),
    );
  }

  Future<void> postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.phoneNumber == null) {
      return Get.toNamed(RouteManager.signUpScreen);
    }
    UserModel userModel = UserModel();
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.userName = user.displayName;
    userModel.phoneNumber = user.phoneNumber;
    userModel.avatar = user.photoURL;
    return await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());
  }

  Future<void> postInfoToFireStore(UserModel? userModel) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return await firebaseFirestore.collection("user").doc(userModel!.uid).set(
          userModel.toMap(),
        );
  }

  Future<bool> checkPhoneNumberExists(String userId) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      bool phoneNumberExists = userData.containsKey('phoneNumber');
      return phoneNumberExists;
    } else {
      return false; // Hoặc xử lý theo logic của bạn khi không có dữ liệu
    }
  }
}
