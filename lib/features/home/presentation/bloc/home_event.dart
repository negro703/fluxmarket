import 'package:equatable/equatable.dart';

/// Events that can be dispatched to the [HomeBloc].
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to fetch the list of products.
class FetchProductsEvent extends HomeEvent {
  const FetchProductsEvent();
}