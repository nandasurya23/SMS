// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';

class LubangBiopori {
  final int nomor;
  DateTime waktuTanam;
  DateTime waktuPanen;

  LubangBiopori({
    required this.nomor,
    required this.waktuTanam,
  }) : waktuPanen = waktuTanam.add(const Duration(days: 60)); 

  void setWaktuPanen(DateTime waktuPanen) {
    this.waktuPanen = waktuPanen;
  }
}

class KelolaSampahOrganikPage extends StatefulWidget {
  const KelolaSampahOrganikPage({super.key});

  @override
  _KelolaSampahOrganikPageState createState() =>
      _KelolaSampahOrganikPageState();
}

class _KelolaSampahOrganikPageState extends State<KelolaSampahOrganikPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? _waktuTanam;
  final List<LubangBiopori> _selectedBioporis = [];
  // ignore: unused_field
  DateTime? _waktuPanenKompos;

void _selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: _waktuTanam ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (pickedDate != null) {
    setState(() {
      _waktuTanam = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        _waktuTanam?.hour ?? 0,
        _waktuTanam?.minute ?? 0,
      );
      _dateController.text = pickedDate.toString().substring(0, 10);
      _updatePanenKompos();
    });
  }
}

void _selectTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime != null) {
    setState(() {
      _waktuTanam = _waktuTanam?.add(Duration(
        hours: pickedTime.hour,
        minutes: pickedTime.minute,
      ));
      _timeController.text = pickedTime.format(context);
      _updatePanenKompos();
    });
  }
}


  void _updatePanenKompos() {
    if (_waktuTanam != null) {
      for (var biopori in _selectedBioporis) {
        biopori.setWaktuPanen(_calculatePanenKompos(_waktuTanam!));
      }
      setState(() {
        _waktuPanenKompos = _calculatePanenKompos(_waktuTanam!);
      });
    }
  }

  // Fungsi untuk menghitung waktu panen kompos (misalnya 3 bulan dari waktu tanam)
  DateTime _calculatePanenKompos(DateTime waktuTanam) {
    return waktuTanam.add(const Duration(
        days:
            60)); // Misalnya, panen kompos dihitung setelah 90 hari atau sekitar 3 bulan
  }

void _validateData() {
  if (_dateController.text.isNotEmpty &&
      _timeController.text.isNotEmpty &&
      _selectedBioporis.isNotEmpty) {
    // Show selected data
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data yang Dipilih'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _selectedBioporis
                .map((biopori) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lubang biopori ${biopori.nomor}:'),
                        Text('Waktu tanam: ${biopori.waktuTanam}'),
                        Text('Waktu panen: ${biopori.waktuPanen}'),
                        const SizedBox(height: 10),
                      ],
                    ))
                .toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Reset inputan tanggal dan waktu
                setState(() {
                  _dateController.clear();
                  _timeController.clear();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: const Text(
              'Data tidak lengkap! Mohon masukkan waktu tanam sampah organik dan pilih minimal satu lubang biopori.'),
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

// Fungsi untuk membuat objek LubangBiopori baru berdasarkan input pengguna
void _createNewBiopori() {
  final biopori = LubangBiopori(
    nomor: _selectedBioporis.length + 1,
    waktuTanam: _waktuTanam ?? DateTime.now(),
  );
  biopori.waktuPanen = _calculatePanenKompos(biopori.waktuTanam);
  setState(() {
    _selectedBioporis.add(biopori);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Sampah Organik'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Input Data Sampah Organik',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Tanggal Tanam Sampah Organik',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(
                  labelText: 'Waktu Tanam Sampah Organik',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Lubang Biopori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildBioporiOptions(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _validateData();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBioporiOptions() {
    return Wrap(
      children: List<Widget>.generate(
        10,
        (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilterChip(
              label: Text('Lubang Biopori ${index + 1}'),
              selected: _selectedBioporis
                  .map((biopori) => biopori.nomor)
                  .contains(index + 1),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedBioporis.add(LubangBiopori(
                      nomor: index + 1,
                      waktuTanam: _waktuTanam ?? DateTime.now(),
                    ));
                  } else {
                    _selectedBioporis
                        .removeWhere((biopori) => biopori.nomor == index + 1);
                  }
                  _updatePanenKompos();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
