import 'dart:developer';
import 'dart:io';

import 'package:bill_project/screens/business_detail/models/BusinessDetailModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../conponents/Widgets.dart';
import '../../firebase/keys.dart';
import '../../utils/Preferences.dart';
import '../../utils/colors.dart';
import '../../utils/methods.dart';

class BusinessDetailController extends GetxController {
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  TextEditingController tecBName = TextEditingController();
  TextEditingController tecBUpiId = TextEditingController();
  TextEditingController tecBGstNum = TextEditingController();
  TextEditingController tecBContactNum = TextEditingController();
  TextEditingController tecBTagLine = TextEditingController();
  TextEditingController tecBAddress = TextEditingController();
  Rx<String> imageB = "".obs;

  BusinessDetailModel? model;

  @override
  onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    try {
      getOverlay();
      String userId = await Preferences().getPrefString(Preferences.prefUserId);
      DatabaseReference ref =
          FirebaseDatabase.instance.ref(getBusinessDetailsPath(userId));
      DatabaseEvent event = await ref.once();
      print("Response getData ${event.type}");

      model = BusinessDetailModel(
        name: (event.snapshot.child(keyBusinessName).value ?? "").toString(),
        upi: (event.snapshot.child(keyBusinessUpi).value ?? "").toString(),
        gstNumber:
            (event.snapshot.child(keyBusinessGstNumber).value ?? "").toString(),
        contactNumber:
            (event.snapshot.child(keyBusinessContactNumber).value ?? "")
                .toString(),
        tagLine:
            (event.snapshot.child(keyBusinessTagLine).value ?? "").toString(),
        address:
            (event.snapshot.child(keyBusinessAddress).value ?? "").toString(),
        imageName:
            (event.snapshot.child(keyBusinessImageName).value ?? "").toString(),
        imageUrl:
            (event.snapshot.child(keyBusinessImageUrl).value ?? "").toString(),
      );
      // print(model!.imageUrl);
      resetData();
    } catch (e) {
      print("GETDATA ${e.toString()}");
    } finally {
      removeOverlay();
    }
  }

  resetData() {
    if (model != null) {
      tecBName.text = model!.name ?? "";
      tecBUpiId.text = model!.upi ?? "";
      tecBGstNum.text = model!.gstNumber ?? "";
      tecBContactNum.text = model!.contactNumber ?? "";
      tecBTagLine.text = model!.tagLine ?? "";
      tecBAddress.text = model!.address ?? "";
    } else {
      tecBName.text = "";
      tecBUpiId.text = "";
      tecBGstNum.text = "";
      tecBContactNum.text = "";
      tecBTagLine.text = "";
      tecBAddress.text = "";
    }
    imageB.trigger("");
    update();
  }

  void pickupImage() {
    buildPikeImageChooseDialog(
      (image) async {
        log(image!);
        imageB.trigger(image);
        update();
      },
    );
  }

  Future<void> saveProduct() async {
    String userId = await Preferences().getPrefString(Preferences.prefUserId);

    saveData(String imageUrl, String imageName) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref(getBusinessDetailsPath(userId));

      await ref.set({
        keyBusinessName: tecBName.text,
        keyBusinessUpi: tecBUpiId.text,
        keyBusinessGstNumber: tecBGstNum.text,
        keyBusinessContactNumber: tecBContactNum.text,
        keyBusinessTagLine: tecBTagLine.text,
        keyBusinessAddress: tecBAddress.text,
        keyBusinessImageUrl: imageUrl,
        keyBusinessImageName: imageName,
      }).then((data) async {
        log("Details Updated Successfully.");
        showSnackBarWithText("Details Updated Successfully.",
            color: colorGreen);
        getData();
        removeOverlay();
      }, onError: (error, stackTrace) {
        log("errorUpload Product error.toString()");
        showSnackBarWithText("Something went wrong in Adding Product!");
        removeOverlay();
      });
    }

    try {
      if (keyForm.currentState != null && keyForm.currentState!.validate()) {
        if (imageB.value.isEmpty &&
            (model == null || model!.imageUrl.isEmpty)) {
          showSnackBarWithText("Please select Product image!");
        } else if (tecBName.text.isEmpty) {
          showSnackBarWithText("Please enter Product Name!");
        } else if (tecBUpiId.text.isEmpty) {
          showSnackBarWithText("Please enter Upi Id!");
        } else {
          getOverlay();
          await Future.delayed(const Duration(seconds: 1));
          String imageSortUrl = "";
          if (model != null && imageB.value.isEmpty) {
            imageSortUrl = model!.imageName;
            saveData(model!.imageUrl, imageSortUrl);
          } else {
            imageSortUrl =
                "${getBusinessDetailsImagePath(userId)}/${userId.trim()}_Business.${imageB.value.split(".").last}";
            UploadTask? uploadTask =
                await uploadImage(File(imageB.value), imageSortUrl);
            if (uploadTask != null) {
              uploadTask.then(
                (snapshot) async {
                  log("Image Uploaded Successfully");
                  showSnackBarWithText("Image Uploaded Successfully.",
                      color: colorGreen);
                  await saveData(await uploadTask.snapshot.ref.getDownloadURL(),
                      imageSortUrl);
                },
                onError: (e) {
                  showSnackBarWithText("Something went wrong in upload image!");
                  removeOverlay();
                },
              );
            }
          }
        }
      }
    } catch (e) {
      log("saveData ${e.toString()}");
      removeOverlay();
    }
  }
}
