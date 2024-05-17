import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/enums/message_enum.dart';
import '../app/helper/message_helper.dart';
import '../constants/image_constants.dart';
import '../constants/route_constants.dart';
import '../constants/string_constants.dart';
import '../controller/user_controller.dart';
import '../viewmodel/sign_in_viewmodel.dart';
import '../widgets/sign_in/sign_in_custom_input_widget.dart';

class SignInScreen extends StatelessWidget {
  final userController = Get.put(UserController());

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned(
                    top: 50,
                    child: Image(
                      height: 140,
                      width: 100,
                      image: AssetImage(ImageConstants.logo),
                    ),
                  ),
                  SignInCustomInputWidget(
                    context: context,
                    controller: _emailController,
                    hintText: StringConstants.signInUserEmailHintText,
                    top: 210,
                    width: MediaQuery.of(context).size.width - 45,
                    icon: Icons.person,
                  ),
                  SignInCustomInputWidget(
                    context: context,
                    controller: _passwordController,
                    obscureText: true,
                    hintText: StringConstants.signInUserPasswordHintText,
                    top: 290,
                    width: MediaQuery.of(context).size.width - 50,
                    icon: Icons.key,
                  ),
                  // Positioned(
                  //   top: 380,
                  //   right: 30,
                  //   child: TextButton(
                  //     child: const Text(
                  //       StringConstants.signInForgetPasswordText,
                  //       style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 18),
                  //     ),
                  //     onPressed: () {
                  //       // Navigator.pushNamed(
                  //       //     context, RouteCostants.forgotPasswordView);
                  //     },
                  //   ),
                  // ),
                  Positioned(
                    top: 420,
                    height: 60,
                    width: MediaQuery.of(context).size.width - 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          side:
                              const BorderSide(width: 0, color: Colors.black)),
                      onPressed: userController.isEnableButton.value
                          ? () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                userController.isEnableButton.value = false;
                                userController.signIn(SignInViewModel(
                                    _emailController.text,
                                    _passwordController.text));
                                userController.isEnableButton.value = true;
                              } else {
                                MessageHelper(
                                        mainCointext: context,
                                        messageTypes: MessageTypes.info,
                                        messageStyles: MessageStyles.minimal,
                                        title: StringConstants
                                            .loginInfoMessageTitle,
                                        message:
                                            StringConstants.loginInfoMessage)
                                    .ShowMessage();
                              }
                            }
                          : () {},
                      child: const Center(
                        child: Text(
                          StringConstants.signInButtonText,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        child: const Text(
                          StringConstants.signInRegisterButtonText,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteConstants.signUpScreen);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
