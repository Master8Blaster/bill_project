import 'package:bill_project/Database/DatabaseHelper.dart';
import 'package:bill_project/utils/Preferences.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:bill_project/utils/methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../firebase/keys.dart';
import '../../utils/colors.dart';
import 'models/ProductModel.dart';

class HomeController extends GetxController {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<ProductModel> listProduct = <ProductModel>[];
  RxList<ProductModel> listSearchedProduct = <ProductModel>[].obs;

  RxBool isLoading = true.obs;

  List<ProductModel> listCartProduct = <ProductModel>[].obs;
  RxDouble total = 0.0.obs;
  RxInt totalQuantity = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getData();
  }

  getData() async {
    try {
      isLoading.trigger(true);
      String userId = await Preferences().getPrefString(Preferences.prefUserId);
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("$keyUsers/$userId/$keyProduct");
      DatabaseEvent event = await ref.once();
      print("Response ${event.type}");
      listProduct.clear();
      listSearchedProduct.clear();
      print("Response ${event.snapshot.children.length}");
      for (DataSnapshot snapshot in event.snapshot.children) {
        listProduct.add(
          ProductModel(
            productKey: snapshot.key ?? "",
            name: snapshot.child(keyProductName).value.toString(),
            price: double.tryParse(
                    snapshot.child(keyProductPrice).value.toString()) ??
                0.0,
            pQuantity: int.tryParse(
                    snapshot.child(keyProductQuantity).value.toString()) ??
                0,
            imageUrl: snapshot.child(keyProductImageUrl).value.toString(),
            imageName: snapshot.child(keyProductImageName).value.toString(),
          ),
        );
      }
      mapWithCart();
    } catch (e) {
      print("GETDATA ${e.toString()}");
    } finally {
      isLoading.trigger(false);
    }
  }

  Future<void> deleteProduct(String key) async {
    try {
      getOverlay();
      String userId = await Preferences().getPrefString(Preferences.prefUserId);
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("$keyUsers/$userId/$keyProduct/$key");
      await ref.remove();
      getData();
      databaseHelper.deleteProduct(key);
      removeOverlay();
    } catch (e) {
      print("ERROR DELETE : $e");
    }
  }

  search(String value) {
    listSearchedProduct.clear();
    if (value.isNotEmpty) {
      listSearchedProduct = listProduct
          .where((model) {
            return model.name.contains(value);
          })
          .toList()
          .obs;
    } else {
      listSearchedProduct.addAll(listProduct);
    }
  }

  //CART
  mapWithCart() async {
    List<ProductModel> list = await databaseHelper.getCartProducts();
    for (ProductModel m in listProduct) {
      for (ProductModel model in list) {
        if (model.productKey == m.productKey) {
          m.quantity = model.quantity;
        }
      }
    }
    listCartProduct.clear();
    listCartProduct.addAll(list);
    search("");
    calculateCart();
  }

  Future<void> addToCartProduct(ProductModel model) async {
    databaseHelper.addToCart(model);
    mapWithCart();
  }

  Future<void> increaseCartProduct(ProductModel model) async {
    model.quantity++;
    databaseHelper.updateProduct(model);
    mapWithCart();
  }

  Future<void> decreaseCartProduct(ProductModel model) async {
    if (model.quantity == 1) {
      model.quantity--;
      databaseHelper.deleteProduct(model.productKey);
    }
    if (model.quantity > 0) {
      model.quantity--;
      databaseHelper.updateProduct(model);
    }
    mapWithCart();
  }

  calculateCart() {
    double totalPrice = 0;
    int qty = 0;

    for (ProductModel model in listProduct) {
      if (model.quantity > 0) {
        totalPrice = totalPrice + (model.quantity * model.price);
        qty = qty + model.quantity.value;
      }
    }
    total.trigger(totalPrice);
    totalQuantity.trigger(qty);
  }

  void checkout() {
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
                  "Pick Payment Mode",
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
                    'Cash',
                  ),
                  leading: const Icon(
                    Icons.attach_money_rounded,
                    color: colorPrimary,
                  ),
                  onTap: () async {},
                ),
                ListTile(
                  title: const Text(
                    'Online',
                  ),
                  leading: const Icon(
                    Icons.qr_code_2_rounded,
                    color: colorPrimary,
                  ),
                  onTap: () async {
                    showBottomDialogWithQr();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Card',
                  ),
                  leading: const Icon(
                    Icons.credit_card_rounded,
                    color: colorPrimary,
                  ),
                  onTap: () async {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  showBottomDialogWithQr() {
    Get.bottomSheet(BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              QrImageView(
                data:
                    "upi://pay?pa=meetdholariya203-1@okicici&am=40.00&cu=INR&pn=VIPIN",
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: spaceVertical / 2),
              Divider(
                color: colorPrimary.shade100,
                height: 1,
              ),
              const SizedBox(height: spaceVertical / 2),
              FilledButton(
                onPressed: () {},
                child: Text("Done"),
              ),
              const SizedBox(height: spaceVertical),
            ],
          ),
        );
      },
    ));
  }
}
