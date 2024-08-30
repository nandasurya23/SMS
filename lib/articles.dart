 // ignore_for_file: unused_import

 import 'package:flutter/material.dart';

class Article {
  final String title;
  final String detail;
  final String imageUrl;

  Article({
    required this.title,
    required this.detail,
    required this.imageUrl,
  });
}

final List<Article> articles = [
  Article(
    title: 'Pembuatan Lubang Biopori',
    detail:
        'Lubang Biopori adalah teknik konservasi tanah untuk meningkatkan daya resap air dan mengolah sampah organik menjadi kompos.',
    imageUrl: 'assets/ar1.jpeg', // Replace with actual image asset
  ),
  Article(
    title: 'Pemilahan Sampah',
    detail:
        'Pemilahan sampah adalah proses memisahkan jenis sampah berdasarkan karakteristiknya untuk memudahkan pengolahan lebih lanjut.',
    imageUrl: 'assets/ar1.jpeg' // Replace with actual image asset
  ),
  Article(
    title: 'Pengelolaan Kelompok',
    detail:
        'Pengelolaan kelompok penting dalam memobilisasi komunitas untuk kegiatan daur ulang dan pengelolaan sampah yang lebih baik.',
    imageUrl: 'assets/ar1.jpeg', // Replace with actual image asset
  ),
  Article(
    title: 'Prinsip Daur Ulang',
    detail:
        'Prinsip daur ulang adalah pendekatan ramah lingkungan untuk mengurangi sampah dengan mengolahnya menjadi produk baru.',
    imageUrl: 'assets/ar1.jpeg', // Replace with actual image asset
  ),
];
