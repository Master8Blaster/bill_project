import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';

showSnackBarWithText(String strText,
    {Color color = Colors.redAccent,
    int duration = 2,
    void Function()? onPressOfOk}) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(
      strText,
      style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins'),
    ),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.white,
      onPressed: onPressOfOk ?? () {},
    ),
    duration: Duration(seconds: duration),
  );
  if (Get.context != null) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}

Widget buildNoData({Widget? action}) {
  return Container(
    width: Get.width - 30,
    decoration: BoxDecoration(
      borderRadius: boxBorderRadius,
      border: Border.all(color: colorPrimary.shade100),
      color: colorWhite,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
        if (action != null) action,
      ],
    ),
  );
}

Widget buildLoaderIndicator() {
  return const SizedBox(
    height: 100,
    child: Center(
      child: CircularProgressIndicator(
        color: colorPrimary,
        strokeWidth: 2,
      ),
    ),
  );
}

Widget buildButtonProgressIndicator() {
  return const SizedBox(
    height: 26,
    width: 26,
    child: Center(
      child: CircularProgressIndicator(
        color: colorWhite,
        strokeWidth: 2,
      ),
    ),
  );
}

Widget buildSearch(
    TextEditingController controller, void Function(String)? onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Search here....",
        hintStyle: TextStyle(
          color: colorPrimary.shade200,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: colorPrimary.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: colorPrimary.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: colorPrimary.shade200,
          ),
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
            if (onChanged != null) {
              onChanged("");
            }
          },
          icon: Icon(Icons.close_rounded, color: colorPrimary.shade200),
        ),
        prefixIconColor: colorPrimary.shade200,
      ),
      onChanged: onChanged,
    ),
  );
}

buildConfirmationDialog({
  required String title,
  required String msg,
  required IconData icon,
  required void Function() onYesTap,
  void Function()? onNoTap,
  void Function()? onClose,
}) async {
  await Get.dialog(
    Dialog(
      backgroundColor: colorWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Material(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      icon,
                      color: colorWhite,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorPrimary,
                      fontSize: 24,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: colorPrimary.shade100),
            const SizedBox(height: 20),
            Text(
              msg,
              // "Are you sure yo want to delete this address?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorPrimary.shade300,
                fontSize: 18,
                height: 1,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: colorPrimary.shade100),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onYesTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorRed,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: colorWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      if (onNoTap != null) {
                        onNoTap();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: colorWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ).then((value) {
    if (onClose != null) {
      onClose();
    }
  });
}
