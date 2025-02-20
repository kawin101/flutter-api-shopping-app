import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shopping_app/providers/cart_provider.dart';
import 'package:flutter_shopping_app/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Logger _logger = Logger();
  TextEditingController _couponController = TextEditingController();

  Future<void> _checkout(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartData =
        cartProvider.cartItems.keys.map((product) => product.id).toList();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/orders/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'products': cartData}),
      );

      _logger.i('Request Body: ${jsonEncode({'products': cartData})}');
      _logger.i('Response Status: ${response.statusCode}');
      _logger.i('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        cartProvider.clearCart();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckoutSuccessScreen()),
        );
      } else {
        _showSnackBar(
            context, 'Checkout failed. Please try again.', Colors.red);
        _logger.e(
            'Checkout failed: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      _showSnackBar(
          context, 'An error occurred. Please try again.', Colors.red);
      _logger.e('Error during checkout: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cart',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Empty Cart', style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Go to shopping'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Cart',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems.keys.elementAt(index);
                final quantity = cartItems[product]!;
                return Dismissible(
                  key: Key(product.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cartProvider.removeProduct(product);
                    _showSnackBar(context, '${product.name} removed from cart',
                        Colors.red);
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                cartProvider.decrementProduct(product),
                          ),
                          Text(
                            '${NumberFormat('#,##0').format(quantity)}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                cartProvider.incrementProduct(product),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildCheckoutBar(context, cartProvider.subtotal),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, double subtotal) {
    final cartProvider = Provider.of<CartProvider>(context);
    final double discount = cartProvider.calculateDiscount();
    // final double totalWithCoupon = 100;
    final double totalWithDiscount = cartProvider.totalPriceWithDiscount;

    return Container(
      color: AppColors.backgroundPurple, // สีพื้นหลังตามที่กำหนด
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //TODO: text input for coupon code
          //TODO: button to apply coupon
          TextField(
            controller: _couponController,
            decoration: InputDecoration(
              hintText: 'Enter coupon code',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          ElevatedButton(onPressed: () {
            //TODO: call copuon discount function
          }, child: Text('Apply')),
          SizedBox(height: 10),
          _buildSummaryRow('Subtotal', subtotal),
          _buildSummaryRow('Promotion discount', discount, isDiscount: true),
          _buildSummaryRow('Coupon discount', totalWithDiscount, isDiscount: true),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${NumberFormat('#,##0.00').format(totalWithDiscount)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPurple,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPurple, // สีปุ่มตามที่กำหนด
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _checkout(context),
                  child: Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPurple, // สีตัวอักษรตามที่กำหนด
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}${NumberFormat('#,##0.00').format(amount)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              color: isDiscount
                  ? Colors.red
                  : AppColors.textPurple, // สีตามเงื่อนไข
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
