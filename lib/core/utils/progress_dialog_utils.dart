import 'package:flutter/material.dart';
import 'package:get/get.dart';

///common method for showing progress dialog
void showProgressDialog({bool isCancellable = false, Widget? loader}) async {
  loader ??
      Get.dialog(
        WillPopScope(
          onWillPop: () async => isCancellable,
          child: const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
  // isProgressVisible = true;
}

///show bottom sheet
void showGetBottomSheet(Widget bottomsheet, {bool isDismissible = false}) =>
    Get.bottomSheet(bottomsheet, isDismissible: isDismissible);

///show snackbar
void snackbar(String text) => ScaffoldMessenger.of(Get.context!)
    .showSnackBar(SnackBar(content: Text(text)));

void pop<T>([int count = 1]) {
  for (var i = 0; i < count; i++) {
    Get.back();
  }
}
