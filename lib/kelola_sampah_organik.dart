// ignore_for_file: library_private_types_in_public_api, unused_field, no_leading_underscores_for_local_identifiers, unnecessary_this, unused_local_variable

import 'dart:io';
import 'package:flutter/cupertino.dart';
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
    final DateTime? pickedDate = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select Date'),
          actions: <Widget>[
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _waktuTanam ?? DateTime.now(),
                minimumYear: 2000,
                maximumYear: 2100,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    _waktuTanam = newDateTime;
                    _dateController.text = _formatDate(newDateTime);
                    _updatePanenKompos();
                  });
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select Time'),
          actions: <Widget>[
            SizedBox(
              height: 200,
              child: CupertinoTimerPicker(
                initialTimerDuration: Duration(
                  hours: _waktuTanam?.hour ?? 0,
                  minutes: _waktuTanam?.minute ?? 0,
                ),
                onTimerDurationChanged: (Duration newDuration) {
                  setState(() {
                    _waktuTanam = DateTime(
                      _waktuTanam?.year ?? DateTime.now().year,
                      _waktuTanam?.month ?? DateTime.now().month,
                      _waktuTanam?.day ?? DateTime.now().day,
                      newDuration.inHours,
                      newDuration.inMinutes % 60,
                    );
                    _timeController.text =
                        '${newDuration.inHours}:${newDuration.inMinutes % 60}';
                    _updatePanenKompos();
                  });
                },
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
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
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Tambah Biopori'),
          content: Column(
            children: [
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Nama Biopori',
                padding: const EdgeInsets.all(12.0),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CupertinoTextField(
                    controller: _dateController,
                    placeholder: 'Tanggal Tanam',
                    suffix: const Icon(CupertinoIcons.calendar, size: 20),
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: CupertinoTextField(
                    controller: _timeController,
                    placeholder: 'Jam Tanam',
                    suffix: const Icon(CupertinoIcons.time, size: 20),
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _selectedImage == null
                  ? CupertinoButton.filled(
                      onPressed: _selectImage,
                      child: const Text('Pilih Foto'),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _selectedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty &&
                    _selectedImage != null) {
                  Navigator.pop(context);
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
                } else {
                  // Show a Cupertino dialog or a message if fields are empty
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Error'),
                        content: const Text('Harap lengkapi semua field.'),
                        actions: [
                          CupertinoDialogAction(
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
              },
              child: const Text('Simpan'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
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

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Ubah Biopori'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Nama Biopori',
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  placeholder: 'Tanggal Tanam',
                  suffix: const Icon(CupertinoIcons.calendar),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  placeholder: 'Jam Tanam',
                  suffix: const Icon(CupertinoIcons.time),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
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
            CupertinoDialogAction(
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
      // Reset status biopori
      biopori.isPanen = false; // Set to false so buttons reappear
      biopori.isPenuh = false; // Set to false to re-enable "Penuh" button
      // Update waktuTanam and waktuPanen if needed
      if (_waktuTanam != null) {
        biopori.setWaktuTanam(_waktuTanam!);
      }
      _filterBioporis(); // Refresh the list
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
                                      onPressed: biopori.isPanen
                                          ? null
                                          : () => _editBiopori(biopori),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: biopori.isPanen
                                            ? Colors.grey
                                            : Colors.white,
                                        backgroundColor: biopori.isPanen
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
                                      onPressed: biopori.isPanen
                                          ? null
                                          : () => _markAsPenuh(biopori),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: biopori.isPanen
                                            ? Colors.grey
                                            : Colors.white,
                                        backgroundColor: biopori.isPanen
                                            ? Colors.grey[600]
                                            : const Color(0xFF2B9444),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Text('Penuh'),
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
