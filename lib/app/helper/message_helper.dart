import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../enums/message_enum.dart';

class MessageHelper {
  MessageTypes messageTypes;
  MessageStyles messageStyles;
  String title;
  String message;
  BuildContext mainCointext;

  MessageHelper(
      {required this.mainCointext,
      required this.messageTypes,
      required this.messageStyles,
      required this.title,
      required this.message});

  ShowMessage() {
    toastification.show(
      context: mainCointext, // optional if you use ToastificationWrapper
      type: setMessageType(messageTypes),
      style: setMessageStyle(messageStyles),
      // autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      // you can also use RichText widget for title and description parameters
      description: RichText(
          text: TextSpan(
              text: message, style: const TextStyle(color: Colors.black))),
      alignment: Alignment.bottomCenter,
      icon: const Icon(Icons.check),
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.always,
      callbacks: ToastificationCallbacks(
        onCloseButtonTap: (toastItem) =>
            {toastification.dismissById(toastItem.id)},
      ),
    );
  }

  setMessageType(MessageTypes type) {
    switch (type) {
      case MessageTypes.success:
        return ToastificationType.success;
      case MessageTypes.info:
        return ToastificationType.info;
      case MessageTypes.warning:
        return ToastificationType.warning;
      case MessageTypes.error:
        return ToastificationType.error;
      default:
        return ToastificationType.info;
    }
  }

  setMessageStyle(MessageStyles type) {
    switch (type) {
      case MessageStyles.simple:
        return ToastificationStyle.simple;
      case MessageStyles.flat:
        return ToastificationStyle.flat;
      case MessageStyles.minimal:
        return ToastificationStyle.minimal;
      default:
        return ToastificationStyle.minimal;
    }
  }
}
