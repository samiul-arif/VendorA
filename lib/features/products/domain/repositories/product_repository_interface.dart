import '../../../../core/utils/result.dart';
import '../../../../shared/models/pagination_model.dart';
import '../models/product_model.dart';

// Product & Inventory Repository Contract
abstract class IProductRepository {
  // Get paginated products for a shop with optional category and search filters
  Future<Result<PaginatedList<ProductModel>>> getProducts({
    required String shopId,
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  });

  // Get single product details by ID
  Future<Result<ProductModel>> getProductById({
    required String productId,
  });

  // Add a new product to the catalog
  Future<Result<ProductModel>> addProduct({
    required ProductModel product,
  });

  // Update existing product details after publishing
  Future<Result<ProductModel>> updateProduct({
    required ProductModel product,
  });

  // Delete or archive product
  Future<Result<void>> deleteProduct({
    required String productId,
    bool softDelete = false,
  });

  // 1-Tap Toggle Product Availability (Manual Offline Sync)
  Future<Result<ProductModel>> toggleProductAvailability({
    required String productId,
    required bool isAvailable,
  });

  // Quick Restock Product Quantity
  Future<Result<ProductModel>> restockProduct({
    required String productId,
    required int addQuantity,
  });
}
