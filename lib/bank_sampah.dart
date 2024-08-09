// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class BankSampahPage extends StatefulWidget {
  const BankSampahPage({super.key});

  @override
  _BankSampahPageState createState() => _BankSampahPageState();
}

class _BankSampahPageState extends State<BankSampahPage> {
  final TextEditingController _plastikController = TextEditingController();
  final TextEditingController _kertasController = TextEditingController();
  final TextEditingController _botolController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _dataValid = false;

  void _validateData() {
    if (_plastikController.text.isNotEmpty &&
        _kertasController.text.isNotEmpty &&
        _botolController.text.isNotEmpty &&
        _notesController.text.isNotEmpty) {
      _showConfirmationDialog();
    } else {
      setState(() {
        _dataValid = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Peringatan'),
            content: const Text('Mohon lengkapi semua informasi.'),
            actions: <Widget>[
              TextButton(
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

  int _updateTotalTransactions() {
    int plastik = int.tryParse(_plastikController.text) ?? 0;
    int kertas = int.tryParse(_kertasController.text) ?? 0;
    int botol = int.tryParse(_botolController.text) ?? 0;
    return plastik + kertas + botol;
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda ingin menyimpan data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                int totalTransactions = _updateTotalTransactions();
                Navigator.pop(context); // Tutup dialog konfirmasi
                Navigator.pushReplacementNamed(
                  context,
                  '/main',
                  arguments: {
                    'username': 'User123', // Ganti dengan username yang sesungguhnya
                    'totalTransactions': totalTransactions,
                  },
                );
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Sampah'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Jual Sampah',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _plastikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Sampah Plastik (kg)',
                  suffixIcon: Icon(Icons.balance),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kertasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Sampah Kertas (kg)',
                  suffixIcon: Icon(Icons.balance),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _botolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Sampah Botol (kg)',
                  suffixIcon: Icon(Icons.balance),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Masukan Note',
                  suffixIcon: Icon(Icons.assignment),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Simpan'),
              ),
              const SizedBox(height: 20),
              _dataValid
                  ? const Text(
                      'Data berhasil disimpan!',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    )
                  : Container(),
              const SizedBox(height: 20),
              Text(
                'Total Transaksi: ${_updateTotalTransactions()} kg',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/main');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/kelola_sampah_organik');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/rumah_edukasi');
          }
        },
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
