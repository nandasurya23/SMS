// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

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
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _rePasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Re-Enter Password'),
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
    final email = _emailController.text;
    final password = _passwordController.text;
    final rePassword = _rePasswordController.text;

    // Validasi email tidak boleh kosong
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email cannot be empty.'),
        ),
      );
      return;
    }

    // Validasi password dan re-password
    if (password != rePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    // Hashing password menggunakan algoritma SHA-256
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    // Kirim permintaan registrasi ke backend
    final response = await http.post(
      Uri.parse('http://192.168.101.7:3000/register'),
      body: {
        'username': username,
        'email': email,
        'password': hashedPassword,
      },
    );

    if (response.statusCode == 201) {
      // Jika registrasi berhasil, arahkan ke halaman login
      Navigator.pushNamed(context, '/');
      // Tampilkan alert ketika registrasi berhasil
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
      // Jika registrasi gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
    }
  }
}
