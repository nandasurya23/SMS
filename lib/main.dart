// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'bank_sampah.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'kelola_sampah_organik.dart';
import 'rumah_edukasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS',
      theme: ThemeData(
        primarySwatch: Colors.green,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        scaffoldBackgroundColor: Colors.grey[200], // Background color of the Scaffold
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => const MainMenu(),
        '/kelola_sampah_organik': (context) => const KelolaSampahOrganikPage(),
        '/bank_sampah': (context) => const BankSampahPage(),
        '/rumah_edukasi': (context) => const RumahEdukasiPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/main') {
          final username = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => MainMenu(username: username),
          );
        }
        return null;
      },
    );
  }
}

class MainMenu extends StatefulWidget {
  final String? username;

  const MainMenu({super.key, this.username});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;
  int totalTransactions = 0; // Placeholder for total transactions

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTotalTransactions();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: widget.username,
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/kelola_sampah_organik');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/bank_sampah');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/rumah_edukasi');
        break;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Pagi ${widget.username ?? ''}';
    } else if (hour < 17) {
      return 'Siang ${widget.username ?? ''}';
    } else {
      return 'Malam ${widget.username ?? ''}';
    }
  }

  Future<void> _fetchTotalTransactions() async {
    // Simulate a network call to fetch total transactions
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        totalTransactions = 123; // Replace with real data from backend
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Background color of the AppBar
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(_getGreeting(), style: const TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
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
            const SizedBox(height: 20),
            Container(
              width: double.infinity, // Full width
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.lightGreen, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Transaksi: $totalTransactions kg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'Kelola Sampah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Bank Sampah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Rumah Edukasi',
          ),
        ],
      ),
    );
  }
}
