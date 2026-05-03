import 'package:dio/dio.dart';
import 'package:iteco_test_zadanie/src/data/models/product_model.dart';

class FakeStoreRemoteDataSource {
  FakeStoreRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> getProductsPage({
    required int page,
    required int limit,
  }) async {
    final response = await _dio.get<List<dynamic>>(_baseUrl);

    final data = response.data ?? <dynamic>[];
    if (data.isEmpty) {
      return <ProductModel>[];
    }
    final offset = (page - 1) * limit;

    return List<ProductModel>.generate(limit, (index) {
      final position = (offset + index) % data.length;
      final item = data[position] as Map<String, dynamic>;
      return ProductModel.fromJson(item);
    });
  }
}
