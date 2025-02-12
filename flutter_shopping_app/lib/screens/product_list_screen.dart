import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shopping_app/models/product_model.dart';
import 'package:flutter_shopping_app/service/api_service.dart';
import 'package:flutter_shopping_app/screens/cart_screen.dart';
import 'package:flutter_shopping_app/providers/cart_provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _recommendedProducts;
  List<Product> _latestProducts = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _recommendedProducts = ApiService().fetchRecommendedProducts();
    _fetchLatestProducts();
  }

  Future<void> _fetchLatestProducts() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    try {
      List<Product> newProducts =
          await ApiService().fetchProducts(page: _currentPage);
      setState(() {
        _latestProducts.addAll(newProducts);
        _currentPage++;
        if (newProducts.isEmpty) _hasMore = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            _buildSectionTitle('Recommended Products'),
            SizedBox(height: 10),
            _buildRecommendedProductSection(cartProvider),
            SizedBox(height: 45),
            _buildSectionTitle('Latest Products'),
            SizedBox(height: 10),
            _buildLatestProductSection(cartProvider),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
    );
  }

  Widget _buildRecommendedProductSection(CartProvider cartProvider) {
    return FutureBuilder<List<Product>>(
      future: _recommendedProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorUI();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recommended products available'));
        }

        final products = snapshot.data!;
        return _buildProductList(products, cartProvider);
      },
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red, size: 80),
          SizedBox(height: 10),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _recommendedProducts = ApiService().fetchRecommendedProducts();
              });
            },
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestProductSection(CartProvider cartProvider) {
    return Column(
      children: [
        ..._latestProducts
            .map((product) => _buildProductItem(product, cartProvider))
            .toList(),
        if (_isLoadingMore) Center(child: CircularProgressIndicator()),
        if (!_hasMore) Center(child: Text('No more products')),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProductList(List<Product> products, CartProvider cartProvider) {
    return Column(
      children: products
          .map((product) => _buildProductItem(product, cartProvider))
          .toList(),
    );
  }

  Widget _buildProductItem(Product product, CartProvider cartProvider) {
    int quantity = cartProvider.getItemQuantity(product);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.image, size: 50),
        title: Text(
          product.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPurple,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${NumberFormat('#,##0.00').format(product.price)} ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.textPurple,
              ),
            ),
            Text(
              '/ unit',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPurple,
              ),
            ),
          ],
        ),
        trailing: quantity > 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      cartProvider.decrementProduct(product);
                    },
                  ),
                  Text(
                    '${NumberFormat('#,##0').format(quantity)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      cartProvider.incrementProduct(product);
                    },
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  cartProvider.addToCart(product);
                },
                child: Text('Add to cart'),
              ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    int totalCartItems = cartProvider.cartItems.values
        .fold(0, (sum, quantity) => sum + quantity);

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.stars), label: 'Shopping'),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars_outlined),
          label: 'Cart (${NumberFormat('#,##0').format(totalCartItems)})',
        ),
      ],
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
        }
      },
    );
  }
}
