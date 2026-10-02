import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/storage/user_storage.dart';
import 'package:movies/models/movies_model.dart';

class ProfileState extends Equatable {
  final String name;
  final int avatarIndex;
  final List<Movies> watchList;
  final List<Movies> history;

  const ProfileState({
    required this.name,
    required this.avatarIndex,
    required this.watchList,
    required this.history,
  });

  factory ProfileState.from(UserStorage s) => ProfileState(
    name: s.name,
    avatarIndex: s.avatarIndex,
    watchList: s.watchList,
    history: s.history,
  );

  @override
  List<Object?> get props => [name, avatarIndex, watchList, history];
}

class ProfileCubit extends Cubit<ProfileState> {
  final UserStorage _storage;

  ProfileCubit(this._storage) : super(ProfileState.from(_storage)) {
    _storage.addListener(_sync);
  }

  void _sync() => emit(ProfileState.from(_storage));

  @override
  Future<void> close() {
    _storage.removeListener(_sync);
    return super.close();
  }
}
