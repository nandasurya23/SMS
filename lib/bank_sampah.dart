// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'locations.dart';
import 'bottom_navigation_bar.dart';

class BankSampahPage extends StatefulWidget {
  const BankSampahPage({super.key});

  @override
  _BankSampahPageState createState() => _BankSampahPageState();
}

class _BankSampahPageState extends State<BankSampahPage> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageFiles = [];
  final _formKey = GlobalKey<FormState>();
  String? _selectedWasteType;
  final List<String> _wasteTypes = ['Plastik', 'Kertas', 'Botol'];
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Jual Sampah'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon: Icon(Icons.home_outlined),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF40A858)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Berapa kg sampah',
                      prefixIcon: Icon(Icons.balance),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF40A858)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah sampah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedWasteType,
                    items: _wasteTypes
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWasteType = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Jenis Sampah',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF40A858)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Jenis sampah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _imageFiles.isEmpty
                      ? ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Unggah Gambar Sampah'),
                        )
                      : Column(
                          children: _imageFiles
                              .map((file) => Stack(
                                    children: [
                                      Image.file(
                                        file,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              _imageFiles.remove(file);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Redirect to WhatsApp
                        final String message =
                            'Alamat: ${_addressController.text}\n'
                            'Jumlah Sampah: ${_weightController.text} kg\n'
                            'Jenis Sampah: $_selectedWasteType';
                        const String phoneNumber =
                            '6281339684249'; // Ganti dengan nomor WA admin
                        final String url =
                            'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }

                        // Update total transaksi
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Jual'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (Route<dynamic> route) => false,
      );
    } else if (index == 1) {
      Navigator.pushNamed(context, '/kelola_sampah_organik');
    } else if (index == 2) {
      // Halaman ini (Bank Sampah) sudah terbuka
    } else if (index == 3) {
      Navigator.pushNamed(context, '/rumah_edukasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Sampah'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF40A858), Color(0xFF2B9444)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Transaksi: 0 kg',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return GestureDetector(
                    onTap: () => _showInputDialog(context),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5.0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              location.image,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  location.address,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => _onItemTapped(context, index),
        onItemTapped: (index) {},
      ),
    );
  }
}
