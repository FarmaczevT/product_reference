import 'package:flutter/material.dart';
import '../api/product_api.dart';
import '../models/product.dart';
import 'product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Поиск продуктов...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            if (query.isNotEmpty) {
              _searchProducts(query);
            } else {
              setState(() {
                _searchResults = [];
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchResults = [];
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ListTile(
            title: Text(product.label),
            subtitle: Text('Калорийность: ${product!.nutrients['ENERC_KCAL']} ккал'),
            leading: Image.network(product.image),
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

  Future<void> _searchProducts(String query) async {
    try {
      // final productApi = ProductApi(); // Создаем экземпляр класса ProductApi
      final results = await ProductApi.searchProducts(query); // Вызываем метод searchProducts у экземпляра
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print(e);
    }
  }
}
