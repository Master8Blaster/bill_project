import 'dart:developer';
import 'dart:io';

import 'package:bill_project/conponents/ImageCroper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../conponents/Widgets.dart';
import 'colors.dart';

// import 'package:image_cropper/image_cropper.dart';

// Uri getUrl(String apiName, {var params}) {
//   var uri = Uri.https(baseUrl, nestedUrl + apiName, params);
//   return uri;
// }

DateTime getTodayDate() {
  DateTime today = DateTime.now();
  return DateTime(today.year, today.month, today.day);
}

bool isValidateEmail(String value) {
  if (value.isEmpty) {
    return false; //'Enter your Email Address';
  }
//r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);

  return regex.hasMatch(value); //'Enter Valid Email Address';
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'Please enter email address';
  }
  if (!isValidateEmail(value)) {
    return 'Enter Valid Email Address';
  } else {
    return null;
  }
}

// Function to validate the
// upi_Id Code
bool isValidUpi(String upi_Id) {
  if (upi_Id.isEmpty) {
    return false;
  }

  print(RegExp(r'^[0-9A-Za-z.-]{2,256}@[A-Za-z]{2,64}$').hasMatch(upi_Id));
  return RegExp(r'^[0-9A-Za-z.-]{2,256}@[A-Za-z]{2,64}$').hasMatch(upi_Id);
}

bool _isLoading = false;
OverlayEntry? overlayEntry;
OverlayState? overlayStates;

intiOverLay() {
  _isLoading = false;
  overlayEntry = OverlayEntry(
    builder: (context) => Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 45.0,
          width: 45.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: const CircularProgressIndicator(
              color: colorPrimary,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    ),
  );
}

getOverlay() {
  print("OVERLAY : DISPLAYED");
  overlayStates = Overlay.of(Get.overlayContext!);
  if (overlayEntry != null && !_isLoading && overlayStates != null) {
    overlayStates!.insert(overlayEntry!);
    print("OVERLAY : DISPLAYED");
    _isLoading = true;
  }
}

removeOverlay() {
  print("OVERLAY :Came for REMOVED");
  if (overlayEntry != null && _isLoading) {
    _isLoading = false;
    overlayEntry!.remove();
    print("OVERLAY : REMOVED");
  }
}

buildPikeImageChooseDialog(void Function(String? image) onImagePick) async {
  Future<String?> sendForCrop(String path) async {
    log(path);
    var image = await Get.to(() => ImageCropper(image: File(path)));
    if (image != null) {
      Uint8List uint8List = image as Uint8List;
      log("LENGTH ${uint8List.length}");
      Directory cacheDirectory = await getApplicationCacheDirectory();
      log(cacheDirectory.path);
      File imageFile =
          File('${cacheDirectory.path}/${DateTime.now().millisecond}.png');

      await imageFile.writeAsBytes(uint8List);
      log("IMAGE : ${imageFile.path}");
      int byts = (await imageFile.readAsBytes()).length;
      log("IMAGE : ${byts}");

      return imageFile.path;
    } else {
      log("IMAGE : Uint8List null");
      return null;
    }
  }

  pickImageFromCamera() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 20,
    );
    if (img != null) {
      onImagePick(await sendForCrop(img.path));
    }
  }

  pickImageFromGallery() async {
    Get.back();
    final ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    if (img != null) {
      onImagePick(await sendForCrop(img.path));
    }
  }

  Get.bottomSheet(
    BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Pick Image From",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: colorPrimary.shade100,
                height: 1,
              ),
              ListTile(
                title: const Text(
                  'Camera',
                ),
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: colorPrimary,
                ),
                onTap: () async {
                  pickImageFromCamera();
                },
              ),
              ListTile(
                title: const Text(
                  'Gallery',
                ),
                leading: const Icon(
                  Icons.photo_rounded,
                  color: colorPrimary,
                ),
                onTap: () async {
                  pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

buildConfirmationDialog(
    String title, String msg, IconData icon, void Function() onYesTap,
    {bool isDelete = false, void Function()? onclose}) {
  Get.dialog(
    Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Material(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      icon,
                      color: colorWhite,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorPrimary,
                    fontSize: 30,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: colorPrimary.shade100),
            const SizedBox(height: 20),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorPrimary.shade300,
                fontSize: 18,
                height: 1,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: colorPrimary.shade100),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onYesTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorRed,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: colorWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: colorWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ).then((value) {
    if (onclose != null) onclose;
  });
}

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
