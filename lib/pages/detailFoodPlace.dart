import 'package:flutter/material.dart';
import 'package:mau_makan/models/foodPlace.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailFoodPlacePage extends StatefulWidget {
  static const nameRoute = '/detailFoodPlacePage';
  const DetailFoodPlacePage({super.key});

  @override
  State<DetailFoodPlacePage> createState() => _DetailFoodPlacePageState();
}

class _DetailFoodPlacePageState extends State<DetailFoodPlacePage> {
  @override
  Widget build(BuildContext context) {
    final FoodPlaceModel foodPlace =
        ModalRoute.of(context)!.settings.arguments as FoodPlaceModel;

    LatLng position = LatLng(
      double.parse(foodPlace.latitude),
      double.parse(foodPlace.longitude),
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: FlutterMap(
              options: MapOptions(initialCenter: position, initialZoom: 12.0),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: position,
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF1F3A93),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
