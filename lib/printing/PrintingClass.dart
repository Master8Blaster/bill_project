import 'dart:io';

import 'package:bill_project/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class PrintingClass {
  WidgetsToImageController controller = WidgetsToImageController();
  File? file;

  void printRisipt() {
    Get.dialog(
      StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Column(
            children: [
              Expanded(
                child: WidgetsToImage(
                  controller: controller,
                  child: const Dialog(
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text("Sr."),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Name"),
                            ),
                            Expanded(
                              child: Text("Qty"),
                            ),
                            Expanded(
                              child: Text("Price"),
                            ),
                            Expanded(
                              child: Text("Amount"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Master"),
                            ),
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Master"),
                            ),
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Master"),
                            ),
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("Master"),
                            ),
                            Expanded(
                              child: Text("1"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                            Expanded(
                              child: Text("₹10.00"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 300,
                width: Get.width,
                child: file != null
                    ? Image.file(file!)
                    : Container(
                        height: 10,
                        width: 10,
                        color: colorGreen,
                      ),
              ),
              FilledButton(
                onPressed: () async {
                  Uint8List? image = await controller.capture();
                  if (image != null) {
                    Directory d = await getApplicationDocumentsDirectory();
                    await File(
                            "${(await getApplicationDocumentsDirectory()).path}/temp.png")
                        .writeAsBytes(image)
                        .then((value) async {
                      if (await value.exists()) {
                        await value.delete();
                      }
                      file = value;
                      setState(() {});
                    });
                  }
                },
                child: Text("Done"),
              ),
            ],
          );
        },
      ),
    );
  }
}
