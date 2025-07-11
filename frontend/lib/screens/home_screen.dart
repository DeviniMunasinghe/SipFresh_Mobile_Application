import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'order_details_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'category.dart';
import '../widgets/juice_card.dart';
import '../widgets/category_card.dart';

// cateogory list
final List<Map<String, dynamic>> categories = [
  {
    'title': 'Fresh Juices',
    'imagePath': 'assets/images/juice2.png',
    'screen': const JuiceCategoryPage(),
  },
  {
    'title': 'Salads',
    'imagePath': 'assets/images/juice2.png',
    'screen': const JuiceCategoryPage(),
  },
  {
    'title': 'Others',
    'imagePath': 'assets/images/juice2.png',
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
                            // ignore: deprecated_member_use
                            Colors.black.withOpacity(0.3),
                            // ignore: deprecated_member_use
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
            sectionHeader("Available Today"),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (_, index) => JuiceCardWidget(
                  imagePath: "assets/images/juice1.png",
                  // 'assets/images/juice1.png${index + 1}.png', // or static image
                  title: 'Mix Fruit Juice',
                  price: 170.00,
                  onTap: () {
                    // Optional: handle click
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            sectionHeader("Categories"),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    title: category['title'],
                    imagePath: category['imagePath'],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => category['screen']),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 16),

            // Go to Order Details Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderDetailsScreen()),
                  );
                },
                child: const Text("Go to Order Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Text("See all", style: TextStyle(color: Colors.green)),
      ],
    );
  }
}

class SliderImage extends StatelessWidget {
  final String imagePath;

  const SliderImage({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
