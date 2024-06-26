// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                _login(context);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Kirim permintaan login ke backend
    final response = await http.post(
      Uri.parse('http://192.168.101.53:3000/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Jika login berhasil, arahkan ke halaman lain (misalnya halaman utama aplikasi)
      Navigator.pushNamed(context, '/main');
      // Tampilkan alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('You have successfully logged in.'),
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
      // Jika login gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Login failed. Please check your username and password.'),
        ),
      );
    }
  }
}
