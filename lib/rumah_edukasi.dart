// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

class RumahEdukasiPage extends StatelessWidget {
  const RumahEdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah Edukasi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: <Widget>[
                    _buildEducationCard(context, 'Pembuatan Lubang Biopori'),
                    _buildEducationCard(context, 'Pemilahan Sampah'),
                    _buildEducationCard(context, 'Pengelolaan Kelompok'),
                    _buildEducationCard(context, 'Prinsip Daur Ulang'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _navigateToEducationOption(context, 'Artikel');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Artikel',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard(BuildContext context, String option) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          _navigateToEducationOption(context, option);
        },
        child: Center(
          child: Text(
            option,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _navigateToEducationOption(BuildContext context, String option) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EducationOptionPage(option: option)),
    );

    if (result != null && result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data edukasi telah terkumpul. Terima kasih!'),
        ),
      );
    }
  }
}

class EducationOptionPage extends StatefulWidget {
  final String option;

  const EducationOptionPage({super.key, required this.option});

  @override
  _EducationOptionPageState createState() => _EducationOptionPageState();
}

class _EducationOptionPageState extends State<EducationOptionPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.option),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Data edukasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _validateAndNavigateBack(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndNavigateBack(BuildContext context) {
    final String data = _controller.text.trim();

    if (data.isNotEmpty) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi data edukasi terlebih dahulu.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
