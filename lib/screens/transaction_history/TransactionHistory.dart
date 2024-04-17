import 'package:bill_project/firebase/keys.dart';
import 'package:bill_project/screens/transaction_history/models/TransactionModel.dart';
import 'package:bill_project/utils/colors.dart';
import 'package:bill_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../conponents/Widgets.dart';
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
        centerTitle: true,
        actions: [
          Obx(
            () => AnimatedSwitcher(
              duration: switcherDuration,
              child: !controller.isLoading.value
                  ? IconButton.filledTonal(
                      onPressed: () {
                        controller.getData();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                    )
                  : Container(),
            ),
          ),
          const SizedBox(width: spaceHorizontal),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: switcherDuration,
        child: Obx(
          () => controller.totalListFiltered > 0.0
              ? Container(
                  decoration: BoxDecoration(
                    color: colorPrimary.shade100,
                    borderRadius: boxBorderRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: spaceHorizontal * 2,
                    vertical: spaceVertical,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          color: colorPrimary,
                          fontSize: 14,
                          height: 0,
                        ),
                      ),
                      Text(
                        controller.totalListFiltered.value.toString(),
                        style: const TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
      body: Obx(
        () => Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => controller.openDateDialog(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: boxBorderRadius,
                    border: Border.all(color: colorPrimary.shade100),
                    color: colorPrimary.shade50,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: spaceHorizontal,
                    vertical: spaceVertical,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: spaceHorizontal,
                    vertical: spaceVertical,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 14,
                              height: 0,
                            ),
                          ),
                          Text(
                            "Tap to change",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 14,
                              height: 0,
                            ),
                          ),
                          Text(
                            "To",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 14,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat("dd MMM yyyy")
                                .format(controller.filterStartDate),
                            style: const TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 0,
                            ),
                          ),
                          Text(
                            DateFormat("dd MMM yyyy")
                                .format(controller.filterEndDate),
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.getData(),
                  child: AnimatedSwitcher(
                    duration: switcherDuration,
                    child: controller.isLoading.value
                        ? buildLoaderIndicator()
                        : controller.listSearchedTransaction.isNotEmpty
                            ? ListView.builder(
                                itemCount:
                                    controller.listSearchedTransaction.length,
                                physics: const AlwaysScrollableScrollPhysics(),
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
                                    getStringFromPaymentMode(model.paymentType),
                                  );
                                },
                              )
                            : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: buildNoData(
                                  action: FilledButton.tonal(
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

  String getStringFromPaymentMode(PaymentType type) {
    switch (type) {
      case PaymentType.CASH:
        return "Cash";
      case PaymentType.CARD:
        return "Card";
      case PaymentType.ONLINE:
        return "Online";
      default:
        return "Unknown";
    }
  }

  Widget _buildRow(String transId, String items, String quantity, String amount,
      String datetime, String tt) {
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
          color: colorPrimary.shade100,
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
              Expanded(child: Text("Qty : $quantity")),
              Expanded(child: Text("TT : $tt")),
              Expanded(
                child: Text(
                  "Amt : $amount",
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
