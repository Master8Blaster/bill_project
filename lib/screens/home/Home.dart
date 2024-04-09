import 'package:bill_project/conponents/ImageNetwork.dart';
import 'package:bill_project/conponents/ThemedTextField.dart';
import 'package:bill_project/screens/add_product/AddProduct.dart';
import 'package:bill_project/screens/home/HomeController.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/ProductModel.dart';

class Home extends GetView<HomeController> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Project"),
        actions: [
          Obx(
            () => !controller.isLoading.value && controller.listProduct.isEmpty
                ? IconButton.filledTonal(
                    onPressed: () {
                      controller.getData();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  )
                : Container(),
          ),
          IconButton.filledTonal(
            onPressed: () async {
              await Get.to(() => AddProduct());
              controller.getData();
            },
            icon: const Icon(Icons.add_rounded),
          ),
          const SizedBox(width: spaceHorizontal),
        ],
      ),
      body: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceHorizontal),
          child: Column(
            children: [
              const SizedBox(height: spaceVertical * 1),
              ThemedTextField(
                preFix: const Icon(Icons.search),
                onChanged: (p0) {},
              ),
              const SizedBox(height: spaceVertical * 1),
              Expanded(
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: () => controller.getData(),
                    child: controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: colorPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : controller.listProduct.isNotEmpty
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: spaceVertical / 2,
                                  crossAxisSpacing: spaceHorizontal / 2,
                                  childAspectRatio: .8,
                                ),
                                itemCount: controller.listProduct.value.length,
                                itemBuilder: (context, index) {
                                  ProductModel model =
                                      controller.listProduct[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: colorPrimary.shade300,
                                      ),
                                      borderRadius: boxBorderRadius,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          borderRadius - 2),
                                      child: Column(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Stack(
                                              children: [
                                                Material(
                                                  color: colorPrimary.shade50,
                                                  child: Center(
                                                    child: Hero(
                                                      tag: "PRODUCT-IMAGE",
                                                      child: ImageNetwork(
                                                        imageUrl:
                                                            model.imageUrl,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 5,
                                                  top: 5,
                                                  child: PopupMenuButton<int>(
                                                    itemBuilder: (context) => [
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .edit_rounded),
                                                            SizedBox(
                                                                width:
                                                                    spaceHorizontal),
                                                            Text("Edit")
                                                          ],
                                                        ),
                                                      ),
                                                      // PopupMenuItem 2
                                                      const PopupMenuItem(
                                                        value: 2,
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .delete_forever_rounded),
                                                            SizedBox(
                                                                width:
                                                                    spaceHorizontal),
                                                            Text("Delete")
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                    offset: const Offset(0, 30),
                                                    color: Colors.grey.shade50,
                                                    elevation: 2,
                                                    onSelected: (value) async {
                                                      if (value == 1) {
                                                        await Get.to(() => AddProduct(), arguments: model);
                                                        controller.getData();
                                                      } else if (value == 2) {
                                                        Get.defaultDialog(
                                                          title: "Alert!!",
                                                          middleText:
                                                              "Are you sure you want to delete this product?",
                                                          confirm: FilledButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              controller
                                                                  .deleteProduct(
                                                                      model
                                                                          .productKey);
                                                            },
                                                            child: const Text(
                                                                "Yes"),
                                                          ),
                                                          cancel: FilledButton
                                                              .tonal(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                                "No"),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: colorPrimary
                                                            .shade50,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                        spaceVertical / 2,
                                                      ),
                                                      child: const Icon(
                                                        Icons.more_vert_rounded,
                                                        color: colorPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  // child: IconButton.filledTonal(
                                                  //   onPressed: () {
                                                  //
                                                  //   },
                                                  //   icon: const Icon(
                                                  //     Icons.more_vert_rounded,
                                                  //   ),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          spaceHorizontal),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    model.name,
                                                    style: const TextStyle(
                                                      color: colorPrimary,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹${model.price}",
                                                    style: const TextStyle(
                                                      color: colorPrimary,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: Get.width - 30,
                                decoration: BoxDecoration(
                                  borderRadius: boxBorderRadius,
                                  border:
                                      Border.all(color: colorPrimary.shade100),
                                  color: colorWhite,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 40),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorPrimary.shade50,
                                      ),
                                      child: const Icon(
                                        Icons.card_travel_rounded,
                                        size: 50,
                                      ),
                                    ),
                                    const SizedBox(height: spaceVertical * 2),
                                    const Text(
                                      "Ohh.. Sorry!",
                                      style: TextStyle(
                                        color: colorPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const Text(
                                      "There is nothing to show.",
                                      style: TextStyle(
                                        color: colorPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: spaceVertical * 2),
                                    FilledButton.tonal(
                                      onPressed: () async {
                                        await Get.to(() => AddProduct());
                                        controller.getData();
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add_rounded),
                                          SizedBox(width: spaceHorizontal / 2),
                                          Text("Add Products"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
