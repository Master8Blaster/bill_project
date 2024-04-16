import 'dart:io';
import 'dart:ui';

import 'package:bill_project/utils/methods.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class ImageCropper extends StatefulWidget {
  final File image;

  const ImageCropper({super.key, required this.image});

  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  CropController? controller;

  @override
  void initState() {
    controller = CropController(
      aspectRatio: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(result: null);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Crop Image"),
          centerTitle: true,
          actions: [
            FilledButton(
              onPressed: () async {
                getOverlay();
                var bitmap = await controller!.croppedBitmap();
                var data = await bitmap.toByteData(format: ImageByteFormat.png);
                Get.back(result: data!.buffer.asUint8List());
                removeOverlay();
              },
              child: const Text("Done"),
            ),
            const SizedBox(width: spaceHorizontal),
          ],
        ),
        body: CropImage(
          image: Image.file(widget.image),
          controller: controller,
        ),
      ),
    );
  }
}
