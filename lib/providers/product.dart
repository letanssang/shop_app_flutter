import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-flutter-46e4b-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response =
          await http.put(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      rethrow;
    }
  }
}
