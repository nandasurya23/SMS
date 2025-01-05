// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-size background image
            Image.asset(
              'assets/background.jpeg',
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors
                  .black54, // Semi-transparent overlay for better readability
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png',
                      height: 100.0,
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color:
                                CupertinoColors.inactiveGray.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Please login to your account',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            CupertinoTextField(
                              controller: _phoneController,
                              placeholder: 'Phone Number',
                              prefix: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(CupertinoIcons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: CupertinoColors.inactiveGray,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            CupertinoTextField(
                              controller: _passwordController,
                              placeholder: 'Password',
                              obscureText: _obscureText,
                              prefix: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(CupertinoIcons.lock),
                              ),
                              suffix: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  _obscureText
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: CupertinoColors.inactiveGray,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.green), // Green text color
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/forgot-password');
                                },
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            CupertinoTheme(
                              data: const CupertinoThemeData(
                                primaryColor:
                                    Colors.green, // Set your custom color here
                              ),
                              child: CupertinoButton.filled(
                                onPressed: () {
                                  _login(context);
                                },
                                child: const Text('Login'),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Text(
                                'Don\'t have an account? Register here',
                                style: TextStyle(
                                    color: Colors.green), // Green text color
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Hash the password using SHA-256
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    // Send login request to the backend
    final response = await http.post(
      Uri.parse('http://192.168.101.100:3000/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone_number': phone,
        'password': hashedPassword,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final username =
          responseData['user']['username']; // Ambil username dari response

      // Navigate to main menu and pass username
      Navigator.pushReplacementNamed(
        context,
        '/main',
        arguments: username,
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Login failed'),
            content: Text('Error: ${response.body}'),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
