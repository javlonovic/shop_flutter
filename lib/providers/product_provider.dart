import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class ProductProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Product> _products = [];
  List<Product> _favorites = [];
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> initialize() async {
    await loadProducts();
    await loadFavorites();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _databaseHelper.getAllProducts();
      print('Loaded products: ${_products.length}');
    } catch (e) {
      print('Error loading products: $e');
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Provider
  Future<void> loadFavorites() async {
    try {
      _favorites = await _databaseHelper.getFavoriteProducts();
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
      _favorites = [];
    }
  }

  // Produktlani kategoriya boyicha olish
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await _databaseHelper.getProductsByCategory(category);
    } catch (e) {
      print('Error loading products by category: $e');
      return [];
    }
  }

  // Produktni favoritga qoshish
  Future<void> toggleFavorite(Product product) async {
    try {
      final newFavoriteStatus = !product.isFavorite;
      await _databaseHelper.toggleFavorite(product.id!, newFavoriteStatus);

      // Update favorites
      await loadFavorites();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    try {
      await _databaseHelper.updateProduct(product);

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }

      // Favorites update
      final favIndex = _favorites.indexWhere((p) => p.id == product.id);
      if (favIndex != -1) {
        _favorites[favIndex] = product;
      }

      notifyListeners();
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // best selling products
  List<Product> getBestSellingProducts([int count = 3]) {
    final sorted = List<Product>.from(_products)
      ..sort((a, b) => b.price.compareTo(a.price));
    return sorted.take(count).toList();
  }

  // Get all products
  List<Product> getExclusiveOfferProducts() {
    return _products;
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }
}
