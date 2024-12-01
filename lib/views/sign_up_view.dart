import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/firebase_auth_services.dart';
import 'package:studyglide/services/connect_alert_service.dart';
import 'package:studyglide/services/location_service.dart';
import 'package:studyglide/views/login_view.dart';
import 'package:studyglide/widgets/form_container_widget.dart';

import '../../global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSigningUp = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ignore: unused_field
  late StreamSubscription<ConnectionStatus> _connectionSubscription;
  bool _isOffline = false;
  String _connectionMessage = "";
  Color _connectionColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _passwordController.addListener(checkPassword);
    _emailController.addListener(isValidEmail);
    _confirmPasswordController.addListener(passwordMatch);
    _connectionSubscription =
        ConnectionService().connectionStatusStream.listen((status) {
      if (status == ConnectionStatus.connected) {
        _showConnectionStatus("Connection restored", Colors.green);
      } else {
        _showConnectionStatus("No internet connection", Colors.red);
      }
    });
  }

  void _showConnectionStatus(String message, Color color) {
    setState(() {
      _connectionMessage = message;
      _connectionColor = color;
      _isOffline = true;
    });

    if (color == Colors.green) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _isOffline = false;
        });
      });
    }
  }

  void checkPassword() {
    final text = _passwordController.text;

    setState(() {
      // Regular expression to verify the password requirements
      if (text.isNotEmpty) {
        if (RegExp(r'[A-Z]').hasMatch(text) &
            RegExp(r'[0-9]').hasMatch(text) &
            RegExp(r'[!@#\$&*~]').hasMatch(text) &
            (text.length >= 6)) {
          containChar = true;
          containMayus = RegExp(r'[A-Z]').hasMatch(text);
          containNumber = RegExp(r'[0-9]').hasMatch(text);
          containEspecial = RegExp(r'[!@#\$&*~]').hasMatch(text);
        } else {
          containChar = false;
          containMayus = false;
          containNumber = false;
          containEspecial = false;
        }
        passwordHasChars = true;
      } else {
        passwordHasChars = false;
      }
    });
  }

  void isValidEmail() {
    final email = _emailController.text;
    setState(() {
      // Regular expression to verify the email
      final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (email.isNotEmpty) {
        validEmail = emailRegex.hasMatch(email);
        emailHasChars = true;
      } else {
        emailHasChars = false;
      }
    });
  }

  void passwordMatch() {
    final password = _passwordController.text;
    final confirmation = _confirmPasswordController.text;
    setState(() {
      if (password.isNotEmpty) {
        passwordEqual = (password == confirmation);
        confirmHasChars = true;
      } else {
        confirmHasChars = false;
      }
    });
  }

  bool containChar = false;
  bool containMayus = false;
  bool containNumber = false;
  bool containEspecial = false;
  bool validEmail = false;
  bool passwordEqual = false;
  bool emailHasChars = false;
  bool passwordHasChars = false;
  bool confirmHasChars = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 20), // Espaciado superior opcional
                        SvgPicture.asset(
                          "assets/banner.svg",
                          height: 140,
                        ),
                        const SizedBox(height: 30),
                        FormContainerWidget(
                          controller: _usernameController,
                          hintText: "Username",
                          isPasswordField: false,
                          onChanged: (text) {},
                        ),
                        const SizedBox(height: 10),
                        FormContainerWidget(
                          controller: _emailController,
                          hintText: "Email",
                          isPasswordField: false,
                          onChanged: (text) {},
                        ),
                        Visibility(
                          visible: !validEmail & emailHasChars,
                          child: const Text(
                            "Invalid Email",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FormContainerWidget(
                          controller: _passwordController,
                          hintText: "Password",
                          isPasswordField: true,
                          onChanged: (text) {
                            checkPassword();
                          },
                        ),
                        Visibility(
                          visible: !(containChar &
                                  containEspecial &
                                  containMayus &
                                  containNumber) &
                              passwordHasChars,
                          child: const Text(
                            "6+ chars, 1 uppercase, 1 special & 1 number",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FormContainerWidget(
                          controller: _confirmPasswordController,
                          hintText: "Confirm Password",
                          isPasswordField: true,
                          onChanged: (text) {},
                        ),
                        Visibility(
                          visible: !passwordEqual & confirmHasChars,
                          child: const Text(
                            "The password doesn’t match",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: subBodyTextStyle,
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                "Login",
                                style: buttonTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_isOffline)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: _connectionColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            _connectionMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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

  void _signUp() async {
    // Verificar si todos los booleanos son verdaderos
    if (!validEmail &
        !containChar &
        !containMayus &
        !containNumber &
        !containEspecial) {
      showToast(message: "Fill correctly the spaces");
      return;
    } else if (!validEmail) {
      showToast(message: "Invalid Email");
      return;
    } else if (!containChar ||
        !containMayus ||
        !containNumber ||
        !containEspecial) {
      showToast(message: "Password does not meet the requirements");
      return;
    } else if (!passwordEqual) {
      showToast(message: "Passwords do not match");
      return;
    } else if (_isOffline) {
      showToast(message: "No internet connection");
      return;
    }

    // Si todas las validaciones son correctas, continuar con el registro
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    // Obtener la ubicación actual
    LocationService locationService = LocationService();
    Position? posicion = await locationService.obtenerUbicacionActual();

    if (posicion != null) {
      double latitud = posicion.latitude;
      double longitud = posicion.longitude;

      // Llamar a la función de registro con la latitud y longitud reales
      User? user = await _auth.signUpWithEmailAndPassword(
          email, password, latitud, longitud, _usernameController.text);

      setState(() {
        isSigningUp = false;
      });

      setState(() {
        isSigningUp = false;
      });

      if (user != null) {
        showToast(message: "User is successfully created");
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, "/information");
      } else {
        showToast(message: "Some error happened");
        showToast(message: "Some error happened");
      }
    } else {
      showToast(message: "Unable to obtain location.");
    }
  }
}
