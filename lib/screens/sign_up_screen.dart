import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/app/helper/message_helper.dart';
import 'package:todo_list_with_getx/controller/user_controller.dart';

import '../app/enums/message_enum.dart';
import '../constants/route_constants.dart';
import '../constants/string_constants.dart';
import '../viewmodel/user_viewmodel.dart';
import '../widgets/common/appbar.dart';

class SignUpScreen extends StatelessWidget {
  final userController = Get.find<UserController>();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: StringConstants.register),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: _singupForm(context),
          ),
        ),
      ),
    );
  }

  Form _singupForm(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _inputText(_nameController, 1, StringConstants.registerMinNameLength,
              StringConstants.registerNameHint, Icons.person),
          const SizedBox(
            height: 20,
          ),
          _inputText(
              _surnameController,
              1,
              StringConstants.registerMinSurNameLength,
              StringConstants.registerSurnameHint,
              Icons.person),
          const SizedBox(
            height: 20,
          ),
          _inputText(_emailController, 4, StringConstants.registerMinMailLength,
              StringConstants.registerMailAddressHint, Icons.mail),
          const SizedBox(
            height: 20,
          ),
          _inputText(
              _passwordController,
              5,
              StringConstants.registerMinPasswordLength,
              StringConstants.registerPasswordHint,
              Icons.key,
              obsecure: true),
          const SizedBox(
            height: 20,
          ),
          _inputText(
              _passwordAgainController,
              5,
              StringConstants.registerMinPasswordLength,
              StringConstants.registerPasswordAgainHint,
              Icons.key,
              obsecure: true),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 60,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  side: const BorderSide(width: 0, color: Colors.black)),
              onPressed: userController.isEnableButton.value
                  ? () async {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        userController.isEnableButton.value = false;
                        var response = await userController.saveUser(
                            UserViewModel(
                                name: _nameController.text,
                                surname: _surnameController.text,
                                email: _emailController.text,
                                password: _passwordAgainController.text,
                                rePassword: _passwordAgainController.text));

                        if (response) {
                          Get.offNamedUntil(
                              RouteConstants.mainScreen, (route) => false);
                        } else {
                          MessageHelper(
                                  mainCointext: context,
                                  messageTypes: MessageTypes.info,
                                  messageStyles: MessageStyles.minimal,
                                  title: 'Bilgi',
                                  message:
                                      'Kayıt başarısız, bilgileri kontrol ediniz.')
                              .ShowMessage();
                        }
                        userController.isEnableButton.value = true;
                      }
                    }
                  : () {},
              child: const Center(
                child: Text(
                  StringConstants.registerRegisterHint,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _inputText(TextEditingController? controller, int number,
      String mingLengthNotify, String hintText, IconData icon,
      {bool obsecure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      validator: (value) =>
          (value ?? '').length > number ? null : mingLengthNotify,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        prefixIconColor: Colors.black,
        fillColor: Colors.grey.shade300,
        filled: true,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
