// ignore_for_file: library_private_types_in_public_api, unused_field, no_leading_underscores_for_local_identifiers, unnecessary_this

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
  bool isPenuh;
  bool isPanen;

  LubangBiopori({
    required this.nomor,
    required this.nama,
    required this.waktuTanam,
    required this.waktuPanen,
    required this.foto,
    this.isPenuh = false,
    this.isPanen = false,
  });

  void setWaktuPanen(DateTime waktuPanen) {
    this.waktuPanen = waktuPanen;
  }

  void setWaktuTanam(DateTime dateTime) {
    this.waktuTanam = dateTime;
    this.waktuPanen = dateTime.add(const Duration(days: 60));
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
  final TextEditingController _searchController = TextEditingController();
  final List<LubangBiopori> _allBioporis =
      []; // Store all bioporis for searching
  List<LubangBiopori> _filteredBioporis = [];
  DateTime? _waktuTanam;
  DateTime? _waktuPanenKompos;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _filteredBioporis = _allBioporis;
    _searchController.addListener(_filterBioporis);
  }

  void _filterBioporis() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBioporis = _allBioporis.where((biopori) {
        final nameMatch = biopori.nama.toLowerCase().contains(query);
        final numberMatch = biopori.nomor.toString().contains(query);
        return nameMatch || numberMatch;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    return waktuTanam.add(const Duration(days: 21));
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
                    final newBiopori = LubangBiopori(
                      nomor: _allBioporis.length + 1,
                      nama: _nameController.text,
                      waktuTanam: _waktuTanam ?? DateTime.now(),
                      waktuPanen: _waktuPanenKompos ??
                          DateTime.now().add(const Duration(days: 60)),
                      foto: _selectedImage,
                    );
                    _allBioporis.add(newBiopori);
                    _filterBioporis(); // Update filtered list
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

  void _editBiopori(LubangBiopori biopori) {
    _nameController.text = biopori.nama;
    _dateController.text = _formatDate(biopori.waktuTanam);
    _timeController.text =
        biopori.waktuTanam.toLocal().toString().substring(11, 16);
    _waktuTanam = biopori.waktuTanam;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Biopori'),
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  // Update biopori with new user inputs
                  biopori.nama = _nameController.text;
                  biopori.setWaktuTanam(_waktuTanam ?? biopori.waktuTanam);
                  _filterBioporis(); // Update filtered list
                });
                Navigator.pop(context);
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

  void _markAsPenuh(LubangBiopori biopori) {
    setState(() {
      biopori.isPenuh = true;
      _filterBioporis(); // Update filtered list
    });
  }

  void _markAsPanen(LubangBiopori biopori) {
    setState(() {
      // Set waktuTanam and waktuPanen based on user input or the current state
      if (_waktuTanam != null) {
        biopori.setWaktuTanam(_waktuTanam!);
      }

      // Update state
      biopori.isPanen = true;
      biopori.isPenuh =
          false; // Reset isPenuh to allow "Penuh" button to be visible again

      _filterBioporis(); // Update filtered list
    });
  }

  void _deleteBiopori(LubangBiopori biopori) {
    setState(() {
      _allBioporis.remove(biopori);
      _filteredBioporis.remove(biopori);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Sampah Organik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Biopori...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _showAddBioporiForm,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredBioporis.length,
                itemBuilder: (context, index) {
                  final biopori = _filteredBioporis[index];
                  return Stack(
                    children: [
                      Card(
                        color: biopori.isPenuh ? Colors.grey : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              biopori.foto != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.file(
                                        biopori.foto!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: 150,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 80),
                                    ),
                              const SizedBox(height: 8),
                              Text(
                                'Nama: ${biopori.nama}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Tanggal ${_formatDate(biopori.waktuTanam)}'),
                                  Text(
                                      'Tanggal ${_formatDate(biopori.waktuPanen)}'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Jam Tanam: ${biopori.waktuTanam.toLocal().toString().substring(11, 16)}',
                                  ),
                                  Text(
                                    'Jam Panen: ${biopori.waktuPanen.toLocal().toString().substring(11, 16)}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: ElevatedButton(
                                      onPressed:
                                          biopori.isPenuh || biopori.isPanen
                                              ? null
                                              : () => _editBiopori(biopori),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            biopori.isPenuh || biopori.isPanen
                                                ? Colors.grey
                                                : Colors.white,
                                        backgroundColor:
                                            biopori.isPenuh || biopori.isPanen
                                                ? Colors.grey[600]
                                                : const Color(0xFF85D545),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Text('Ubah'),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: ElevatedButton(
                                      onPressed:
                                          biopori.isPenuh || biopori.isPanen
                                              ? null
                                              : () => _markAsPenuh(biopori),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            biopori.isPenuh || biopori.isPanen
                                                ? Colors.grey
                                                : Colors.white,
                                        backgroundColor:
                                            biopori.isPenuh || biopori.isPanen
                                                ? Colors.grey[600]
                                                : const Color(0xFF2B9444),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: biopori.isPanen
                                          ? const Text(
                                              'Kosong',
                                            )
                                          : const Text('Penuh'),
                                    ),
                                  ),
                                  if (biopori.isPenuh && !biopori.isPanen)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () => _markAsPanen(biopori),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF2B9444),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: const Text('Panen'),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBiopori(biopori),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _onItemTapped(context, index),
        onItemTapped: (index) {},
      ),
    );
  }
}
