import 'dart:developer';

import 'package:bill_project/conponents/Widgets.dart';
import 'package:bill_project/utils/methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  TextEditingController tfProductName = TextEditingController();
  TextEditingController tfProductPrice = TextEditingController();
  TextEditingController tfProductQuantity = TextEditingController();

  Key keyForm = GlobalKey<FormState>();

  void clearDataFromForm() {}

  Future<void> saveData() async {
    try {
      getOverlay();
      if (tfProductName.text.isEmpty) {
        showSnackBarWithText("Please enter Product Name!");
      } else if (tfProductPrice.text.isEmpty) {
        showSnackBarWithText("Please enter Product Price!");
      } else if (tfProductQuantity.text.isEmpty) {
        showSnackBarWithText("Please enter Product Quantity!");
      } else {
        DatabaseReference ref = FirebaseDatabase.instance
            .ref("users/rfgdfrgrtesgbsthrdgfhsthsrfg/products");
        final newPostKey = ref.push().key;
        if (newPostKey != null) {
          await ref.child(newPostKey!).set({
            "name": tfProductName.text.trim(),
            "price": double.parse(tfProductPrice.text.trim()),
            "qty": int.parse(tfProductQuantity.text.trim()),
          });
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      removeOverlay();
    }
  }
}
