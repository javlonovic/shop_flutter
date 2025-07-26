import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_card.dart';

class Category {
  final String name;
  final String imageUrl;
  final Color borderColor;
  final Color backgroundColor;

  Category({
    required this.name,
    required this.imageUrl,
    required this.borderColor,
    required this.backgroundColor,
  });
}

final List<Category> categories = [
  Category(
    name: 'Frash Fruits & Vegetable',
    imageUrl: 'https://img.icons8.com/color/96/fruit-basket.png',
    borderColor: Color(0xFF53B175),
    backgroundColor: Color(0xFFEFFAF3),
  ),
  Category(
    name: 'Cooking Oil & Ghee',
    imageUrl: 'https://img.icons8.com/color/96/oil-bottle.png',
    borderColor: Color(0xFFFFA725),
    backgroundColor: Color(0xFFFFF7ED),
  ),
  Category(
    name: 'Meat & Fish',
    imageUrl: 'https://img.icons8.com/color/96/steak.png',
    borderColor: Color(0xFFFF8181),
    backgroundColor: Color(0xFFFFF0F0),
  ),
  Category(
    name: 'Bakery & Snacks',
    imageUrl: 'https://img.icons8.com/color/96/bread.png',
    borderColor: Color(0xFFB07DFF),
    backgroundColor: Color(0xFFF7F0FF),
  ),
  Category(
    name: 'Dairy & Eggs',
    imageUrl: 'https://img.icons8.com/color/96/cheese.png',
    borderColor: Color(0xFFFFE14F),
    backgroundColor: Color(0xFFFFFBEF),
  ),
  Category(
    name: 'Beverages',
    imageUrl: 'https://img.icons8.com/color/96/soda-bottle.png',
    borderColor: Color(0xFF53B1FD),
    backgroundColor: Color(0xFFF0F8FF),
  ),
];

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Find Products',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF2F3F2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Store',
                    hintStyle: TextStyle(fontFamily: 'Gilroy', fontSize: 16),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.1,
                  children: categories
                      .map((cat) => CategoryTile(category: cat))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;
  const CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: category.backgroundColor,
          border: Border.all(color: category.borderColor, width: 2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              category.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryProductsPage extends StatelessWidget {
  final Category category;
  const CategoryProductsPage({Key? key, required this.category})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          category.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: Provider.of<ProductProvider>(
          context,
          listen: false,
        ).getProductsByCategory(category.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading products'));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No products found in this category',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 12.0,
              ),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 24.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, i) => ProductCard(product: products[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
