class Product {
  final int? id; 
  final String name;
  final String description;
  final String imageUrl;
  final String quantity;
  final double price;
  final String? category; 
  final bool isFavorite; 

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    this.category,
    this.isFavorite = false,
  });

  // Map dan product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
      price: map['price'],
      category: map['category'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  // product data base map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
      'category': category,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

 

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
