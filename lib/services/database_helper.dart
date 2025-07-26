import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shop_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create products table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        quantity TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final List<Map<String, dynamic>> initialProducts = [
      {
        'name': 'Organic Apple',
        'description': 'Fresh and crisp organic apples',
        'imageUrl':
            'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce',
        'quantity': '5 kg, Priceg',
        'price': 29.99,
        'category': 'Fresh Fruits & Vegetables',
        'isFavorite': 0,
      },
      {
        'name': 'Organic Banana',
        'description': 'Sweet and nutritious organic bananas',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnBGRbKoxcOGn0nJUmlqrbr40KN3EHhHgaOQ&s',
        'quantity': '4 kg, Priceg',
        'price': 59.99,
        'category': 'Fresh Fruits & Vegetables',
        'isFavorite': 0,
      },
      {
        'name': 'Organic Broccoli',
        'description': 'Fresh green organic broccoli',
        'imageUrl':
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
        'quantity': '7 kg, Priceg',
        'price': 89.99,
        'category': 'Fresh Fruits & Vegetables',
        'isFavorite': 0,
      },
      {
        'name': 'Organic Grapes',
        'description': 'Sweet and juicy organic grapes',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf8z0urRoJbyd29R928n1TIh04EZ9X-F-7gQ&s',
        'quantity': '8 kg, Priceg',
        'price': 19.99,
        'category': 'Fresh Fruits & Vegetables',
        'isFavorite': 0,
      },
      {
        'name': 'Extra Virgin Olive Oil',
        'description': 'Pure extra virgin olive oil',
        'imageUrl':
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5',
        'quantity': '500ml, Price',
        'price': 15.99,
        'category': 'Cooking Oil & Ghee',
        'isFavorite': 0,
      },
      {
        'name': 'Fresh Salmon Fillet',
        'description': 'Fresh Atlantic salmon fillet',
        'imageUrl':
            'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
        'quantity': '300g, Price',
        'price': 24.99,
        'category': 'Meat & Fish',
        'isFavorite': 0,
      },
      {
        'name': 'Whole Wheat Bread',
        'description': 'Freshly baked whole wheat bread',
        'imageUrl':
            'https://images.unsplash.com/photo-1509440159596-0249088772ff',
        'quantity': '500g, Price',
        'price': 3.99,
        'category': 'Bakery & Snacks',
        'isFavorite': 0,
      },
      {
        'name': 'Aged Cheddar Cheese',
        'description': 'Rich and creamy aged cheddar',
        'imageUrl':
            'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d',
        'quantity': '200g, Price',
        'price': 8.99,
        'category': 'Dairy & Eggs',
        'isFavorite': 0,
      },
      {
        'name': 'Fresh Orange Juice',
        'description': '100% pure squeezed orange juice',
        'imageUrl':
            'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b',
        'quantity': '1L, Price',
        'price': 4.99,
        'category': 'Beverages',
        'isFavorite': 0,
      },
      {
        'name': 'Diet Coke',
        'description': 'Refreshing diet cola',
        'imageUrl':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJ3mDCRTkEbjN6wsAvAoO2mW7SWXgIGbo_mA&s',
        'quantity': '355ml, Price',
        'price': 1.99,
        'category': 'Beverages',
        'isFavorite': 0,
      },
    ];

    for (var product in initialProducts) {
      await db.insert('products', product);
    }
  }

  // CRUD Operations

  // Create - Insert a new product
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', {
      'name': product.name,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'quantity': product.quantity,
      'price': product.price,
      'category': product.category ?? 'Uncategorized',
      'isFavorite': product.isFavorite ? 1 : 0,
    });
  }

  // Read - Get all products
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        quantity: maps[i]['quantity'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        isFavorite: maps[i]['isFavorite'] == 1,
      );
    });
  }

  // Read - Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        quantity: maps[i]['quantity'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        isFavorite: maps[i]['isFavorite'] == 1,
      );
    });
  }

  // Read - Get favorite products
  Future<List<Product>> getFavoriteProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        quantity: maps[i]['quantity'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        isFavorite: maps[i]['isFavorite'] == 1,
      );
    });
  }

  // Read - Search products by name
  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        quantity: maps[i]['quantity'],
        price: maps[i]['price'],
        category: maps[i]['category'],
        isFavorite: maps[i]['isFavorite'] == 1,
      );
    });
  }

  // Update - Update a product
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      {
        'name': product.name,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'quantity': product.quantity,
        'price': product.price,
        'category': product.category ?? 'Uncategorized',
        'isFavorite': product.isFavorite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Update - Toggle favorite status
  Future<int> toggleFavorite(int productId, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'products',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // Delete - Delete a product
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Get all categories
  Future<List<String>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      distinct: true,
      columns: ['category'],
    );
    return maps.map((map) => map['category'] as String).toList();
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
