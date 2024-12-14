
part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class UserChangedEvent extends AuthenticationEvent {
  const UserChangedEvent(this.user);

  final BSUser user;

  @override
  List<Object> get props => [user];
}