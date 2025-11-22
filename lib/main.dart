import 'package:flutter/material.dart';

// --- STRUKTUR DATA APLIKASI ---
class Category {
  final String name;
  final IconData icon;
  final Color color;
  
  Category({
    required this.name, 
    required this.icon,
    required this.color,
  });
}

class Product {
  final String categoryName;
  final String name;
  final IconData icon;
  final double price;
  
  Product({
    required this.categoryName,
    required this.name,
    required this.icon,
    required this.price,
  });

  String get formattedPrice => 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
    (Match m) => '${m[1]}.'
  )}';
}

// Data Dummy
final List<Category> availableCategories = [
  Category(name: 'Makanan', icon: Icons.restaurant_outlined, color: Colors.orange),
  Category(name: 'Minuman', icon: Icons.local_cafe_outlined, color: Colors.blue),
  Category(name: 'Elektronik', icon: Icons.phone_android_outlined, color: Colors.purple),
];

final List<Product> availableProducts = [
  Product(categoryName: 'Makanan', name: 'Nasi Goreng Spesial', icon: Icons.rice_bowl, price: 25000),
  Product(categoryName: 'Makanan', name: 'Mie Ayam Jumbo', icon: Icons.ramen_dining, price: 18000),
  Product(categoryName: 'Minuman', name: 'Es Teh Manis', icon: Icons.emoji_food_beverage, price: 5000),
  Product(categoryName: 'Minuman', name: 'Kopi Susu Dingin', icon: Icons.coffee, price: 15000),
  Product(categoryName: 'Elektronik', name: 'Headphone Nirkabel', icon: Icons.headphones, price: 450000),
  Product(categoryName: 'Elektronik', name: 'Power Bank 10K', icon: Icons.battery_charging_full, price: 220000),
];

void main() {
  runApp(const MyShopMiniApp());
}

class MyShopMiniApp extends StatelessWidget {
  const MyShopMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop Mini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// --- HOMESCREEN ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 600;
            final padding = isDesktop ? 48.0 : 20.0;
            
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(isDesktop),
                    SizedBox(height: isDesktop ? 48 : 32),
                    
                    // Grid Kategori
                    _buildCategoryGrid(context, isDesktop),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MyShop Mini',
          style: TextStyle(
            fontSize: isDesktop ? 36 : 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih kategori untuk mulai berbelanja',
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context, bool isDesktop) {
    final crossAxisCount = isDesktop ? 3 : 1;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isDesktop ? 1.5 : 3.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: availableCategories.length,
      itemBuilder: (context, index) {
        final category = availableCategories[index];
        return _CategoryCard(category: category);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ProductListScreen(category: category),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lihat produk',
                    style: TextStyle(
                      fontSize: 14,
                      color: category.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFCBD5E1),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// --- PRODUCTLISTSCREEN ---
class ProductListScreen extends StatelessWidget {
  final Category category;
  
  const ProductListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = availableProducts
        .where((product) => product.categoryName == category.name)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final isDesktop = constraints.maxWidth >= 600;
          final crossAxisCount = isDesktop ? 4 : 2;
          final padding = isDesktop ? 48.0 : 20.0;
          
          return filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(padding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (ctx, index) {
                    return _ProductCard(
                      product: filteredProducts[index],
                      color: category.color,
                    );
                  },
                );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final Color color;
  
  const _ProductCard({required this.product, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ProductDetailScreen(product: product, color: color),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  product.icon,
                  size: 56,
                  color: color,
                ),
              ),
            ),
            
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      product.formattedPrice,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PRODUCTDETAILSCREEN ---
class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Color color;
  
  const ProductDetailScreen({
    super.key, 
    required this.product,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 600;
          
          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isDesktop ? 500 : double.infinity),
                padding: EdgeInsets.all(isDesktop ? 48 : 20),
                child: Column(
                  children: [
                    // Icon Container
                    Container(
                      width: double.infinity,
                      height: isDesktop ? 300 : 240,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        product.icon,
                        size: isDesktop ? 120 : 100,
                        color: color,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Product Name
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Price
                    Text(
                      product.formattedPrice,
                      style: TextStyle(
                        fontSize: isDesktop ? 36 : 32,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Buy Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} ditambahkan ke keranjang'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Beli Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}