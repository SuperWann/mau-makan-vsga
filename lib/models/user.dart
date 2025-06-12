class UserModel {
  final int? id; // ID bisa null jika baru dibuat
  final String username;
  final String password; // Dalam aplikasi nyata, simpan hash password!

  UserModel({this.id, required this.username, required this.password});

  // Konversi Map ke objek User
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  // Konversi objek User ke Map (untuk disimpan ke database)
  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'password': password};
  }
}
