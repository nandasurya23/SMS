// locations.dart

class Location {
  final String image;
  final String name;
  final String address;

  Location({required this.image, required this.name, required this.address});
}

final List<Location> locations = [
  Location(
    image: 'assets/location1.png',
    name: 'Daur Ulang A',
    address: 'Jl. Contoh No. 1, Kota A',
  ),
  Location(
    image: 'assets/location2.png',
    name: 'Daur Ulang B',
    address: 'Jl. Contoh No. 2, Kota B',
  ),
  Location(
    image: 'assets/location2.png',
    name: 'Daur Ulang C',
    address: 'Jl. Contoh No. 3, Kota C',
  ),
  Location(
    image: 'assets/location1.png',
    name: 'Daur Ulang D',
    address: 'Jl. Contoh No. 3, Kota D',
  ),
  Location(
    image: 'assets/location2.png',
    name: 'Daur Ulang E',
    address: 'Jl. Contoh No. 3, Kota E',
  ),
  // Tambahkan data lainnya sesuai kebutuhan
];
