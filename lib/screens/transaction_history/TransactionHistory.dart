import 'package:bill_project/screens/transaction_history/models/TransactionModel.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'TransactionHistoryController.dart';

class TransactionHistory extends GetView<TransactionHistoryController> {
  TransactionHistoryController controller =
      Get.put(TransactionHistoryController());

  TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        titleSpacing: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: () => controller.getData(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          child: CircularProgressIndicator(
                            color: colorPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : controller.listSearchedTransaction.isNotEmpty
                          ? ListView.builder(
                              itemCount:
                                  controller.listSearchedTransaction.length,
                              itemBuilder: (context, index) {
                                TransactionModel model =
                                    controller.listSearchedTransaction[index];
                                return _buildRow(
                                  model.key,
                                  model.totalProductCount.toString(),
                                  model.totalQuantity.toString(),
                                  model.totalPrice.toString(),
                                  DateFormat("dd MMM yyyy hh:mm")
                                      .format(model.dateTime),
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
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add_rounded),
                                        SizedBox(width: spaceHorizontal / 2),
                                        Text("Add Transaction"),
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
    );
  }

  Widget _buildRow(String transId, String items, String quntity, String amount,
      String datetime) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: spaceVertical / 2,
        horizontal: spaceHorizontal,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: spaceVertical,
        horizontal: spaceHorizontal,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorPrimary.shade200,
        ),
        color: colorWhite,
        borderRadius: boxBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("ID: $transId"),
              ),
              Text(
                datetime,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text("Items : $items")),
              Expanded(child: Text("Qty : $quntity")),
              Expanded(child: Text("Amount : $amount")),
            ],
          ),
        ],
      ),
    );
  }
}
