import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String phone;
  final String password;

  const RegisterEvent({
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [phone, password];
}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  const LoginEvent({required this.phone, required this.password});

  @override
  List<Object> get props => [phone, password];
}

class LogoutEvent extends AuthEvent {}
