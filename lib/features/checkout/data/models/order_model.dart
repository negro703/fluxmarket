import 'package:hive/hive.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/order_entity.dart';

/// Data layer model for an order, with Hive serialization support.
///
/// This is a standalone Hive-serializable class that converts to/from
/// [OrderEntity], maintaining Clean Architecture dependency rules.
class OrderModel {
  final String id;
  final int itemCount;
  final double subtotal;
  final double tax;
  final double total;
  final String deliveryAddress;
  final String deliveryPhone;
  final String paymentMethod;
  final DateTime createdAt;
  final String? status;

  OrderModel({
    required this.id,
    required this.itemCount,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.paymentMethod,
    required this.createdAt,
    this.status = 'completed',
  });

  /// Creates an [OrderModel] from an [OrderEntity].
  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      itemCount: entity.items.fold<int>(0, (sum, item) => sum + item.quantity),
      subtotal: entity.subtotal,
      tax: entity.tax,
      total: entity.total,
      deliveryAddress: entity.deliveryAddress,
      deliveryPhone: entity.deliveryPhone,
      paymentMethod: entity.paymentMethod,
      createdAt: entity.createdAt,
      status: entity.status,
    );
  }

  /// Converts this model back to an [OrderEntity] with cart items placeholder.
  /// Note: Original cart items are not persisted; use for summary display.
  OrderEntity toEntity(List<CartItemEntity> items) {
    return OrderEntity(
      id: id,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      deliveryAddress: deliveryAddress,
      deliveryPhone: deliveryPhone,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      status: status,
    );
  }

  /// Creates an [OrderModel] from a Hive read map.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      itemCount: json['itemCount'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryPhone: json['deliveryPhone'] as String,
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
    );
  }

  /// Converts this model to a JSON-serializable map for storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemCount': itemCount,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'deliveryPhone': deliveryPhone,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}

/// Manual Hive TypeAdapter for [OrderModel].
class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 1;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return OrderModel(
      id: fields[0] as String,
      itemCount: fields[1] as int,
      subtotal: fields[2] as double,
      tax: fields[3] as double,
      total: fields[4] as double,
      deliveryAddress: fields[5] as String,
      deliveryPhone: fields[6] as String,
      paymentMethod: fields[7] as String,
      createdAt: fields[8] as DateTime,
      status: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemCount)
      ..writeByte(2)
      ..write(obj.subtotal)
      ..writeByte(3)
      ..write(obj.tax)
      ..writeByte(4)
      ..write(obj.total)
      ..writeByte(5)
      ..write(obj.deliveryAddress)
      ..writeByte(6)
      ..write(obj.deliveryPhone)
      ..writeByte(7)
      ..write(obj.paymentMethod)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.status);
  }

  @override
  int get hashCode => super.hashCode;
}
