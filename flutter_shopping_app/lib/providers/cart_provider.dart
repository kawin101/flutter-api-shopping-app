import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/models/product_model.dart';

/// CartProvider คือคลาสสำหรับจัดการสถานะของตะกร้าสินค้า
/// - เพิ่มสินค้า
/// - ลบสินค้า
/// - คำนวณราคาสินค้ารวม และส่วนลด
/// 
/// คุณสมบัติหลัก:
/// 1. `subtotal` คำนวณราคารวมก่อนคิดส่วนลด
/// 2. `calculateDiscount` คำนวณส่วนลด 5% สำหรับคู่สินค้า
/// 3. `totalPriceWithDiscount` คืนราคาหลังหักส่วนลด
/// 
/// ใช้ร่วมกับ Flutter และ Provider เพื่อติดตามและจัดการสถานะของตะกร้าสินค้า
class CartProvider with ChangeNotifier {
  final Map<Product, int> _cartItems = {};

  Map<Product, int> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void incrementProduct(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
      notifyListeners();
    }
  }

  void decrementProduct(Product product) {
    if (_cartItems.containsKey(product) && _cartItems[product]! > 1) {
      _cartItems[product] = _cartItems[product]! - 1;
      notifyListeners();
    } else {
      removeProduct(product);
    }
  }

  void removeProduct(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  int getItemQuantity(Product product) => _cartItems[product] ?? 0;

  /// **Subtotal**: ราคาก่อนคิดส่วนลด
  double get subtotal {
    return _cartItems.entries
        .fold(0, (total, entry) => total + (entry.key.price * entry.value));
  }

  /// **คำนวณส่วนลด 5% สำหรับคู่สินค้า**
  double calculateDiscount() {
    double totalDiscount = 0.0;

    _cartItems.forEach((product, quantity) {
      int pairCount = quantity ~/ 2; // จำนวนคู่
      double pairPrice = pairCount * (product.price * 2);
      double discount = pairPrice * 0.05; // ส่วนลด 5% ของราคา 2 ชิ้น
      totalDiscount += discount;
    });

    return totalDiscount;
  }

  /// **Total หลังหักส่วนลด**
  double get totalPriceWithDiscount {
    return subtotal - calculateDiscount();
  }

    double get totalPriceWithCouponDiscount {
    return subtotal - 100.00;
  }

  //TODO: function for coupon discount code = "DISCOUNT100"


  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
