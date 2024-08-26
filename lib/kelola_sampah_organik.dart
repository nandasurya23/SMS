// ignore_for_file: library_private_types_in_public_api, unused_field, no_leading_underscores_for_local_identifiers, unnecessary_to_list_in_spreads

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'bottom_navigation_bar.dart';

class LubangBiopori {
  final int nomor;
  String nama;
  DateTime waktuTanam;
  DateTime waktuPanen;
  File? foto;

  LubangBiopori({
    required this.nomor,
    required this.nama,
    required this.waktuTanam,
    required this.foto,
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
  final TextEditingController _nameController = TextEditingController();
  final List<LubangBiopori> _selectedBioporis = [];
  DateTime? _waktuTanam;
  DateTime? _waktuPanenKompos;
  File? _selectedImage;

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
        _dateController.text = _formatDate(pickedDate);
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
        _waktuTanam = DateTime(
          _waktuTanam?.year ?? DateTime.now().year,
          _waktuTanam?.month ?? DateTime.now().month,
          _waktuTanam?.day ?? DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _timeController.text = pickedTime.format(context);
        _updatePanenKompos();
      });
    }
  }

  void _updatePanenKompos() {
    if (_waktuTanam != null) {
      _waktuPanenKompos = _calculatePanenKompos(_waktuTanam!);
    }
  }

  DateTime _calculatePanenKompos(DateTime waktuTanam) {
    return waktuTanam.add(const Duration(days: 60));
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (Route<dynamic> route) => false,
      );
    } else if (index == 1) {
    } else if (index == 2) {
      Navigator.pushNamed(context, '/bank_sampah');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/rumah_edukasi');
    }
  }

  void _showAddBioporiForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Biopori'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Biopori',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Tanam',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: const InputDecoration(
                    labelText: 'Jam Tanam',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 10),
                _selectedImage == null
                    ? ElevatedButton(
                        onPressed: _selectImage,
                        child: const Text('Pilih Foto'),
                      )
                    : Image.file(
                        _selectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (_nameController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty) {
                  setState(() {
                    _selectedBioporis.add(LubangBiopori(
                      nomor: _selectedBioporis.length + 1,
                      nama: _nameController.text,
                      waktuTanam: _waktuTanam ?? DateTime.now(),
                      foto: _selectedImage,
                    ));
                    _nameController.clear();
                    _dateController.clear();
                    _timeController.clear();
                    _selectedImage = null;
                  });
                }
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.year}";
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return monthNames[month - 1];
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Cari Lubang Biopori',
                          hintText: 'Masukkan nama biopori...',
                          suffixIcon: const Icon(Icons.search),
                          // Menambahkan padding internal pada label dan hint
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _showAddBioporiForm,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._selectedBioporis
                  .map((biopori) => _buildBioporiContainer(biopori))
                  .toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _onItemTapped(context, index),
        onItemTapped: (index) {},
      ), // Custom menu di bagian bawah
    );
  }

  Widget _buildBioporiContainer(LubangBiopori biopori) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: biopori.foto == null
                ? Image.asset(
                    'assets/images/placeholder.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    biopori.foto!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            biopori.nama,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tgl ${_formatDate(biopori.waktuTanam)}',
              ),
              Text(
                'Tgl ${_formatDate(biopori.waktuPanen)}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jam Tanam: ${biopori.waktuTanam.toLocal().toString().substring(11, 16)}',
              ),
              Text(
                'Jam Panen: ${biopori.waktuTanam.toLocal().toString().substring(11, 16)}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Menempatkan tombol di tengah
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10), // Jarak antara tombol
                child: ElevatedButton(
                  onPressed: () {
                    // Implementasi fungsi 'Ubah'
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ).copyWith(
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA2D54E), Color(0xFF85D545)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 150, maxHeight: 50),
                      alignment: Alignment.center,
                      child: const Text(
                        'Ubah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10), // Jarak antara tombol
                child: ElevatedButton(
                  onPressed: () {
                    // Implementasi fungsi 'Penuh'
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ).copyWith(
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF40A858), Color(0xFF2B9444)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 150, maxHeight: 50),
                      alignment: Alignment.center,
                      child: const Text(
                        'Penuh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
