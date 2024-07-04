import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salon_app/screens/introduction/onboarding_screen.dart';
import 'package:salon_app/utils/constants.dart';
import 'package:salon_app/utils/functions.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
          } else if (e.code == 'invalid-credential') {}
        }
      }
    }
    // print(user);
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    try {
      // if (!kIsWeb) {
      //   await googleSignIn.signOut();
      // }
      spUtil?.remove(userKey);
      spUtil?.remove(providerKey);
      await FirebaseAuth.instance.signOut();
      await FirebaseMessaging.instance.deleteToken();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingScreen(),
            ),
            (route) => false);
      });
    } catch (e) {
      print(e);
    }
  }
}
