# **Shopping App (Flutter)**

## **Screenshots**

<table>
  <tr>
    <td>
      <strong>หน้าจอแสดงรายการสินค้า</strong><br>
      <img src="./screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20Max%20-%202025-02-12%20at%2021.22.32.png" alt="Product List">
    </td>
    <td>
      <strong>หน้าจอแสดงตะกร้าสินค้า</strong><br>
      <img src="./screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20Max%20-%202025-02-12%20at%2021.22.38.png" alt="Cart">
    </td>
  </tr>
  <tr>
    <td>
      <strong>หน้าจอ Checkout</strong><br>
      <img src="./screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20Max%20-%202025-02-12%20at%2021.22.47.png" alt="Checkout">
    </td>
    <td>
      <strong>หน้าจอแสดงผลสำเร็จ</strong><br>
      <img src="./screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20Max%20-%202025-02-12%20at%2021.23.41.png" alt="Success">
    </td>
  </tr>
  <tr>
    <td>
      <strong>หน้าจอแสดงข้อผิดพลาด</strong><br>
      <img src="./screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20Max%20-%202025-02-12%20at%2021.24.08.png" alt="Error">
    </td>
    <td>
      <strong>หน้าจอแสดง API Error</strong><br>
      <img src="./screenshot/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20Max%20-%202025-02-12%20at%2021.34.26.png" alt="New Screenshot">
    </td>
  </tr>
</table>

## **เกี่ยวกับโปรเจกต์**
Shopping App เป็นแอปพลิเคชันตัวอย่างสำหรับการซื้อสินค้า โดยมีฟังก์ชันหลักดังนี้:
- แสดงรายการสินค้า
- เพิ่มสินค้าในตะกร้า
- คำนวณราคารวม พร้อมส่วนลด 5% สำหรับสินค้าที่เพิ่มเป็นคู่
- Checkout พร้อมแสดงผลสำเร็จหรือข้อผิดพลาด
- จัดการ Error Handling เมื่อ API ล้มเหลว

---

## **API Server**

### **ติดตั้ง Dependencies**
```bash
bun install
```

### **เริ่มต้น API Server**
```bash
bun run index.ts
```

### **เอกสาร API**
สามารถเข้าถึง Swagger API Document ได้ที่  
[http://localhost:8080/swagger](http://localhost:8080/swagger)

---

## **การตั้งค่าและการใช้งาน**

1. **ติดตั้ง Flutter SDK**  
   ตรวจสอบว่าเครื่องของคุณติดตั้ง Flutter SDK แล้ว หากยังไม่ได้ติดตั้ง สามารถติดตั้งได้จาก [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

2. **รัน API Server**  
   - เปิด Terminal ในโฟลเดอร์ `shopping-api-server`  
   - ติดตั้ง dependencies ด้วยคำสั่ง:
     ```bash
     bun install
     ```
   - รัน API Server ด้วยคำสั่ง:
     ```bash
     bun run index.ts
     ```
   - เมื่อเริ่มรันสำเร็จ คุณสามารถเข้าไปดู API Document ได้ที่ [http://localhost:8080/swagger](http://localhost:8080/swagger)

3. **ติดตั้ง Dependencies สำหรับโปรเจกต์ Flutter**
   ```bash
   flutter pub get
   ```

4. **รันแอปพลิเคชัน**
   ```bash
   flutter run
   ```

---

## **โครงสร้างโครงการ**
```
├── lib
│   ├── main.dart               // Entry point ของแอป
│   ├── models                  // โมเดลสินค้า
│   │   └── product_model.dart
│   ├── providers               // จัดการสถานะของตะกร้าสินค้า
│   │   └── cart_provider.dart
│   ├── screens                 // หน้าจอ UI หลัก
│   │   ├── cart_screen.dart         // หน้าจอแสดงตะกร้าสินค้า
│   │   ├── checkout_screen.dart     // หน้าจอสำหรับดำเนินการ Checkout
│   │   └── product_list_screen.dart // หน้าจอรายการสินค้า
│   ├── service                 // จัดการ API
│   │   └── api_service.dart
└── test                        // Unit Test
    └── cart_provider_test.dart
```
