import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  final String id;

  const SettingsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo() async {
    final String newName = _nameController.text.trim();
    final String newEmail = _emailController.text.trim();
    final String newPassword = _passwordController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (newEmail.isNotEmpty) {
          await user.updateEmail(newEmail);
        }

        if (newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
        }
      }

      if (newName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .update({'name': newName});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User information updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user information')),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _isSaving ? null : _updateUserInfo,
              child: _isSaving
                  ? CircularProgressIndicator()
                  : Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}