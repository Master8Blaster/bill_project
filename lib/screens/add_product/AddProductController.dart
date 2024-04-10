import 'dart:developer';
import 'dart:io';

import 'package:bill_project/conponents/Widgets.dart';
import 'package:bill_project/firebase/keys.dart';
import 'package:bill_project/screens/home/models/ProductModel.dart';
import 'package:bill_project/utils/Preferences.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Database/DatabaseHelper.dart';
import '../home/HomeController.dart';

class AddProductController extends GetxController {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  TextEditingController tfProductName = TextEditingController();
  TextEditingController tfProductPrice = TextEditingController();
  TextEditingController tfProductQuantity = TextEditingController();
  File? imageProduct;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  HomeController controllerHome = Get.find(tag: "HOMECONTROLLER");

  ProductModel? modelUpdate;
  bool isFromUpdate = false;

  @override
  void onInit() {
    tfProductQuantity.text = "0";
    super.onInit();
    modelUpdate = Get.arguments;
    if (modelUpdate != null) {
      isFromUpdate = true;
      tfProductName.text = modelUpdate!.name;
      tfProductPrice.text = modelUpdate!.price.toString();
      tfProductQuantity.text = modelUpdate!.quantity.toString();
      update();
    }
  }

  void clearDataFromForm() {
    if (isFromUpdate) {
      tfProductName.text = modelUpdate!.name;
      tfProductPrice.text = modelUpdate!.price.toString();
      tfProductQuantity.text = modelUpdate!.quantity.toString();
      imageProduct = null;
      update();
    } else {
      tfProductName.text = "";
      tfProductPrice.text = "";
      tfProductQuantity.text = "0";
      imageProduct = null;
      update();
    }
  }

  Future<void> saveProduct() async {
    String userId = await Preferences().getPrefString(Preferences.prefUserId);

    Future<UploadTask?> uploadImage(File? file, String path) async {
      if (file == null) {
        showSnackBarWithText("No File Detected!");
        return null;
      }

      UploadTask uploadTask;

      log("uploadImage ${file.path.split(".").last}");
      // Create a Reference to the file
      Reference ref = FirebaseStorage.instance.ref(path);

      // final metadata = SettableMetadata(
      //   contentType: 'image/jpeg',
      //   customMetadata: {'picked-file-path': file.path},
      // );

      if (kIsWeb) {
        uploadTask = ref.putData(await file.readAsBytes());
      } else {
        uploadTask = ref.putFile(File(file.path));
      }

      return Future.value(uploadTask);
    }

    saveData(String imageUrl, String imageName) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("$keyUsers/$userId/$keyProduct");
      final key = isFromUpdate ? modelUpdate!.productKey : ref.push().key;
      if (key != null) {
        await ref.child(key).set({
          keyProductName: tfProductName.text.trim(),
          keyProductPrice: double.parse(tfProductPrice.text.trim()),
          keyProductQuantity: int.parse(tfProductQuantity.text.trim()),
          keyProductImageUrl: imageUrl,
          keyProductImageName: imageName,
        }).then((data) async {
          log("Image Uploaded Successfully.");
          showSnackBarWithText("Image Uploaded Successfully.",
              color: colorGreen);
          clearDataFromForm();
          if (await databaseHelper.isProductExistInCart(key)) {
            databaseHelper.updateProduct(
              ProductModel(
                productKey: key,
                name: tfProductName.text.trim(),
                price: double.parse(tfProductPrice.text.trim()),
                imageUrl: imageUrl,
                imageName: imageName,
                pQuantity: int.parse(tfProductQuantity.text.trim()),
                quantity: modelUpdate!.quantity.value,
              ),
            );
          }
          removeOverlay();
          Get.back();
        }, onError: (error, stackTrace) {
          log("errorUpload Product error.toString()");
          showSnackBarWithText("Something went wrong in Adding Product!");
          removeOverlay();
        });
      }
    }

    try {
      if (keyForm.currentState != null && keyForm.currentState!.validate()) {
        if (!isFromUpdate && imageProduct == null) {
          showSnackBarWithText("Please select Product image!");
        } else if (tfProductName.text.isEmpty) {
          showSnackBarWithText("Please enter Product Name!");
        } else if (tfProductPrice.text.isEmpty) {
          showSnackBarWithText("Please enter Product Price!");
        } else if (tfProductQuantity.text.isEmpty) {
          showSnackBarWithText("Please enter Product Quantity!");
        } else {
          getOverlay();
          await Future.delayed(const Duration(seconds: 1));
          String imageSortUrl = "";
          if (isFromUpdate && imageProduct == null) {
            imageSortUrl = modelUpdate!.imageName;
            saveData(modelUpdate!.imageUrl, imageSortUrl);
          } else {
            imageSortUrl =
                "$keyFolderUsers/$userId/$keyFolderProductImages/${tfProductName.text.trim()}.${imageProduct!.path.split(".").last}";

            UploadTask? uploadTask =
                await uploadImage(imageProduct, imageSortUrl);
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

  void increaseQuantity() {
    if (tfProductQuantity.text.trim().isNotEmpty) {
      tfProductQuantity.text =
          ((int.tryParse(tfProductQuantity.text.trim().toString()) ?? 0) + 1)
              .toString();
    } else {
      tfProductQuantity.text = 0.toString();
    }
  }

  void decreaseQuantity() {
    if (tfProductQuantity.text.trim().isNotEmpty) {
      int currentQuantity =
          int.tryParse(tfProductQuantity.text.trim().toString()) ?? 0;
      if (currentQuantity > 0) {
        tfProductQuantity.text = (currentQuantity - 1).toString();
      }
    } else {
      tfProductQuantity.text = 0.toString();
    }
  }

  void pickupImage() {
    buildPikeImageChooseDialog(
      (image) {
        if (image != null) {
          imageProduct = File(image.path);
          update();
        }
      },
    );
  }

  bool isProductIsUnique(String value) {
    bool isUnique = true;
    for (ProductModel model in controllerHome.listProduct) {
      if (model.name.toLowerCase() == value.toLowerCase()) {
        isUnique = false;
        break;
      }
    }
    return isUnique;
  }
}
