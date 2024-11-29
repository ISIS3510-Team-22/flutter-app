import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studyglide/services/profile_service.dart';
import '../constants/constants.dart';
import '../models/user_model.dart';

class EditProfileView extends StatefulWidget {
  final Usuario usuario;

  const EditProfileView({super.key, required this.usuario});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final ProfileService _profileService = ProfileService();
  File? _newProfileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializamos el TextField con el nombre actual del usuario
    _nameController.text = widget.usuario.name;
  }

  // Función para elegir una imagen de perfil
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          _newProfileImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    await _profileService.saveProfileUpdate(
      widget.usuario.id,
      name: _nameController.text,
      imageFile: _newProfileImage,
    );
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: headerTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen de perfil editable
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: _newProfileImage != null
                    ? FileImage(_newProfileImage!) as ImageProvider
                    : (widget.usuario.profilePictureUrl != null
                        ? NetworkImage(widget.usuario.profilePictureUrl!)
                        : const AssetImage('assets/default_profile.png')),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Campo de edición de nombre
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: bodyTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: bodyTextStyle,
            ),
          ],
        ),
      ),
      backgroundColor: darkBlueColor,
    );
  }
}
