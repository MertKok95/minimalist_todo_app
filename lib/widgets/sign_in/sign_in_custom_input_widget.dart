// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SignInCustomInputWidget extends StatelessWidget {
  late BuildContext context;
  late TextEditingController? controller;
  late String hintText;
  late double top;
  late double width;
  late IconData icon;

  SignInCustomInputWidget(
      {super.key,
      required this.context,
      this.controller,
      this.hintText = "",
      required this.top,
      required this.width,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      width: width,
      height: 100,
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller,
          validator: (value) => (value ?? '').length > 6 ? null : '6 ten kucuk',
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: Icon(icon),
            suffixIconColor: Colors.black,
            fillColor: Colors.grey.shade100,
            filled: true,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
