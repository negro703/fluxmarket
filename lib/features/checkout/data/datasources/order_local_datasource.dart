import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

/// Local data source for order persistence using Hive.
///
/// Stores order summaries as [OrderModel] objects in a Hive box,
/// providing persistent storage across app restarts.
@LazySingleton()
class OrderLocalDataSource {
  static const String _boxName = 'orders_box';

  Box<OrderModel>? _box;
  bool _initialized = false;

  OrderLocalDataSource();

  /// Initializes the Hive box. Must be called before any other operation.
  Future<void> init() async {
    // Adapter is already registered in injection_container.dart
    try {
      _box = await Hive.openBox<OrderModel>(_boxName);
      _initialized = true;
    } catch (e) {
      throw CacheException(message: 'Failed to initialize orders box: $e');
    }
  }

  /// Ensures the Hive box is open before any operation.
  Future<Box<OrderModel>> _getBox() async {
    // Adapter is already registered in injection_container.dart
    if (!_initialized || _box == null || !_box!.isOpen) {
      try {
        _box = await Hive.openBox<OrderModel>(_boxName);
        _initialized = true;
      } catch (e) {
        throw CacheException(message: 'Failed to open orders box: $e');
      }
    }
    return _box!;
  }

  /// Saves an order to the local store.
  Future<void> saveOrder(OrderEntity order) async {
    try {
      final box = await _getBox();
      final model = OrderModel.fromEntity(order);
      await box.add(model);
    } catch (e) {
      throw CacheException(message: 'Failed to save order: ${e.toString()}');
    }
  }

  /// Retrieves all orders from the local store.
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final box = await _getBox();
      // Return empty list if box is empty to avoid any state issues
      if (box.isEmpty) return [];
      return box.values.toList();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve orders: ${e.toString()}',
      );
    }
  }

  /// Clears all orders from the local store.
  Future<void> clearAllOrders() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear orders: ${e.toString()}');
    }
  }
}