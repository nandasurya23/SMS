// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String username;
  final String greeting; // Tambahkan parameter greeting

  const Sidebar({Key? key, required this.username, required this.greeting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(
              children: [
                Text(username),
                const SizedBox(width: 8),
                Text(
                  greeting, // Menampilkan greeting
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            accountEmail: const Text("example@email.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green),
            ),
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/main');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Pengaturan Profil'),
            onTap: () {
              Navigator.pushNamed(context, '/profile_settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
