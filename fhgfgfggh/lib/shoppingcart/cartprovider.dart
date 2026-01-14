import 'package:flutter/material.dart';

class AppState with ChangeNotifier{
  int selectedIndex = 0;
  Map<String, String> userData = {
    'Name': 'John Doe',
    'Email': 'john@example.com',
    'Password': 'johndoe',
  };

  final List<String> category = <String>['All', 'Smartphones', 'Headphones', 'Laptops'];
  final Map<String, List<Map<String, dynamic>>> categoryItems = {
    'Smartphones': [
      {
        'name': 'Iphone 13',
        'description': 'The iPhone 13 features a 6.1‑inch Super Retina XDR display, A15 Bionic chip, and advanced dual-camera system for stunning photos and video.',
        'cost': 1199.00,
        'rating': 4.7,
        'image': 'iphone13.png',
        'extras': {
          'options': ['128GB', '256GB', '512GB'],
          'costs': [1199.00, 1299.00, 1399.00],
          'selected': '128GB',
        },
        'count': 1,
      },
    ],
    'Headphones': [
      {
        'name': 'Airpods',
        'description': 'Apple AirPods offer high-quality wireless audio, effortless pairing with Apple devices, and active noise cancellation for immersive sound.',
        'cost': 132.00,
        'rating': 4.9,
        'image': 'airpods.png',
        'extras': {
          'options': ['White', 'Black'],
          'costs': [132.00, 142.00],
          'selected': 'White',
        },
        'count': 1
      },
    ],
    'Laptops': [
      {
        'name': 'Macbook Air 13',
        'description': 'The MacBook Air 13-inch is powered by the Apple M1 chip, featuring all-day battery life, Retina display, and silent fanless design.',
        'cost': 1100.00,
        'rating': 5.0,
        'image': 'macbookair.png',
        'extras': {
          'options': ['256GB SSD', '512GB SSD', '1TB SSD'],
          'costs': [1100.00, 1200.00, 1300.00],
          'selected': '256GB SSD',
        },
        'count': 1
      }
    ],
    'Other': [
      {
        'name': 'Xbox Series X',
        'description': 'Experience 4K gaming at up to 120 FPS with the Xbox Series X, featuring a custom SSD, fast load times, and powerful graphics performance.',
        'cost': 650.00,
        'rating': 4.8,
        'image': 'xbox.png',
        'extras': {
          'options': ['Black', 'White'],
          'costs': [650.00, 750.00],
          'selected': 'Black',
        },
        'count': 1
      },
      {
        'name': 'Wireless Controller',
        'description': 'Ergonomic wireless controller with textured grip, responsive buttons, and up to 40 hours of battery life for Xbox and PC gaming.',
        'cost': 77.00,
        'rating': 4.1,
        'image': 'controller.png',
        'extras': {
          'options': ['Black', 'White', 'Red'],
          'costs': [77.00, 87.00, 97.00],
          'selected': 'Black',
        },
        'count': 1
      },
    ],
  };
  List<Map<String, dynamic>> cart = [];
  late List<Map<String, dynamic>> favourites = [];

  void setTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  double cartCount(){
    double count = 0;
    for (Map<String, dynamic> item in cart){
      count += item['count'].toInt();
    }
    return count;
  }

  double subtotal(){
    double total = 0.0;
    for (Map<String, dynamic> item in cart){
      total += item['cost'] * item['count'];
    }
    return total;
  }

  double applyDiscount(){
    double discount = 0.40;
    return double.parse((subtotal() * (1 - discount)).toStringAsFixed(2));
  }

  double total(){
    double delivery = 5.00;
    return applyDiscount() + delivery;
  }

  void addToCart(Map<String, dynamic> item) {

    final existingIndex = cart.indexWhere((cartItem) =>
      cartItem['name'] == item['name'] &&
        cartItem['extras']['selected'] == item['extras']['selected']
    );

    if (existingIndex != -1) {
      // Item exists — increase count
      cart[existingIndex]['count'] += 1;
    } else {
      item['count'] = 1;
      cart.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    cart.remove(item);
    notifyListeners();
  }

  void clearCart(){
    cart.clear();
    notifyListeners();
  }

  void incrementCounter(int index) {
    cart[index]['count'] += 1;
    notifyListeners();
  }

  void decrementCounter(int index) {
    if (cart[index]['count'] > 1) {
      cart[index]['count'] -= 1;
    }
    notifyListeners();
  }

  bool isFavourite(Map<String, dynamic> item) {
    return favourites.any((fav) =>
    fav['name'] == item['name'] &&
        fav['extras']['selected'] == item['extras']['selected']
    );
  }

  void toggleFavourite(Map<String, dynamic> item) {
    if (favourites.contains(item)) {
      favourites.remove(item);
    } else {
      favourites.add(item);
    }
    notifyListeners();
  }

  void removeFromFavourite(Map<String, dynamic> item) {
    favourites.remove(item);
    notifyListeners();
  }

  // Optional: user data update methods
  void updateUserData(Map<String, String> newUserData) {
    userData = newUserData;
    notifyListeners();
  }
}