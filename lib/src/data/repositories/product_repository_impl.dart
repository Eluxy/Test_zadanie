import 'package:iteco_test_zadanie/src/data/datasources/fake_store_remote_data_source.dart';
import 'package:iteco_test_zadanie/src/domain/entities/product.dart';
import 'package:iteco_test_zadanie/src/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remoteDataSource);

  final FakeStoreRemoteDataSource _remoteDataSource;

  @override
  Future<List<Product>> getProductsPage({
    required int page,
    required int limit,
  }) async {
    final models = await _remoteDataSource.getProductsPage(page: page, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
}
