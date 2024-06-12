import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/product_details_screen.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites =
          favorites.map((json) => Product.fromMap(jsonDecode(json))).toList();
    });
  }

  Future<void> _removeFromFavorites(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final productJson = jsonEncode(product.toMap());
    favorites.remove(productJson);
    await prefs.setStringList('favorites', favorites);
    setState(() {
      _favorites.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final product = _favorites[index];
          return ListTile(
            leading: Image.network(product.image),
            title: Text(product.label),
            subtitle: Text('Категория: ${product.categoryLabel}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removeFromFavorites(product);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
