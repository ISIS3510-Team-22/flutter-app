import 'package:flutter/material.dart';
import 'package:studyglide/services/connectivity_service.dart';
import 'package:studyglide/services/profile_service.dart';
import 'package:studyglide/views/edit_profile.dart';
import '../constants/constants.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final ProfileService _profileService = ProfileService();
  final ConnectivityService _connectivityService = ConnectivityService();
  Usuario? _usuarioActual;

  @override
  void initState() {
    super.initState();
    _sincronizarYcargarUsuario();
  }

  Future<void> _sincronizarYcargarUsuario() async {
    // Sincronizar actualizaciones offline antes de cargar el perfil
    await _profileService.syncOfflineProfileUpdates();
    await _cargarUsuario();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuario() async {
    // Obtener el usuario actual autenticado
    Usuario? usuario = _authService.obtenerUsuarioActual();
    if (usuario != null) {
      // Obtener los detalles del usuario desde Firestore
      Usuario? usuarioConDetalles = await _firestoreService.obtenerUsuarioPorId(usuario.id);
      if(mounted) {
        setState(() {
          _usuarioActual = usuarioConDetalles;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sincronizarYcargarUsuario();
  }

  // Navegación a la pantalla de edición de perfil
  void _navigateToEditProfile() async {
    if (_usuarioActual != null) {
      // Navegar a la pantalla de edición y esperar los cambios
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileView(usuario: _usuarioActual!),
        ),
      );

      // Actualizar la vista de perfil si hay cambios
      if (result == true) {
        _cargarUsuario(); // Vuelve a cargar el usuario para actualizar la vista
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlueColor,
          foregroundColor: Colors.white,
          title: const Text(
            'PROFILE',
            style: headerTextStyle,
          ),
        ),
        body: _usuarioActual == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: _usuarioActual!.profilePictureUrl != null
                            ? NetworkImage(_usuarioActual!.profilePictureUrl!)
                            : const AssetImage('assets/default_profile.png') as ImageProvider,
              ),
              const Padding(padding: EdgeInsets.only(top: 16),),
              ElevatedButton(
                onPressed: () {
                  _navigateToEditProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Color de fondo
                  foregroundColor: darkBlueColor, // Color del texto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: const Text(
                  'Edit profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 36),),
              Text(_usuarioActual!.name,
                  style: bodyTextStyle),
              const Padding(padding: EdgeInsets.only(top: 36),),
              Text(_usuarioActual!.longitud.toString(),
                  style: bodyTextStyle),
              const Padding(padding: EdgeInsets.only(top: 36),),
              Text(_usuarioActual!.latitud.toString(),
                  style: bodyTextStyle),
            ],
                    ),
          ),
        );
  }
}
