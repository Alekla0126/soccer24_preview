import '../../repositories/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../extensions/enums.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import 'dart:async';



part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authRepository;

  StreamSubscription<BSUser>? _userSubscription;

  AuthenticationBloc(this._authRepository)
      : super(
          _authRepository.currentUser.isNotEmpty
              ? AuthenticationState.authenticated(_authRepository.currentUser)
              : const AuthenticationState.unauthenticated(),
        ) {
    _userSubscription?.cancel();
    _userSubscription = _authRepository.user.listen((user) => add(UserChangedEvent(user)));

    on<UserChangedEvent>(_onUserChanged);
  }

  void _onUserChanged(UserChangedEvent event, Emitter<AuthenticationState> emit) {
    emit(
      event.user.isNotEmpty
          ? AuthenticationState.authenticated(event.user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}