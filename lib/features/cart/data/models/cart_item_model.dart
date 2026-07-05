import 'package:hive/hive.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Data layer model for a cart item, with Hive serialization support.
///
/// This is a standalone Hive-serializable class that converts to/from
/// [CartItemEntity], maintaining Clean Architecture dependency rules.
class CartItemModel {
  final int quantity;
  final Map<String, dynamic> productData;

  CartItemModel({required this.quantity, required this.productData});

  /// Creates a [CartItemModel] from a [CartItemEntity].
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      quantity: entity.quantity,
      productData: _productToMap(entity.product),
    );
  }

  /// Converts this model back to a [CartItemEntity].
  CartItemEntity toEntity() {
    return CartItemEntity(
      product: _mapToProduct(productData),
      quantity: quantity,
    );
  }

  /// Reconstructs a [ProductEntity] from a stored data map.
  static ProductEntity _mapToProduct(Map<String, dynamic> data) {
    return ProductEntity(
      id: data['id'] as int,
      title: data['title'] as String,
      price: (data['price'] as num).toDouble(),
      description: data['description'] as String,
      category: data['category'] as String,
      image: data['image'] as String,
      ratingRate: (data['ratingRate'] as num?)?.toDouble(),
      ratingCount: (data['ratingCount'] as num?)?.toInt(),
    );
  }

  /// Converts a [ProductEntity] to a serializable Map for Hive storage.
  static Map<String, dynamic> _productToMap(ProductEntity product) {
    return {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.image,
      'ratingRate': product.ratingRate,
      'ratingCount': product.ratingCount,
    };
  }
}

/// Manual Hive TypeAdapter for [CartItemModel].
///
/// This adapter is registered manually in `injection_container.dart`
/// to allow Hive to serialize/deserialize [CartItemModel] objects.
class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 0;

  @override
  CartItemModel read(BinaryReader reader) {
    final quantity = reader.readInt();
    final productData = reader.readMap().cast<String, dynamic>();
    return CartItemModel(quantity: quantity, productData: productData);
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer.writeInt(obj.quantity);
    writer.writeMap(obj.productData);
  }
}
