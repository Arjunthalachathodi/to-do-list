import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:to_do_list/core/failures/failure.dart';
import 'package:to_do_list/domain/auth/repositories/auth_repository.dart';

@lazySingleton
class GetAuthStatus {
  final AuthRepository _repository;
  GetAuthStatus(this._repository);

  Stream<User?> call() => _repository.authStateChanges;
}

@lazySingleton
class LogIn {
  final AuthRepository _repository;
  LogIn(this._repository);

  Future<Either<Failure, Unit>> call(String email, String password) =>
      _repository.logIn(email, password);
}

@lazySingleton
class SignUp {
  final AuthRepository _repository;
  SignUp(this._repository);

  Future<Either<Failure, Unit>> call(String email, String password) =>
      _repository.signUp(email, password);
}

@lazySingleton
class LogOut {
  final AuthRepository _repository;
  LogOut(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.logOut();
}

@lazySingleton
class GetToken {
  final AuthRepository _repository;
  GetToken(this._repository);

  Future<Either<Failure, String?>> call() => _repository.getToken();
}
