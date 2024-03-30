import 'package:flutter/material.dart';
import 'kelola_sampah_organik.dart';
import 'bank_sampah.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'rumah_edukasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sustainable Mobile System',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => const MainMenu(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

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
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: <Widget>[
            _buildMenuItem(
              context,
              'Kelola Sampah Organik',
              Icons.eco,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const KelolaSampahOrganikPage()),
              ),
            ),
            _buildMenuItem(
              context,
              'Bank Sampah',
              Icons.account_balance_wallet,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BankSampahPage()),
              ),
            ),
            _buildMenuItem(
              context,
              'Rumah Edukasi',
              Icons.home,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RumahEdukasiPage()),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData iconData, Function() onTap) {
    return InkWell(
      onTap: onTap,
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
