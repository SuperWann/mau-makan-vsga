import 'package:flutter/material.dart';
import 'package:mau_makan/helpers/dbHelper.dart';
import 'package:mau_makan/models/foodPlace.dart';
import 'package:mau_makan/services/userService.dart';

class ListFoodPage extends StatefulWidget {
  static const String nameRoute = '/listFoodPage';

  const ListFoodPage({super.key});

  @override
  State<ListFoodPage> createState() => _ListFoodPageState();
}

class _ListFoodPageState extends State<ListFoodPage> {
  final UserService _userService = UserService();
  final DbHelper _dbHelper = DbHelper();
  List<FoodPlaceModel> foodPlaces = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoodPlaces();
    _dbHelper.checkTables();
  }

  Future<void> _loadFoodPlaces() async {
    try {
      setState(() {
        isLoading = true;
      });

      final places = await _userService.getAllFoodPlaces();

      setState(() {
        foodPlaces = places;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  Future<void> _refreshData() async {
    await _loadFoodPlaces();
  }

  Widget _buildImageWidget(String? imagePath) {
    // Selalu gunakan placeholder untuk sementara
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Center(
        child: Icon(Icons.restaurant, size: 50, color: Colors.white),
      ),
    );
  }

  Widget _buildFoodPlaceCard(FoodPlaceModel foodPlace) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: GestureDetector(
        onTap:
            () => Navigator.pushNamed(
              context,
              '/detailFoodPlacePage',
              arguments: foodPlace,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: _buildImageWidget(foodPlace.image),
            ),
            // Konten
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Tempat
                  Text(
                    foodPlace.nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Alamat
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          foodPlace.alamat,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.rate_review,
                              size: 16,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Review:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          foodPlace.review,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'Montserrat',
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada tempat makan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan tempat makan pertama Anda!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'List Food Places',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D4F2B)),
                ),
              )
              : foodPlaces.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: _refreshData,
                color: const Color(0xFF2D4F2B),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: foodPlaces.length,
                  itemBuilder: (context, index) {
                    return _buildFoodPlaceCard(foodPlaces[index]);
                  },
                ),
              ),
    );
  }
}
