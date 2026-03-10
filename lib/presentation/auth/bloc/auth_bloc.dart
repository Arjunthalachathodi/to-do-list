import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';
import 'package:to_do_list/domain/auth/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthStatus _getAuthStatus;
  final LogOut _logOut;

  AuthBloc(this._getAuthStatus, this._logOut) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
       await event.map(
        authCheckRequested: (e) async {
          await emit.forEach(
            _getAuthStatus(),
            onData: (user) => user != null
                ? AuthState.authenticated(user)
                : const AuthState.unauthenticated(),
          );
        },
        signedOut: (e) async {
          await _logOut();
          emit(const AuthState.unauthenticated());
        },
      );
    });
  }
}
