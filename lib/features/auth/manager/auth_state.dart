part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthFailed extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
