part of 'authentication_bloc.dart';


class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final BSUser user;

  const AuthenticationState._({
    required this.status,
    this.user = BSUser.empty,
  });

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticated(BSUser user)
      : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
        );

  const AuthenticationState.guest() : this._(status: AuthenticationStatus.guest);

  @override
  List<Object?> get props => [status, user];
}
