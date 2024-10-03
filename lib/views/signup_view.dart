import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegistroView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();

  RegistroView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await authViewModel.registrarUsuarioConUbicacion(
                  _nameController.text, // El campo name es el email
                  _passwordController.text,
                );
                if (success) {
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al registrar")),
                  );
                }
              },
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
