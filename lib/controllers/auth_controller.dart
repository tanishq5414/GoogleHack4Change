import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/form.dart';
import 'package:frontend/core/utils.dart';
import 'package:frontend/navigation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var auth = FirebaseAuth.instance;
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await auth.signInWithCredential(credential);

        userCredential.additionalUserInfo!.isNewUser
            ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormView();
              }))
            : Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Navigation();
              }));
      }
    } catch (e) {
      print(e);
      showSnackBar(context, e.toString());
    }
  }
}