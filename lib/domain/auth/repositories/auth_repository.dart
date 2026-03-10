import 'package:dartz/dartz.dart';
import 'package:to_do_list/core/failures/failure.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthRepository {
  Future<Either<Failure, firebase_auth.User?>> getUser();
  Future<Either<Failure, Unit>> signUp(String email, String password);
  Future<Either<Failure, Unit>> logIn(String email, String password);
  Future<Either<Failure, Unit>> logOut();
  Future<Either<Failure, String?>> getToken();
  Stream<firebase_auth.User?> get authStateChanges;
}
