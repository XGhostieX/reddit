import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../theme/app_colors.dart';

// void displayMessage(String message, BuildContext context) {
//   var snackBar = SnackBar(
//     content: Text(message),
//     behavior: SnackBarBehavior.floating,
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
void displayMessage(String message, bool isError) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: isError ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    // gravity: ToastGravity.SNACKBAR,
    // timeInSecForIosWeb: 3,
    backgroundColor: isError ? AppColors.redColor : Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
