import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_app/providers/cart_provider.dart';
import 'package:flutter_shopping_app/models/product_model.dart';
import 'package:logger/logger.dart';

/// **การทำงานของโค้ดนี้**  
/// เป็นชุดการทดสอบ `CartProvider` สำหรับจัดการตะกร้าสินค้า โดยใช้ `flutter_test`  
/// เพื่อทดสอบฟังก์ชันต่าง ๆ เช่น การเพิ่มสินค้า การลบสินค้า การคำนวณราคารวม และส่วนลด  
///  
/// **โครงสร้างการทำงาน:**  
/// - ใช้ `Logger` ในการแสดงผลลัพธ์ของการทดสอบแต่ละขั้นตอน  
/// - `setUp()` ถูกใช้สำหรับเตรียมข้อมูลก่อนการทดสอบ  
/// - `tearDown()` ทำงานหลังจากจบแต่ละการทดสอบ เพื่อแสดงข้อความสรุป  
/// 
/// **รายละเอียดการทำงาน:**  
/// 1. **setUp**: สร้าง `CartProvider` ใหม่ และเตรียม `Product` ตัวอย่าง (`product1`, `product2`)  
/// 2. **test('Add product to cart')**: ทดสอบการเพิ่มสินค้าในตะกร้า และตรวจสอบว่าสินค้าถูกเพิ่มสำเร็จ  
/// 3. **test('Calculate subtotal')**: ทดสอบการคำนวณราคารวมของสินค้าในตะกร้าก่อนหักส่วนลด  
/// 4. **test('Calculate discount for pairs')**: ทดสอบการคำนวณส่วนลด 5% เมื่อเพิ่มสินค้าเป็นคู่  
/// 5. **test('Calculate total price with discount')**: ทดสอบการคำนวณราคาหลังหักส่วนลด  
/// 6. **test('Remove product from cart')**: ทดสอบการลบสินค้าออกจากตะกร้า และตรวจสอบว่าสินค้าถูกลบสำเร็จ  
/// 7. **tearDown**: แสดงข้อความเมื่อจบการทดสอบแต่ละรายการ  
/// 8. **All tests completed successfully.**: แสดงข้อความสรุปเมื่อการทดสอบทั้งหมดเสร็จสิ้น  
///  
/// **ประโยชน์:**  
/// - ช่วยให้มั่นใจได้ว่า `CartProvider` ทำงานได้ถูกต้อง  
/// - ช่วยในการ Debug และติดตามข้อผิดพลาดได้ง่ายผ่าน `logger`  
/// - ส่งเสริมการเขียนโค้ดคุณภาพสูงและตรวจสอบได้ง่าย  
void main() {
  final logger = Logger(); // สร้าง Logger instance
  group('CartProvider Tests', () {
    late CartProvider cartProvider;
    late Product product1;
    late Product product2;

    setUp(() {
      cartProvider = CartProvider();
      product1 = Product(id: 1, name: 'Product 1', price: 500);
      product2 = Product(id: 2, name: 'Product 2', price: 350);
      logger.i('CartProvider initialized.');
    });

    test('Add product to cart', () {
      cartProvider.addToCart(product1);
      expect(cartProvider.cartItems[product1], 1);
      logger.i('Test: Add product to cart - Passed');
    });

    test('Calculate subtotal', () {
      cartProvider.addToCart(product1);
      cartProvider.addToCart(product2);
      double subtotal = cartProvider.subtotal;
      expect(subtotal, 850);
      logger.i('Test: Calculate subtotal - Passed | Subtotal: $subtotal');
    });

    test('Calculate discount for pairs', () {
      cartProvider.addToCart(product1);
      cartProvider.addToCart(product1); // เพิ่ม 2 ชิ้น เพื่อให้ได้ส่วนลด
      double discount = cartProvider.calculateDiscount();
      expect(discount, 50); // ส่วนลด 5% ของ 1000 คือ 50
      logger.i('Test: Calculate discount - Passed | Discount: $discount');
    });

    test('Calculate total price with discount', () {
      cartProvider.addToCart(product1);
      cartProvider.addToCart(product1); // เพิ่ม 2 ชิ้น
      double total = cartProvider.totalPriceWithDiscount;
      expect(total, 950);
      logger.i('Test: Calculate total price with discount - Passed | Total: $total');
    });

    test('Remove product from cart', () {
      cartProvider.addToCart(product1);
      cartProvider.removeProduct(product1);
      expect(cartProvider.cartItems.containsKey(product1), false);
      logger.i('Test: Remove product from cart - Passed');
    });

    tearDown(() {
      logger.i('Test completed.');
    });
  });

  logger.i('All tests completed successfully.');
}
