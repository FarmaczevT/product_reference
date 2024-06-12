import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isLoading = true;
  late Map<String, dynamic> _nutrients;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _nutrients = widget.product.nutrients;
    // Загружаем изображение и обновляем _isLoading, когда оно загрузится
    Image.network(widget.product.image ?? '').image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        setState(() {
          _isLoading = false;
        });
      }, onError: (dynamic exception, StackTrace? stackTrace) {
        setState(() {
          _isLoading = false;
        });
      }),
    );
    _checkFavoriteStatus();
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final productJson = jsonEncode(widget.product.toMap());
    if (_isFavorite) {
      favorites.add(productJson);
    } else {
      favorites.remove(productJson);
    }
    await prefs.setStringList('favorites', favorites);
  }

  void _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final productJson = jsonEncode(widget.product.toMap());
    setState(() {
      _isFavorite = favorites.contains(productJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.label),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(widget.product.image ?? ''),
                  const SizedBox(height: 16.0),
                  Text(
                    'Категория: ${widget.product.categoryLabel ?? ''}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Калорийность: ${_nutrients['ENERC_KCAL'] ?? ''} ккал',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Белки: ${_nutrients['PROCNT'] ?? ''} g',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Жиры: ${_nutrients['FAT'] ?? ''} g',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Углеводы: ${_nutrients['CHOCDF'] ?? ''} g',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : null,
                        ),
                        label: const Text(
                          'Добавить в избранное',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
