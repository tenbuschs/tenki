import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v0/product/';

  static Future<String> getProduct(String barcode) async {
    final response = await http.get(Uri.parse(_baseUrl + barcode + '.json'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load product');
    }
  }
}
