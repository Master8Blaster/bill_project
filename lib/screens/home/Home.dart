import 'package:bill_project/conponents/ImageNetwork.dart';
import 'package:bill_project/conponents/ThemedTextField.dart';
import 'package:bill_project/screens/add_product/AddProduct.dart';
import 'package:bill_project/screens/home/HomeController.dart';
import 'package:bill_project/screens/transaction_history/TransactionHistory.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/ProductModel.dart';

class Home extends GetView<HomeController> {
  HomeController controller = Get.put(HomeController(), tag: "HOMECONTROLLER");
  GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();

  RxInt column = 2.obs;

  int getGridColumnCount() {
    // print(((Get.context!.isPortrait ? Get.height :Get.width) / 180).ceil());
    return ((Get.width) / 180).ceil();
  }

  @override
  Widget build(BuildContext context) {
    column.value = ((Get.width) / 200).ceil();
    print(column.value);
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: const Text("Test Project"),
        titleSpacing: 0,
        actions: [
          Obx(
            () => !controller.isLoading.value &&
                    controller.listSearchedProduct.isEmpty
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
          Obx(
            () => controller.totalQuantity.value > 0
                ? IconButton.filledTonal(
                    onPressed: () {
                      if (_keyScaffold.currentState != null) {
                        _keyScaffold.currentState!.openEndDrawer();
                      }
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  )
                : Container(),
          ),
          const SizedBox(width: spaceHorizontal),
        ],
      ),
      endDrawer: _buildEndDrawer(),
      drawer: _buildDrawer(),
      floatingActionButton: _buildFloatingCartBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceHorizontal),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: spaceVertical * 1),
                ThemedTextField(
                  preFix: const Icon(Icons.search),
                  onChanged: (p0) => controller.search(p0),
                ),
                const SizedBox(height: spaceVertical * 1),
                Obx(
                  () => RefreshIndicator(
                    onRefresh: () => controller.getData(),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            child: CircularProgressIndicator(
                              color: colorPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : controller.listSearchedProduct.isNotEmpty
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: column.value,
                                  mainAxisSpacing: spaceVertical / 2,
                                  crossAxisSpacing: spaceHorizontal / 2,
                                  childAspectRatio: .75,
                                ),
                                padding: const EdgeInsets.only(bottom: 100),
                                itemCount:
                                    controller.listSearchedProduct.value.length,
                                itemBuilder: (context, index) {
                                  ProductModel model =
                                      controller.listSearchedProduct[index];
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
                                      child: InkWell(
                                        onTap: model.quantity.value == 0
                                            ? () {
                                                model.quantity.value++;
                                                controller
                                                    .addToCartProduct(model);
                                              }
                                            : null,
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
                                                  if (model.quantity.value > 0)
                                                    _buildCatButtonsAndCount(
                                                        model),
                                                  _buildPopupMenuWidthButton(
                                                      model),
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
                                                    Expanded(
                                                      child: Text(
                                                        model.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          color: colorPrimary,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCatButtonsAndCount(ProductModel model) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  print("INCREAMENT");
                  controller.increaseCartProduct(model);
                },
                child: Container(
                  color: colorPrimary.withAlpha(127),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: spaceVertical, horizontal: spaceHorizontal),
                      child: Icon(
                        Icons.add_rounded,
                        color: colorWhite,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  print("DECREAMENT");
                  controller.decreaseCartProduct(model);
                },
                child: Container(
                  color: colorPrimary.shade50.withAlpha(127),
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: spaceVertical, horizontal: spaceHorizontal),
                      child: Icon(
                        Icons.remove_rounded,
                        color: colorPrimary,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: colorPrimary.shade50,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(
              spaceHorizontal * 1.5,
            ),
            child: Text(
              model.quantity.value.toString(),
              style: const TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildPopupMenuWidthButton(ProductModel model) {
    return Positioned(
      right: 5,
      top: 5,
      child: PopupMenuButton<int>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.edit_rounded),
                SizedBox(width: spaceHorizontal),
                Text("Edit")
              ],
            ),
          ),
          // PopupMenuItem 2
          const PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(Icons.delete_forever_rounded),
                SizedBox(width: spaceHorizontal),
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
              middleText: "Are you sure you want to delete this product?",
              confirm: FilledButton(
                onPressed: () {
                  Get.back();
                  controller.deleteProduct(model.productKey);
                },
                child: const Text("Yes"),
              ),
              cancel: FilledButton.tonal(
                onPressed: () {
                  Get.back();
                },
                child: const Text("No"),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorPrimary.shade50,
          ),
          padding: const EdgeInsets.all(
            spaceVertical / 2,
          ),
          child: const Icon(
            Icons.more_vert_rounded,
            color: colorPrimary,
          ),
        ),
      ),
    );
  }

  _buildFloatingCartBar() {
    return Obx(
      () => AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.all(3),
          child: SizedBox(
            width: Get.width - spaceHorizontal * 2,
            height: 60,
            child: FloatingActionButton(
              onPressed: () {
                if (_keyScaffold.currentState != null) {
                  _keyScaffold.currentState!.openEndDrawer();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: colorPrimary.shade50,
              isExtended: true,
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: spaceHorizontal),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: spaceHorizontal),
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                    const SizedBox(width: spaceHorizontal * 1.5),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${controller.total.value}",
                            style: const TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 0,
                            ),
                          ),
                          Text(
                            "Qty : ${controller.totalQuantity.value}",
                            style: const TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        controller.checkout();
                        // PrintingClass().printTicket();
                      },
                      child: const Text("Checkout"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        secondChild: const SizedBox(),
        crossFadeState: controller.totalQuantity.value > 0
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        secondCurve: Curves.easeInOutSine,
        firstCurve: Curves.easeInOutSine,
        sizeCurve: Curves.easeInOutSine,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  _buildEndDrawer() {
    return SafeArea(
      child: Drawer(
        backgroundColor: colorWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: spaceVertical * 3),
              const Text(
                "Your Cart",
                style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: spaceVertical / 2),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.listCartProduct.length,
                    primary: true,
                    itemBuilder: (context, index) {
                      ProductModel model = controller.listCartProduct[index];
                      return Container(
                        height: 100,
                        margin: const EdgeInsets.only(top: spaceVertical),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: boxBorderRadius,
                          border: Border.all(
                            color: colorPrimary.shade200,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: spaceVertical / 1.5,
                          horizontal: spaceHorizontal / 1.5,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(borderRadius - 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorPrimary.shade50,
                                    offset: const Offset(0, 1),
                                    blurRadius: 1,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ImageNetwork(imageUrl: model.imageUrl),
                              ),
                            ),
                            const SizedBox(width: spaceHorizontal),
                            Expanded(
                              child: Obx(
                                () => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            model.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: colorPrimary,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "₹${model.price * model.quantity.value}",
                                          style: const TextStyle(
                                            color: colorPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: spaceVertical),
                                    Row(
                                      children: [
                                        const Text(
                                          "Qty : ",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        const SizedBox(width: spaceHorizontal),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: colorPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              controller
                                                  .increaseCartProduct(model);
                                            },
                                            child: const Icon(
                                              Icons.add_rounded,
                                              size: 24,
                                              color: colorWhite,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            model.quantity.value.toString(),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: colorPrimary,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: colorPrimary.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              controller
                                                  .decreaseCartProduct(model);
                                            },
                                            child: const Icon(
                                              Icons.remove_rounded,
                                              size: 24,
                                              color: colorPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              const SizedBox(height: spaceVertical / 2),
              Obx(
                () => Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: boxBorderRadius,
                    border: Border.all(color: colorPrimary.shade200),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: spaceVertical * 1.5,
                    horizontal: spaceHorizontal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                          Text(
                            "₹${controller.total.value}",
                            style: const TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Product Count :",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                          Text(
                            "${controller.listCartProduct.length}",
                            style: const TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity :",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                          Text(
                            "${controller.totalQuantity.value}",
                            style: const TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: spaceVertical),
              SizedBox(
                width: Get.width,
                child: FilledButton(
                  onPressed: () {
                    if (_keyScaffold.currentState != null) {
                      _keyScaffold.currentState!.closeEndDrawer();
                    }
                    controller.checkout();
                  },
                  child: const Text("Checkout"),
                ),
              ),
              const SizedBox(height: spaceVertical),
            ],
          ),
        ),
      ),
    );
  }

  _buildDrawer() {
    return SafeArea(
      child: Drawer(
        backgroundColor: colorWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: spaceHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: spaceVertical * 10),
              const Text(
                "Hii, There",
                style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              const Text(
                "master8blaster@gmail.com",
                style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: spaceVertical),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRow(
                        title: 'Transaction History',
                        leading: const Icon(Icons.history_rounded),
                        onTap: () {
                          Get.to(() => TransactionHistory());
                        },
                      )
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: spaceVertical / 2),
              const SizedBox(height: spaceVertical),
            ],
          ),
        ),
      ),
    );
  }

  _buildRow(
      {required String title,
      required Widget leading,
      void Function()? onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: leading,
          title: Text(title),
          onTap: onTap,
        ),
        const Divider(
          height: .5,
          indent: 55,
        ),
      ],
    );
  }
}
