import 'package:flutter/material.dart';
import 'package:studyglide/constants/constants.dart';
import 'package:studyglide/firebase_auth_services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleTextStyle,
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        iconSize: 40,
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                      context,
                      'LOG OUT',
                      () => _handleLogout(context),
                    ),
                    _buildMenuItem(context, 'OPTIONS', () {}),
                    _buildMenuItem(context, 'PROFILE', () {
                      Navigator.pushNamed(context, '/profile');
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      actions: actions,
      backgroundColor: darkBlueColor,
      centerTitle: true,
    );
  }

  // Función para manejar el logout
  void _handleLogout(BuildContext context) async {
    final authService = FirebaseAuthService();
    await authService.signOut(); // Cierra la sesión
    Navigator.of(context).pushReplacementNamed('/'); // Redirige a la pantalla de inicio de sesión
  }

  // Modificación del _buildMenuItem para aceptar una función al hacer clic
  Widget _buildMenuItem(BuildContext context, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Cierra el diálogo al hacer clic
        onTap(); // Llama a la función que se pasó al construir el item
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          text,
          style: optionsTextStyle,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
