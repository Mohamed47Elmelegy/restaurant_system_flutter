import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase({required this.repository});

  Future<Product> call(Product product) async {
    return await repository.createProduct(product);
  }
}
