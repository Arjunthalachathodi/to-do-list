import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/domain/auth/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<Either<Failure, firebase_auth.User?>> getUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return right(user);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return left(Failure.authenticationFailure(e.message ?? 'Sign up failed'));
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> logIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return left(Failure.authenticationFailure(e.message ?? 'Log in failed'));
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(unit);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return right(null);
      final token = await user.getIdToken();
      return right(token);
    } catch (_) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
