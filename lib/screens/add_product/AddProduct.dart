import 'package:bill_project/conponents/ThemedTextField.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AddProductController.dart';

class AddProduct extends GetView<AddProductController> {
  AddProductController controller = Get.put(AddProductController());

  AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: Get.width,
        child: GetBuilder<AddProductController>(
          builder: (context) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: spaceHorizontal * 2),
              child: Form(
                key: controller.keyForm,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: spaceVertical * 5,
                      ),
                      SizedBox(
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
                              child: Hero(
                                tag: "PRODUCT-IMAGE",
                                child: InkWell(
                                  onTap: controller.pickupImage,
                                  child: controller.isFromUpdate &&
                                          controller.imageProduct == null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              controller.modelUpdate!.imageUrl,
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              color: Colors.white,
                                              child:
                                                  Image(image: imageProvider),
                                            );
                                          },
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: colorPrimary,
                                            strokeWidth: 2,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : controller.imageProduct != null
                                          ? Image.file(
                                              controller.imageProduct!,
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
                      const SizedBox(height: spaceVertical * 5),
                      ThemedTextField(
                        controller: controller.tfProductName,
                        hintText: "Product Name",
                        onChanged: (p0) {
                          if (controller.keyForm.currentState != null) {
                            controller.keyForm.currentState!.validate();
                          }
                        },
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter Product Name!";
                          } else if (!controller.isFromUpdate && !controller.isProductIsUnique(p0)) {
                            return "Please enter different Product Name! We found this name in your Product list.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: spaceVertical),
                      ThemedTextField(
                        controller: controller.tfProductPrice,
                        hintText: "Product Price",
                        isAcceptNumbersOnly: true,
                        onChanged: (p0) {
                          if (controller.keyForm.currentState != null) {
                            controller.keyForm.currentState!.validate();
                          }
                        },
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter Product Price!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: spaceVertical),
                      Row(
                        children: [
                          const Text("Quantity :"),
                          const Spacer(),
                          IconButton.filledTonal(
                            onPressed: () {
                              controller.decreaseQuantity();
                            },
                            icon: const Icon(Icons.remove_rounded),
                          ),
                          SizedBox(
                            width: 100,
                            child: ThemedTextField(
                              controller: controller.tfProductQuantity,
                              isAcceptNumbersOnly: true,
                              maxLength: 5,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {
                              controller.increaseQuantity();
                            },
                            icon: const Icon(Icons.add_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: spaceVertical * 2),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: () {
                                controller.clearDataFromForm();
                              },
                              child: Text(
                                  controller.isFromUpdate ? "Reset" : "Clear"),
                            ),
                          ),
                          const SizedBox(width: spaceHorizontal),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                controller.saveProduct();
                              },
                              child: Text(
                                controller.isFromUpdate ? "Update" : "Save",
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
