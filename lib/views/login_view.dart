import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/views/forgot_password_view.dart';
import 'package:studyglide/views/sign_up_view.dart';
import 'package:studyglide/widgets/form_container_widget.dart';
import '../../global/common/toast.dart';
import '../../firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  // ignore: unused_field
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isOffline = false;
  String _connectionMessage = "";
  Color _connectionColor = Colors.transparent;

  late StreamSubscription<List<ConnectivityResult>> subscription;


  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        _showConnectionStatus("Connection restored", Colors.green);
      } else {
        _showConnectionStatus("No internet connection", Colors.red);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    subscription.cancel();
    super.dispose();
  }

  void _showConnectionStatus(String message, Color color) {
    setState(() {
      _connectionMessage = message;
      _connectionColor = color;
      _isOffline = true;
    });

    // Ocultar el banner después de unos segundos si la conexión se restaura
    if (color == Colors.green) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isOffline = false;
        });
      });
    }
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    if (_isOffline) {
      showToast(message: "No internet connection");
      setState(() {
      _isSigning = false;
      });
      return null;
    }
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.pushNamed(context, "/information");
    } else {
      showToast(message: "Some error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/banner.svg", height: 140),
                  const SizedBox(height: 30),
                  FormContainerWidget(
                    controller: _emailController,
                    hintText: "Email",
                    isPasswordField: false,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  FormContainerWidget(
                    controller: _passwordController,
                    hintText: "Password",
                    isPasswordField: true,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _signIn,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: darkBlueBottonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isSigning
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Sign in", style: bodyTextStyle),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: const Text("Forgot your password?", style: subBodyTextStyle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: subBodyTextStyle),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                            (route) => false,
                          );
                        },
                        child: const Text("Sign Up", style: buttonTextStyle),
                      ),
                    ],
                  ),
                ],
              ),
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}