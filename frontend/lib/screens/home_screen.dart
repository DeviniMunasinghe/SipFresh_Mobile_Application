import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'category.dart';
import '../widgets/juice_card.dart';
import '../widgets/category_card.dart';
import '../services/api_service.dart';
import '../screens/see_all_items_screen.dart';

// cateogory list
final List<Map<String, dynamic>> categories = [
  {
    'title': 'Fruit Juice',
    'imagePath': 'assets/images/categoryImg/Fruit Juice.jpg',
    'screen': const JuiceCategoryPage(),
  },
  {
    'title': 'Smoothies',
    'imagePath': 'assets/images/categoryImg/Smoothies.jpg',
    'screen': const JuiceCategoryPage(),
  },
  {
    'title': 'Wellness Drinks',
    'imagePath': 'assets/images/categoryImg/Wellness Drinks.jpg',
    'screen': const JuiceCategoryPage(),
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> availableItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailable();
  }

  Future<void> fetchAvailable() async {
    try {
      final allItems = await ApiService.fetchAllItems();
      setState(() {
        availableItems = allItems.take(5).toList(); // Get only first 5 items
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF82BA53),
        title: const Text(
          "Sip Fresh",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'What do you want to drink?',
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Offer Banner with Carousel Background
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  CarouselSlider(
                    items: [
                      'assets/images/homeImg/SliderImage1.jpg',
                      'assets/images/homeImg/SliderImage2.jpg',
                      'assets/images/homeImg/SliderImage3.jpg',
                    ].map((imagePath) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 180,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      enlargeCenterPage: false,
                    ),
                  ),

                  // Overlayed Hello Text and Button
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.1),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 16,
                    top: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hello!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Grab Your Healthy Juice",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                          ),
                          child: const Text("Buy Now"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Available Today
            sectionHeader("Available Today", onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SeeAllItemsScreen()),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableItems.length,
                      itemBuilder: (_, index) {
                        final item = availableItems[index];
                        return JuiceCardWidget(
                          imagePath: item['item_image'] ??
                              '', // fallback to empty string if null
                          title: item['item_name'] ?? '',
                          price: double.tryParse(
                                  item['item_price']?.toString() ?? '0.0') ??
                              0.0,
                          itemId: item['item_id'],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 24),

            // Categories
            const Text(
              "Categories",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((category) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CategoryCard(
                      title: category['title'],
                      imagePath: category['imagePath'],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => category['screen'] as Widget,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text("See all", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
