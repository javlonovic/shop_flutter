import 'package:flutter/material.dart';

class ProductInfo {
  final String title;
  final String description;
  const ProductInfo({required this.title, required this.description});
}

final List<ProductInfo> sampleProducts = [
  ProductInfo(
    title: 'Fresh Apple',
    description: 'Crisp and sweet organic apples.',
  ),
  ProductInfo(title: 'Olive Oil', description: 'Pure extra virgin olive oil.'),
  ProductInfo(
    title: 'Salmon Fillet',
    description: 'Fresh Atlantic salmon, boneless.',
  ),
  ProductInfo(
    title: 'Whole Wheat Bread',
    description: 'Soft, healthy, and freshly baked.',
  ),
  ProductInfo(
    title: 'Cheddar Cheese',
    description: 'Aged cheddar, rich and creamy.',
  ),
  ProductInfo(
    title: 'Orange Juice',
    description: '100% pure squeezed orange juice.',
  ),
  ProductInfo(
    title: 'Greek Yogurt',
    description: 'Thick, creamy, and high in protein.',
  ),
  ProductInfo(
    title: 'Almond Milk',
    description: 'Dairy-free, plant-based milk alternative.',
  ),
  ProductInfo(title: 'Eggs', description: 'Farm fresh, free-range eggs.'),
  ProductInfo(
    title: 'Sparkling Water',
    description: 'Refreshing and calorie-free.',
  ),
];

class ProductGrid extends StatelessWidget {
  final List<ProductInfo> products;
  const ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.2,
      children: products.map((prod) => ProductTile(product: prod)).toList(),
    );
  }
}

class ProductTile extends StatelessWidget {
  final ProductInfo product;
  const ProductTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            product.description,
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
