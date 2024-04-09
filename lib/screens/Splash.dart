import 'package:bill_project/screens/authentication/login.dart';
import 'package:bill_project/screens/home/Home.dart';
import 'package:bill_project/utils/Preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../conponents/Widgets.dart';
import '../utils/methods.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        intiOverLay();
        String email = await Preferences().getPrefString(Preferences.prefEmail);
        String password =
            await Preferences().getPrefString(Preferences.prefPassword);
        if (email.isNotEmpty) {
          sign(email, password);
        } else {
          Get.off(() => Login());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Splash"),
      ),
    );
  }

  Future<void> sign(String email, String password) async {
    getOverlay();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) async {
        if (value.user != null) {
          Get.offAll(() => Home());
        }
        removeOverlay();
      },
      onError: (error) {
        removeOverlay();
        print(error.code);
        showSnackBarWithText("Invalid Credential!");
      },
    );
  }
}
