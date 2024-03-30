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
  final TextEditingController _dateController = TextEditingController();
  bool _dataValid = false;
  DateTime? _selectedDate;

  void _validateData() {
    if (_plastikController.text.isNotEmpty &&
        _kertasController.text.isNotEmpty &&
        _botolController.text.isNotEmpty &&
        _notesController.text.isNotEmpty &&
        _selectedDate != null) {
      setState(() {
        _dataValid = true;
      });
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = pickedDate.toString().substring(0, 10);
      });
    }
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
                    suffixIcon: Icon(Icons.balance)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kertasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Jumlah Sampah Kertas (kg)',
                    suffixIcon: Icon(Icons.balance)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _botolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Jumlah Sampah Botol (kg)',
                    suffixIcon: Icon(Icons.balance)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _notesController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Masukan Note',
                    suffixIcon: Icon(Icons.assignment)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pengambilan Sampah',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _validateData();
                },
                child: const Text('Simpan'),
              ),
              const SizedBox(height: 20),
              _dataValid
                  ? Text(
                      'Jadwal Pengambilan Sampah: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(fontSize: 16),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
