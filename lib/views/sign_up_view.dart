import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/firebase_auth_services.dart';
import 'package:studyglide/views/login_view.dart';
import 'package:studyglide/widgets/form_container_widget.dart';

import '../../global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isSigningUp = false;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _passwordController.addListener(checkPassword);
    _emailController.addListener(isValidEmail);
    _confirmPasswordController.addListener(passwordMatch);
  }

  void checkPassword() {
    final text = _passwordController.text;

    setState(() {
      // Regular expression to verify the password requirements
      containChar = text.length >= 8;
      containMayus = RegExp(r'[A-Z]').hasMatch(text);
      containNumber = RegExp(r'[0-9]').hasMatch(text);
      containEspecial = RegExp(r'[!@#\$&*~]').hasMatch(text);
    });
  }

  void isValidEmail() {
    final email = _emailController.text;
    setState(() {
      // Regular expression to verify the email
      final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      validEmail = emailRegex.hasMatch(email);
    });
  }

  void passwordMatch() {
    final password = _passwordController.text;
    final confirmation = _confirmPasswordController.text;
    setState(() {
      if (password == confirmation) {
        passwordEqual = true;
      } else {
        passwordEqual = false;
      }
    });
  }

  bool containChar = false;
  bool containMayus = false;
  bool containNumber = false;
  bool containEspecial = false;
  bool validEmail = false;
  bool passwordEqual = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/banner.svg",
                height: 140,
              ),
              const SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
                onChanged: (text) {},
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
                onChanged: (text) {},
              ),
              Visibility(
                  visible: !validEmail,
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Invalid Email",
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        )
                      ])),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
                onChanged: (text) {
                  checkPassword();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                isPasswordField: true,
                onChanged: (text) {
                  //
                },
              ),
              Visibility(
                  visible: !passwordEqual,
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "The password doesn´t match",
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        )
                      ])),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "The password must have at least 8 characters",
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 16,
                      color: containChar ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    "The password must have at least 1 uppercase letter",
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 16,
                      color: containMayus ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    "The password must have at least 1 special character",
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 16,
                      color: containEspecial ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    "The password must have at least 1 number",
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 16,
                      color: containNumber ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: darkBlueBottonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningUp
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign Up",
                              style: bodyTextStyle,
                            )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: subBodyTextStyle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                      },
                      child: const Text(
                        "Login",
                        style: buttonTextStyle,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    // Verificar si todos los booleanos son verdaderos
    if (!validEmail & !containChar & !containMayus & !containNumber & !containEspecial){
      showToast(message: "Fill correctly the spaces");
      return;
    }
    
    else if (!validEmail) {
      showToast(message: "Invalid Email");
      return;
    }

    else if (!containChar || !containMayus || !containNumber || !containEspecial) {
      showToast(message: "Password does not meet the requirements");
      return;
    }

    else if (!passwordEqual) {
      showToast(message: "Passwords do not match");
      return;
    }

    // Si todas las validaciones son correctas, continuar con el registro
    setState(() {
      isSigningUp = true;
    });

    // ignore: unused_local_variable
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "User is successfully created");
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happened");
    }
  }
}
