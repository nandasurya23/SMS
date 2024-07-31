// ignore_for_file: use_key_in_widget_constructors, unused_import, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'bank_sampah.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'kelola_sampah_organik.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => const MainMenu(username: ''),
        '/kelola_sampah_organik': (context) => const KelolaSampahOrganikPage(),
        '/bank_sampah': (context) => const BankSampahPage(),
      },
    );
  }
  
  KelolaSampahOrganik() {}
}



class MainMenu extends StatelessWidget {
  final String username;

  const MainMenu({Key? key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Tambahkan logika logout di sini, misalnya kembali ke halaman login
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              children: [
                _buildMenuItem(context, 'Kelola Sampah Organik', Icons.eco,
                    '/kelola_sampah_organik'),
                _buildMenuItem(context, 'Bank Sampah',
                    Icons.account_balance_wallet, '/bank_sampah'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData iconData, String route) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
