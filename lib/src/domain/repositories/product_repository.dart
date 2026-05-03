import 'package:iteco_test_zadanie/src/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductsPage({
    required int page,
    required int limit,
  });
}
