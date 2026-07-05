import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'home_state.freezed.dart';

/// Possible states for the [HomeBloc].
@freezed
sealed class HomeState with _$HomeState {
  /// Initial state before any event has been processed.
  const factory HomeState.initial() = HomeInitial;

  /// State emitted while products are being fetched.
  const factory HomeState.loading() = HomeLoading;

  /// State emitted when products are loaded successfully.
  const factory HomeState.loaded({required List<ProductEntity> products}) =
      HomeLoaded;

  /// State emitted when an error occurs during fetching.
  const factory HomeState.error({required String message}) = HomeError;
}
