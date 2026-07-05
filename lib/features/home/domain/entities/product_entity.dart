import 'package:equatable/equatable.dart';

/// Represents a product in the FluxMarket application.
class ProductEntity extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double? ratingRate;
  final int? ratingCount;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.ratingRate,
    this.ratingCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    ratingRate,
    ratingCount,
  ];
}
