import 'package:bill_project/conponents/ThemedTextField.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AddProductController.dart';

class AddProduct extends GetView<AddProductController> {
  AddProductController controller = AddProductController();

  AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
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
                  SizedBox(
                    width: Get.width / 2,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: boxBorderRadius,
                          border: Border.all(color: colorPrimary),
                          color: colorWhite,
                        ),
                        child: const Center(
                          child: Text("Please select Image"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: spaceVertical * 5),
                  ThemedTextField(
                    controller: controller.tfProductName,
                    hintText: "Product Name",
                  ),
                  const SizedBox(height: spaceVertical),
                  ThemedTextField(
                    controller: controller.tfProductPrice,
                    hintText: "Product Price",
                  ),
                  const SizedBox(height: spaceVertical),
                  Row(
                    children: [
                      const Text("Quantity :"),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_rounded),
                      ),
                      SizedBox(
                        width: 100,
                        child: ThemedTextField(
                          controller: controller.tfProductQuantity,
                          isAcceptNumbersOnly: true,
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {},
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
                          child: const Text("Clear"),
                        ),
                      ),
                      const SizedBox(width: spaceHorizontal),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            controller.saveData();
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
