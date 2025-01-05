// ignore_for_file: unnecessary_import, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Create an Account'),
      ),
      child: SafeArea(
        child: CupertinoScrollbar(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 100.0,
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: CupertinoColors.inactiveGray,
                      offset: Offset(0, 1),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Fill in the details below to register',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    CupertinoTextField(
                      controller: _usernameController,
                      placeholder: 'Username',
                      prefix: const Icon(CupertinoIcons.person),
                    ),
                    const SizedBox(height: 16.0),
                    CupertinoTextField(
                      controller: _phoneController,
                      placeholder: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      prefix: const Icon(CupertinoIcons.phone),
                    ),
                    const SizedBox(height: 16.0),
                    CupertinoTextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      placeholder: 'Password',
                      prefix: const Icon(CupertinoIcons.lock),
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
                    ),
                    const SizedBox(height: 32.0),
                    CupertinoButton(
                      color: CupertinoColors.activeGreen,
                      onPressed: () {
                        _register(context);
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    final username = _usernameController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Hash the password using SHA-256
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    try {
      // Send registration request to the backend
      final response = await http.post(
        Uri.parse('http://192.168.101.100:3000/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'phone_number': phone, // No need to parse as int
          'password': hashedPassword,
        }),
      );

      // Handle registration response
      if (response.statusCode == 201) {
        // Registration successful
        Navigator.pushNamed(context, '/');
        // Show success alert
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Registration Successful'),
              content: const Text('You have successfully registered.'),
              actions: <Widget>[
                CupertinoDialogAction(
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
        throw Exception('Failed to register user');
      }
    } catch (e) {
      // Show error using CupertinoAlertDialog instead of SnackBar
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Registration Failed'),
            content: Text('Error: $e'),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
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
