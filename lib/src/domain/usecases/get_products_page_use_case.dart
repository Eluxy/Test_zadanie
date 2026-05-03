import 'package:iteco_test_zadanie/src/domain/entities/product.dart';
import 'package:iteco_test_zadanie/src/domain/repositories/product_repository.dart';

class GetProductsPageUseCase {
  const GetProductsPageUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<Product>> call({
    required int page,
    required int limit,
  }) {
    return _repository.getProductsPage(page: page, limit: limit);
  }
}
