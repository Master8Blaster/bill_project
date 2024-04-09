import 'package:bill_project/conponents/Widgets.dart';
import 'package:bill_project/screens/home/Home.dart';
import 'package:bill_project/utils/Preferences.dart';
import 'package:bill_project/utils/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  TextEditingController textControllerEmail = TextEditingController();
  TextEditingController textControllerPassword = TextEditingController();

  Future<void> onLogin() async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      getOverlay();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: textControllerEmail.text.trim(),
              password: textControllerPassword.text.trim())
          .then(
        (value) async {
          if (value.user != null) {
            String userid = value.user!.uid;
            print("USERID : $userid");
            await Preferences().setPrefString(Preferences.prefUserId, userid);
            await Preferences().setPrefString(
                Preferences.prefEmail, textControllerEmail.text.trim());
            await Preferences().setPrefString(
                Preferences.prefPassword, textControllerPassword.text.trim());
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
}
