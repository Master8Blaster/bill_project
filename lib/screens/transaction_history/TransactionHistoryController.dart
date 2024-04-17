import 'package:bill_project/screens/transaction_history/models/TransactionModel.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../firebase/keys.dart';
import '../../utils/Preferences.dart';
import '../../utils/methods.dart';

class TransactionHistoryController extends GetxController {
  List<TransactionModel> listTransaction = <TransactionModel>[];
  RxList<TransactionModel> listSearchedTransaction = <TransactionModel>[].obs;

  RxBool isLoading = true.obs;
  RxDouble totalListFiltered = 0.0.obs;

  DateTime filterStartDate = getTodayDate();
  DateTime filterEndDate = getTodayDate();

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
          FirebaseDatabase.instance.ref(getTransactionPath(userId));
      DatabaseEvent event = await ref.once();
      print("Response ${event.type}");
      listTransaction.clear();
      listSearchedTransaction.clear();
      print("Response Transaction ${event.snapshot.children.length}");
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
                    .child(keyTransactionPaymentType)
                    .value
                    .toString()) ??
                0,
            dateTime: DateTime.fromMillisecondsSinceEpoch(int.tryParse(
                    snapshot.child(keyTransactionDateTime).value.toString()) ??
                0),
          ),
        );
      }
      applyFilter();
    } catch (e) {
      print("GETDATA ${e.toString()}");
    } finally {
      isLoading.trigger(false);
    }
  }

  applyFilter() {
    print(
        "SELECTED DATE : ${DateFormat("dd MMM yyyy hh:mm").format(filterStartDate)} - ${DateFormat("dd MMM yyyy hh:mm").format(filterEndDate)}");
    listSearchedTransaction.clear();
    totalListFiltered.trigger(0.0);
    for (TransactionModel model in listTransaction) {
      print("${DateFormat("dd MMM yyyy hh:mm").format(model.dateTime)} ");
      print("1: ${model.dateTime.isAfter(filterStartDate)}");
      print(
          "2: ${model.dateTime.isBefore(filterEndDate.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)))}");
      if ((model.dateTime.isAfter(filterStartDate)) &&
          (model.dateTime.isBefore(filterEndDate
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1))))) {
        listSearchedTransaction.add(model);
        totalListFiltered.value += model.totalPrice;
      }
      listSearchedTransaction.sort(
        (a, b) {
          return a.dateTime.compareTo(b.dateTime);
        },
      );
    }
  }

  RxBool isAsParFinancialYear = false.obs;

  openDateDialog() {
    Get.dialog(
      Dialog(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: colorPrimary.shade50,
        shape: RoundedRectangleBorder(borderRadius: boxBorderRadius * 1.5),
        child: SizedBox(
          height: Get.height * .66,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: colorPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: colorPrimary.shade500,
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: spaceVertical * 1.5,
                  horizontal: spaceHorizontal,
                ),
                child: const Text(
                  "Select Date",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorWhite,
                  ),
                ),
              ),
              const SizedBox(height: spaceVertical),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRow("Today", () {
                        filterStartDate = getTodayDate();
                        filterEndDate = getTodayDate();
                        applyFilter();
                        Get.back();
                      }),
                      _buildRow("This Month", () {
                        DateTime today = getTodayDate();
                        filterStartDate = DateTime(today.year, today.month, 1);
                        filterEndDate = getTodayDate();
                        applyFilter();
                        Get.back();
                      }),
                      _buildRow("Last Month", () {
                        DateTime today = getTodayDate();
                        filterStartDate =
                            DateTime(today.year, today.month - 1, 1);
                        filterEndDate = DateTime(today.year, today.month, 0);
                        applyFilter();
                        Get.back();
                      }),
                      _buildRow("Three Month", () {
                        DateTime today = getTodayDate();
                        filterStartDate =
                            DateTime(today.year, today.month - 3, today.day);
                        filterEndDate = today;
                        applyFilter();
                        Get.back();
                      }),
                      _buildRow("Six Month", () {
                        DateTime today = getTodayDate();
                        filterStartDate =
                            DateTime(today.year, today.month - 6, today.day);
                        filterEndDate = today;
                        applyFilter();
                        Get.back();
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: spaceHorizontal),
                        child: Row(
                          children: [
                            const Expanded(
                                child: Text("Year as per financial year?")),
                            Obx(
                              () => Transform.scale(
                                scale: .7,
                                child: Switch(
                                  value: isAsParFinancialYear.value,
                                  onChanged: (value) {
                                    isAsParFinancialYear.trigger(value);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildRow("This Year", () {
                        DateTime today = getTodayDate();
                        filterStartDate = DateTime(
                            today.year, isAsParFinancialYear.value ? 4 : 1, 1);
                        filterEndDate = today;
                        applyFilter();
                        Get.back();
                      }),
                      _buildRow("Last Year", () {
                        DateTime today = getTodayDate();
                        filterStartDate = DateTime(today.year - 1,
                            isAsParFinancialYear.value ? 4 : 1, 1);
                        filterEndDate = DateTime(
                            today.year, isAsParFinancialYear.value ? 4 : 1, 0);
                        applyFilter();
                        Get.back();
                      }),
                      _buildRow("Custom", () {
                        DateTime today = getTodayDate();
                        showDateRangePicker(
                          context: Get.context!,
                          firstDate: DateTime(today.year - 10, 1, 1),
                          lastDate: today,
                        ).then((value) {
                          if (value != null) {
                            filterStartDate = value.start;
                            filterEndDate = value.end;
                            applyFilter();
                            Get.back();
                          }
                        });
                      }),
                      const SizedBox(height: spaceVertical),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRow(String title, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: boxBorderRadius,
          border: Border.all(color: colorPrimary.shade200),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: spaceVertical,
          horizontal: spaceHorizontal,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: spaceVertical / 2,
          horizontal: spaceHorizontal,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
