class FoodPlaceModel {
  final int? id;
  final String nama;
  final String alamat;
  final String? latitude;
  final String? longitude;
  final String? image;
  final String review;
  final DateTime? createdAt;

  FoodPlaceModel({
    this.id,
    required this.nama,
    required this.alamat,
    this.latitude,
    this.longitude,
    this.image,
    required this.review,
    this.createdAt,
  });

  factory FoodPlaceModel.fromMap(Map<String, dynamic> json) {
    return FoodPlaceModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: json['image'],
      review: json['review'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'review': review,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {'nama': nama, 'alamat': alamat, 'review': review};
  }
}
