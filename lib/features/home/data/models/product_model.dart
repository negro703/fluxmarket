import 'package:flutter/foundation.dart';

import '../../domain/entities/product_entity.dart';

/// Data layer model for a product, with JSON serialization/deserialization.
///
/// Extends [ProductEntity] so it can be used wherever the entity is expected,
/// maintaining Clean Architecture dependency rules (data depends on domain).
@immutable
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    super.ratingRate,
    super.ratingCount,
  });

  /// Creates a [ProductModel] from a JSON map (e.g., API response).
  ///
  /// Compatible with the FakeStoreAPI response format.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parse rating sub-object
    double? ratingRate;
    int? ratingCount;

    if (json['rating'] != null && json['rating'] is Map<String, dynamic>) {
      final rating = json['rating'] as Map<String, dynamic>;
      ratingRate = (rating['rate'] as num?)?.toDouble();
      ratingCount = (rating['count'] as num?)?.toInt();
    }

    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      ratingRate: ratingRate,
      ratingCount: ratingCount,
    );
  }

  /// Converts this model to a JSON map for API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {
        'rate': ratingRate,
        'count': ratingCount,
      },
    };
  }
}