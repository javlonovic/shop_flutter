import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'widgets/product_card.dart';
import 'pages/product_detail_page.dart';
import 'pages/cart_page.dart';
import 'pages/favourite_page.dart';
import 'widgets/category_grid.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Shop',
    theme: ThemeData(
      fontFamily: 'Gilroy',
      textTheme: ThemeData.light().textTheme
          .apply(
            fontFamily: 'Gilroy',
            bodyColor: Colors.black,
            displayColor: Colors.black,
          )
          .copyWith(
            bodyLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontWeight: FontWeight.bold),
            bodySmall: TextStyle(fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontWeight: FontWeight.bold),
            labelLarge: TextStyle(fontWeight: FontWeight.bold),
            labelMedium: TextStyle(fontWeight: FontWeight.bold),
            labelSmall: TextStyle(fontWeight: FontWeight.bold),
            headlineLarge: TextStyle(fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          ),
    ),
    home: ChangeNotifierProvider(
      create: (context) => ProductProvider()..initialize(),
      child: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _searchQuery = '';
  List<Product> cart = [];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products;
        final filteredProducts = products
            .where(
              (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
        final bestSellingProducts = productProvider.getBestSellingProducts(3);

        final pages = [
          // Home
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Tashkent , Uzbekistan',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            body: productProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F3F2),
                              labelText: 'Search Store',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                          ),
                        ),
                        // Exclusive Offer header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Exclusive Offer',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ExclusiveOfferPage(
                                        products: products,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Exclusive Offer horizontal list
                        SizedBox(
                          height: 280,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double cardWidth = 160;
                              double listPadding =
                                  (constraints.maxWidth -
                                      (cardWidth * filteredProducts.length)) /
                                  2;
                              listPadding = listPadding < 8 ? 8 : listPadding;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                  horizontal: listPadding,
                                  vertical: 8,
                                ),
                                itemCount: filteredProducts.length,
                                itemBuilder: (ctx, i) {
                                  final prod = filteredProducts[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailPage(
                                            product: prod,
                                            onAddToCart: () =>
                                                _onAddToCart(prod),
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: cardWidth,
                                        child: ProductCard(product: prod),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // Best Selling header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Best Selling',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BestSellingPage(products: products),
                                    ),
                                  );
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Best Selling horizontal list
                        SizedBox(
                          height: 280,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double cardWidth = 160;
                              double listPadding =
                                  (constraints.maxWidth -
                                      (cardWidth *
                                          bestSellingProducts.length)) /
                                  2;
                              listPadding = listPadding < 8 ? 8 : listPadding;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                  horizontal: listPadding,
                                  vertical: 8,
                                ),
                                itemCount: bestSellingProducts.length,
                                itemBuilder: (ctx, i) {
                                  final prod = bestSellingProducts[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailPage(
                                            product: prod,
                                            onAddToCart: () =>
                                                _onAddToCart(prod),
                                          ),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: cardWidth,
                                        child: ProductCard(product: prod),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Explore
          ExplorePage(),
          // Cart
          CartPage(cartItems: cart),
          // Favourites
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return FavouritePage(favourites: productProvider.favorites);
            },
          ),
        ];

        return Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
            selectedItemColor: Colors.green,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.store_outlined),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_search_outlined),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favourite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddToCart(Product product) {
    setState(() {
      if (!cart.contains(product)) cart.add(product);
    });
  }
}

class AllProductsPage extends StatelessWidget {
  final List<Product> products;
  const AllProductsPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Products')),
      body: ListView(
        children: products
            .map(
              (prod) => ListTile(
                leading: Image.network(
                  prod.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                title: Text(prod.name),
                subtitle: Text(prod.quantity),
                trailing: Text('\$24${prod.price.toStringAsFixed(2)}'),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ExclusiveOfferPage extends StatelessWidget {
  final List<Product> products;
  const ExclusiveOfferPage({super.key, required this.products});

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
          'Exclusive Offer',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
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
      ),
    );
  }
}

class BestSellingPage extends StatelessWidget {
  final List<Product> products;
  const BestSellingPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final sorted = List<Product>.from(products)
      ..sort((a, b) => b.price.compareTo(a.price));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Best Selling',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 24.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: sorted.length,
            itemBuilder: (context, i) => ProductCard(product: sorted[i]),
          ),
        ),
      ),
    );
  }
}
