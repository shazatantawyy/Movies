part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Movies> featured;
  final List<Movies> action;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.featured = const [],
    this.action = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Movies>? featured,
    List<Movies>? action,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      featured: featured ?? this.featured,
      action: action ?? this.action,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, featured, action, errorMessage];
}