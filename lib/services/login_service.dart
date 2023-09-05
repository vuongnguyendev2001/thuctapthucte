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
import '../views/screens/layout/layout_screen.dart';
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

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUpAccount(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInAccount(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> typeAccount(String typeAccount, String emailAddress) async {
    fireStore.collection('user').doc(firebaseAuth.currentUser!.uid).set({
      "email": emailAddress,
      "type": typeAccount,
      "uid": firebaseAuth.currentUser!.uid,
    });
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

  Future<String?> checkUserType() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('user').doc(user.uid);
      final userData = await userDoc.get();
      if (userData.exists) {
        final userType = userData.data()?['type'];
        if (userType == 'Sinh viên') {
          return 'Sinh viên';
        } else if (userType == 'Giáo vụ') {
          return 'Giáo vụ';
          // Thực hiện các hành động cho tài khoản người dùng.
        } else if (userType == 'Nhân viên') {
          return 'Nhân viên';
          // Thực hiện các hành động cho tài khoản người dùng.
        } else if (userType == 'Giảng viên') {
          return 'Giảng viên';
          // Thực hiện các hành động cho tài khoản người dùng.
        } else {
          print('Tài khoản không có loại xác định.');
          // Xử lý trường hợp tài khoản không có loại cụ thể.
        }
      } else {
        print('Tài khoản không tồn tại trong Firestore.');
        // Xử lý trường hợp tài khoản không tồn tại trong Firestore.
      }
    } else {
      print('Người dùng chưa đăng nhập.');
      // Xử lý trường hợp người dùng chưa đăng nhập.
    }
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
    UserModel userModel = UserModel();
    userModel.email = user!.email!;
    userModel.uid = user.uid;
    userModel.userName = user.displayName;
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
