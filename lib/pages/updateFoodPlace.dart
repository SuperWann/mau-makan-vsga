import 'package:flutter/material.dart';
import 'package:mau_makan/models/foodPlace.dart';
import 'package:mau_makan/services/userService.dart';
import 'package:mau_makan/widgets/button.dart';
import 'package:mau_makan/widgets/dialog.dart';
import 'package:mau_makan/widgets/inputForm.dart';

class UpdateFoodPlacePage extends StatefulWidget {
  static const String nameRoute = '/updateFoodPlacePage';
  const UpdateFoodPlacePage({super.key});

  @override
  State<UpdateFoodPlacePage> createState() => _UpdateFoodPlacePageState();
}

class _UpdateFoodPlacePageState extends State<UpdateFoodPlacePage> {
  final UserService _userService = UserService();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  bool _isDataChanged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final FoodPlaceModel foodPlace =
          ModalRoute.of(context)!.settings.arguments as FoodPlaceModel;
      _namaController.text = foodPlace.nama;
      _alamatController.text = foodPlace.alamat;
      _reviewController.text = foodPlace.review;
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _updateFoodPlace(FoodPlaceModel foodPlace) async {
    final foodPlaceUpdate = FoodPlaceModel(
      id: foodPlace.id,
      nama: _namaController.text.trim(),
      alamat: _alamatController.text.trim(),
      review: _reviewController.text.trim(),
    );
    final result = await _userService.updateFoodPlace(foodPlaceUpdate);
    if (result == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal update tempat makan!')),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tempat makan berhasil diupdate!')),
    );

    setState(() {
      _isDataChanged = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final FoodPlaceModel foodPlace =
        ModalRoute.of(context)!.settings.arguments as FoodPlaceModel;

    void checkDataChange() {
      setState(() {
        _isDataChanged =
            _namaController.text != foodPlace.nama ||
            _alamatController.text != foodPlace.alamat ||
            _reviewController.text != foodPlace.review;
      });
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Data\nTempat Makananmu.",
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
                          onchange: (value) => checkDataChange(),
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
                        onchange: (value) => checkDataChange(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Review",
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
                          text: '',
                          controller: _reviewController,
                          onchange: (value) => checkDataChange(),
                        ),
                      ],
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
                        text: "Update",
                        color: _isDataChanged ? "#2D4F2B" : "#C4C4C4",
                        colorText: "FFFFFF",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => YesNoDialog(
                                  title: "Perbarui Data?",
                                  content: "Yakin ingin perbarui data?",
                                  onYes: () => _updateFoodPlace(foodPlace),
                                  onNo: () => Navigator.pop(context),
                                ),
                          );
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
