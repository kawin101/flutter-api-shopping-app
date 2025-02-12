import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/screens/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProductListScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutSuccessScreen(),
      },
    );
  }
}
