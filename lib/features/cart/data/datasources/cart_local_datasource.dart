import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../models/cart_item_model.dart';

/// Local data source for cart persistence using Hive.
///
/// Stores cart items as [CartItemModel] objects in a Hive box,
/// providing persistent storage across app restarts.
@LazySingleton()
class CartLocalDataSource {
  static const String _boxName = 'cart_box';

  Box<CartItemModel>? _box;
  bool _initialized = false;

  CartLocalDataSource();

  /// Initializes the Hive box. Must be called before any other operation.
  Future<void> init() async {
    _box = await Hive.openBox<CartItemModel>(_boxName);
    _initialized = true;
  }

  /// Ensures the Hive box is open before any operation.
  Future<Box<CartItemModel>> _getBox() async {
    if (!_initialized) {
      _box = await Hive.openBox<CartItemModel>(_boxName);
      _initialized = true;
    }
    return _box!;
  }

  /// Saves the entire list of cart items, replacing existing data.
  Future<void> saveCartItems(List<CartItemEntity> items) async {
    try {
      final box = await _getBox();
      await box.clear();

      final models = items.map((item) {
        return CartItemModel.fromEntity(item);
      }).toList();

      for (var i = 0; i < models.length; i++) {
        await box.put(i.toString(), models[i]);
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to save cart items: ${e.toString()}',
      );
    }
  }

  /// Retrieves all cart items from the local store.
  ///
  /// Returns a list of [CartItemEntity] reconstructed from stored data.
  /// Must only be called after [init] has been executed.
  List<CartItemEntity> getCartItems() {
    if (!_initialized) {
      throw CacheException(
        message: 'Cart box not initialized. Call init() first.',
      );
    }
    final box = _box!;
    if (box.values.isEmpty) return [];

    return box.values.map((model) => model.toEntity()).toList();
  }

  /// Clears all items from the cart.
  Future<void> clearCart() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cart: ${e.toString()}');
    }
  }
}
