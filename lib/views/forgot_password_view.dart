import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/global/common/toast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSendingResetEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isSendingResetEmail = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      showToast(message: "Password reset email sent!");
    } catch (e) {
      showToast(message: "Error: ${e.toString()}");
    } finally {
      setState(() {
        _isSendingResetEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your email to receive a password reset link",
              textAlign: TextAlign.center,
              style: bodyTextStyle,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _emailController,
                style: bodyTextStyle,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: InputBorder.none,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                _sendPasswordResetEmail();
              },
              child: Container(
                 width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: darkBlueBottonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSendingResetEmail
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Send Reset Email",
                        style: bodyTextStyle,
                      ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
