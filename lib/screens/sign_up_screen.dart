import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/controller/user_controller.dart';

import '../constants/string_constants.dart';
import '../viewmodel/user_viewmodel.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          StringConstants.register,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) => (value ?? '').length > 1
                        ? null
                        : StringConstants.registerMinNameLength,
                    decoration: InputDecoration(
                      hintText: StringConstants.registerNameHint,
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: Colors.black,
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _surnameController,
                    validator: (value) => (value ?? '').length > 1
                        ? null
                        : StringConstants.registerMinSurNameLength,
                    decoration: InputDecoration(
                      hintText: StringConstants.registerSurnameHint,
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: Colors.black,
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) => (value ?? '').length > 4
                        ? null
                        : StringConstants.registerMinMailLength,
                    decoration: InputDecoration(
                      hintText: StringConstants.registerMailAddressHint,
                      prefixIcon: const Icon(Icons.mail),
                      prefixIconColor: Colors.black,
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) => (value ?? '').length > 5
                        ? null
                        : StringConstants.registerPasswordLength,
                    decoration: InputDecoration(
                      hintText: StringConstants.registerPasswordHint,
                      prefixIcon: const Icon(Icons.key),
                      prefixIconColor: Colors.black,
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordAgainController,
                    obscureText: true,
                    validator: (value) => (value ?? '').length > 5
                        ? null
                        : StringConstants.registerPasswordLength,
                    decoration: InputDecoration(
                      hintText: StringConstants.registerPasswordAgainHint,
                      prefixIcon: const Icon(Icons.key),
                      prefixIconColor: Colors.black,
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 60,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          side:
                              const BorderSide(width: 0, color: Colors.black)),
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          userController.saveUser(UserViewModel(
                              name: _nameController.text,
                              surname: _surnameController.text,
                              email: _emailController.text,
                              password: _passwordAgainController.text,
                              rePassword: _passwordAgainController.text));
                        }
                      },
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
            ),
          ),
        ),
      ),
    );
  }
}
