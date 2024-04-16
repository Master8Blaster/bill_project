import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../conponents/ImageNetwork.dart';
import '../../conponents/ThemedTextField.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/methods.dart';
import 'BusinessDetailController.dart';

class BusinessDetail extends GetView<BusinessDetailController> {
  BusinessDetailController controller =
      Get.find(tag: "BusinessDetailController");

  BusinessDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Detail"),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceHorizontal * 2),
          child: Form(
            key: controller.keyForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: spaceVertical * 5,
                  ),
                  Obx(
                    () => SizedBox(
                      width: Get.width / 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: boxBorderRadius,
                            border: Border.all(color: colorPrimary.shade300),
                            color: colorWhite,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadius - 1),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Material(
                              child: InkWell(
                                onTap: controller.pickupImage,
                                child: controller.model != null &&
                                        controller.imageB.value.isEmpty
                                    ? ImageNetwork(
                                        imageUrl: controller.model!.imageUrl,
                                      )
                                    : controller.imageB.value.isNotEmpty
                                        ? Image.file(
                                            File(controller.imageB.value),
                                            fit: BoxFit.fill,
                                          )
                                        : Center(
                                            child: Text(
                                              "Please select image",
                                              style: TextStyle(
                                                color: colorPrimary.shade300,
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: spaceVertical * 5),
                  ThemedTextField(
                    controller: controller.tecBName,
                    labelText: "Business Name",
                    onChanged: (p0) {
                      if (controller.keyForm.currentState != null) {
                        controller.keyForm.currentState!.validate();
                      }
                    },
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Please enter Product Name!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: spaceVertical),
                  ThemedTextField(
                    controller: controller.tecBUpiId,
                    labelText: "Business UPI Id",
                    onChanged: (p0) {
                      if (controller.keyForm.currentState != null) {
                        controller.keyForm.currentState!.validate();
                      }
                    },
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Please enter your UPI Id!";
                      }
                      if (!isValidUpi(p0)) {
                        return "Invalid Upi Id!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: spaceVertical),
                  ThemedTextField(
                    controller: controller.tecBTagLine,
                    labelText: "Business Tag Line",
                    onChanged: (p0) {
                      if (controller.keyForm.currentState != null) {
                        controller.keyForm.currentState!.validate();
                      }
                    },
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Please enter your tag line!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: spaceVertical),
                  ThemedTextField(
                    controller: controller.tecBGstNum,
                    labelText: "Business GST Number",
                    onChanged: (p0) {
                      if (controller.keyForm.currentState != null) {
                        controller.keyForm.currentState!.validate();
                      }
                    },
                  ),
                  const SizedBox(height: spaceVertical),
                  ThemedTextField(
                    controller: controller.tecBContactNum,
                    labelText: "Business Contact Number",
                    onChanged: (p0) {
                      if (controller.keyForm.currentState != null) {
                        controller.keyForm.currentState!.validate();
                      }
                    },
                  ),
                  const SizedBox(height: spaceVertical),
                  ThemedTextField(
                    labelText: "Business Address",
                    controller: controller.tecBAddress,
                    onChanged: (p0) {
                      if (controller.keyForm.currentState != null) {
                        controller.keyForm.currentState!.validate();
                      }
                    },
                  ),
                  const SizedBox(height: spaceVertical * 2),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () {
                            controller.resetData();
                          },
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: spaceHorizontal),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            controller.saveProduct();
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
