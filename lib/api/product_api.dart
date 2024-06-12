import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApi {
  static const String _baseUrl = 'https://api.edamam.com/api/food-database/v2/parser';
  static const String _appId = 'd086ce48';
  static const String _appKey = 'badade9516d57d14ad37e2565bef081b';

  static Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse(
      '$_baseUrl?ingr=$query&app_id=$_appId&app_key=$_appKey',
    ));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> hints = json['hints'];
      final List<Product> products = hints
          .map((hint) => Product.fromMap({
                'foodId': hint['food']['foodId'],
                'label': hint['food']['label'],
                'knownAs': hint['food']['knownAs'],
                'nutrients': hint['food']['nutrients'],
                'category': hint['food']['category'],
                'categoryLabel': hint['food']['categoryLabel'],
                'image': hint['food']['image'],
              }))
          .toList();
      return products;
    } else {
      throw Exception('Failed to search products');
    }
  }
}
