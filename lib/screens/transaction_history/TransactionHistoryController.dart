import 'package:bill_project/screens/transaction_history/models/TransactionModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../firebase/keys.dart';
import '../../utils/Preferences.dart';

class TransactionHistoryController extends GetxController {
  List<TransactionModel> listTransaction = <TransactionModel>[];
  RxList<TransactionModel> listSearchedTransaction = <TransactionModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    try {
      isLoading.trigger(true);
      String userId = await Preferences().getPrefString(Preferences.prefUserId);
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("$keyUsers/$userId/$keyTransaction");
      DatabaseEvent event = await ref.once();
      print("Response ${event.type}");
      listTransaction.clear();
      listSearchedTransaction.clear();
      print("Response ${event.snapshot.children.length}");
      for (DataSnapshot snapshot in event.snapshot.children) {
        listTransaction.add(
          TransactionModel(
            key: snapshot.key ?? "",
            totalPrice: double.tryParse(snapshot
                    .child(keyTransactionTotalPrice)
                    .value
                    .toString()) ??
                0.0,
            totalQuantity: int.tryParse(snapshot
                    .child(keyTransactionTotalQuantity)
                    .value
                    .toString()) ??
                0,
            totalProductCount: int.tryParse(snapshot
                    .child(keyTransactionTotalProductCount)
                    .value
                    .toString()) ??
                0,
            productQuantity:
                snapshot.child(keyTransactionProductQuantity).value.toString(),
            productPrice:
                snapshot.child(keyTransactionProductPrice).value.toString(),
            productIds:
                snapshot.child(keyTransactionProductIds).value.toString(),
            paymentType: int.tryParse(snapshot
                    .child(keyTransactionTotalProductCount)
                    .value
                    .toString()) ??
                0,
            dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(snapshot
                    .child(keyTransactionDateTime)
                    .value
                    .toString()) ??
                0),
          ),
        );
      }
      listSearchedTransaction.addAll(listTransaction);
    } catch (e) {
      print("GETDATA ${e.toString()}");
    } finally {
      isLoading.trigger(false);
    }
  }
}
