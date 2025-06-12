import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mau_makan/models/foodPlace.dart';
import 'package:mau_makan/services/userService.dart';
import 'package:mau_makan/widgets/button.dart';
import 'package:mau_makan/widgets/inputForm.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AddListFoodPage extends StatefulWidget {
  static const String nameRoute = '/addListFoodPage';

  const AddListFoodPage({super.key});

  @override
  State<AddListFoodPage> createState() => _AddListFoodPageState();
}

class _AddListFoodPageState extends State<AddListFoodPage> {
  final userService = UserService();

  String? label;
  bool isLoadingLocation = false;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  Position? currPosition;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _bacaLokasi();
  }

  _bacaLokasi() async {
    setState(() {
      isLoadingLocation = true;
      label = "Mendapatkan lokasi...";
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          label = "Layanan lokasi tidak aktif. Mohon aktifkan GPS.";
          isLoadingLocation = false;
        });
        _showLocationDialog(
          "Layanan lokasi tidak aktif",
          "Mohon aktifkan GPS di pengaturan perangkat Anda.",
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            label = "Izin lokasi ditolak";
            isLoadingLocation = false;
          });
          _showLocationDialog(
            "Izin Ditolak",
            "Aplikasi memerlukan izin lokasi untuk mendapatkan koordinat tempat.",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          label = "Izin lokasi ditolak permanen";
          isLoadingLocation = false;
        });
        _showLocationDialog(
          "Izin Ditolak Permanen",
          "Mohon aktifkan izin lokasi melalui pengaturan aplikasi.",
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      setState(() {
        currPosition = position;
        label =
            "Koordinat: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
        isLoadingLocation = false;
      });

      print(
        "Lokasi berhasil didapat: ${position.latitude}, ${position.longitude}",
      );
    } catch (e) {
      setState(() {
        label = "Gagal mendapatkan lokasi: $e";
        isLoadingLocation = false;
      });
      print("Error getting location: $e");
      _showLocationDialog("Error", "Gagal mendapatkan lokasi: ${e.toString()}");
    }
  }

  void _showLocationDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
            if (title.contains("Ditolak Permanen"))
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openAppSettings();
                },
                child: Text("Pengaturan"),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _saveFoodPlace(BuildContext context) async {
    if (currPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi belum tersedia. Mohon tunggu atau coba lagi.'),
        ),
      );
      return;
    }

    try {
      final foodPlace = FoodPlaceModel(
        nama: _namaController.text.trim(),
        alamat: _alamatController.text.trim(),
        latitude: currPosition!.latitude.toString(),
        longitude: currPosition!.longitude.toString(),
        image: selectedImage!.path,
        review: _reviewController.text.trim(),
      );

      final result = await userService.insertFoodPlace(foodPlace);

      if (result == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan tempat makan!')),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tempat makan berhasil disimpan!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        bottom: 100, // Space for button
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tambah List\nTempat Makananmu.",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Masukkan Nama Tempat",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                InputFormWithHintText(
                                  type: TextInputType.text,
                                  text: 'Tempat Makan',
                                  controller: _namaController,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Masukkan Alamat Tempat",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              InputFormWithHintText(
                                type: TextInputType.text,
                                text: 'Alamat',
                                controller: _alamatController,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Masukkan Foto Tempat",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black45),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.35,
                                    child:
                                        selectedImage != null
                                            ? Center(
                                              child: Text(selectedImage!.path),
                                            )
                                            : Center(
                                              child: Icon(
                                                Icons
                                                    .add_photo_alternate_rounded,
                                                size: 50,
                                                color: Colors.black45,
                                              ),
                                            ),
                                  ),
                                  onTap: () {
                                    _pickImage();
                                  },
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Masukkan Review Tempat",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InputFormWithHintText(
                                      type: TextInputType.text,
                                      text: 'Review',
                                      controller: _reviewController,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: LongButton(
                        text: "Masuk",
                        color: "#2D4F2B",
                        colorText: "FFFFFF",
                        onPressed: () {
                          if (_namaController.text.isNotEmpty &&
                              _alamatController.text.isNotEmpty &&
                              _reviewController.text.isNotEmpty &&
                              selectedImage != null) {
                            _saveFoodPlace(context);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Semua field harus diisi!'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
