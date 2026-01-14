import 'package:provider/provider.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart'; // Your AppState provider
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final bool isEditable;

  const Profile({super.key, required this.isEditable});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with data from provider
    final userData = context.read<AppState>().userData;

    nameController = TextEditingController(text: userData['Name'] ?? '');
    emailController = TextEditingController(text: userData['Email'] ?? '');
    passwordController = TextEditingController(text: userData['Password'] ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = widget.isEditable;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              enabled: isEditable,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: isEditable ? null : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextStyle(color: isEditable ? null : Colors.black87),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              enabled: isEditable,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: isEditable ? null : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextStyle(color: isEditable ? null : Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    enabled: isEditable,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: isEditable ? null : Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextStyle(color: isEditable ? null : Colors.black87),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isEditable)
              Center(
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('Save'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveData() {
    final updatedValues = {
      'Name': nameController.text,
      'Email': emailController.text,
      'Password': passwordController.text,
    };

    // Update provider's userData
    context.read<AppState>().updateUserData(updatedValues);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved')),
    );
  }
}