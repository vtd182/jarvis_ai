import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
  required Color textColor,
  required int durationInSeconds,
  required ShapeBorder shape,
  double? fontSize,
  EdgeInsets? padding,
  EdgeInsets? margin,
  required Icon leadIcon,
  SnackBarBehavior behavior = SnackBarBehavior.fixed,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leadIcon,
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: Duration(seconds: durationInSeconds),
    shape: shape,
    margin: margin,
    padding: padding,
    behavior: behavior,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackBar({
  required BuildContext context,
  required String message,
}) {
  showCustomSnackBar(
    context: context,
    message: message,
    backgroundColor: Colors.green.shade100,
    textColor: Colors.green.shade800,
    fontSize: 14.0,
    durationInSeconds: 3,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(18),
    leadIcon: Icon(
      Icons.check_circle,
      color: Colors.green.shade800,
      size: 20,
    ),
  );
}

void showFailSnackBar({
  required BuildContext context,
  required String message,
}) {
  showCustomSnackBar(
    context: context,
    message: message,
    backgroundColor: Colors.red.shade100,
    textColor: Colors.red.shade800,
    fontSize: 14.0,
    durationInSeconds: 3,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(18),
    leadIcon: Icon(
      Icons.error,
      color: Colors.red.shade800,
      size: 20,
    ),
  );
}
