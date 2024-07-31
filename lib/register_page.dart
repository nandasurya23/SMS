// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Hash password using SHA-256
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    // Send registration request to the backend
    final response = await http.post(
      Uri.parse('http://192.168.101.53:3000/register'),
      body: {
        'username': username,
        'password': hashedPassword,
      },
    );

    // Handle registration response
    if (response.statusCode == 201) {
      // Registration successful
      Navigator.pushNamed(context, '/');
      // Show success alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text('You have successfully registered.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Registration failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
    }
  }
}
