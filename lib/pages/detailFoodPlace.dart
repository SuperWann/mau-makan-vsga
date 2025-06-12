import 'package:flutter/material.dart';
import 'package:mau_makan/models/foodPlace.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mau_makan/services/userService.dart';
import 'package:mau_makan/widgets/button.dart';
import 'package:mau_makan/widgets/dialog.dart';

class DetailFoodPlacePage extends StatefulWidget {
  static const nameRoute = '/detailFoodPlacePage';
  const DetailFoodPlacePage({super.key});

  @override
  State<DetailFoodPlacePage> createState() => _DetailFoodPlacePageState();
}

class _DetailFoodPlacePageState extends State<DetailFoodPlacePage> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final FoodPlaceModel foodPlace =
        ModalRoute.of(context)!.settings.arguments as FoodPlaceModel;

    LatLng position = LatLng(
      double.parse(foodPlace.latitude!),
      double.parse(foodPlace.longitude!),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Detail",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(Icons.edit),
            color: Colors.black,
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  '/updateFoodPlacePage',
                  arguments: foodPlace,
                ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: position,
                    initialZoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: position,
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFFE55050),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodPlace.nama,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE55050),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          foodPlace.alamat,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.reviews_rounded,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          foodPlace.review,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                      text: "Hapus",
                      color: "#E55050",
                      colorText: "FFFFFF",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => YesNoDialog(
                                title: "Hapus Tempat Makananmu ?",
                                content:
                                    "Apakah kamu yakin ingin menghapus tempat makananmu ?",
                                onYes:
                                    () async => _userService
                                        .deleteFoodPlace(foodPlace.id!)
                                        .then(
                                          (value) =>
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/navbarPage',
                                              ),
                                        ),
                                onNo: () {
                                  Navigator.pop(context);
                                },
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
    );
  }
}
