import 'package:bill_project/utils/Preferences.dart';
import 'package:bill_project/utils/methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../firebase/keys.dart';
import 'models/ProductModel.dart';

class HomeController extends GetxController {
  RxList listProduct = [].obs;

  RxBool isLoading = true.obs;

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
      print("Response ${event.snapshot.children.length}");
      for (DataSnapshot snapshot in event.snapshot.children) {
        listProduct.add(
          ProductModel(
            productKey: snapshot.key ?? "",
            name: snapshot.child(keyProductName).value.toString(),
            price: double.tryParse(
                    snapshot.child(keyProductPrice).value.toString()) ??
                0.0,
            quantity: int.tryParse(
                    snapshot.child(keyProductQuantity).value.toString()) ??
                0,
            imageUrl: snapshot.child(keyProductImageUrl).value.toString(),
            imageName: snapshot.child(keyProductImageName).value.toString(),
          ),
        );
      }
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
      removeOverlay();
    } catch (e) {
      print("ERROR DELETE : $e");
    }
  }
}
