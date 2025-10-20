import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tontine_hub/repository/auth_repository.dart';
import 'auth_repository_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockGoTrueClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();

    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);

    // Injection du client mocké dans le repository
    authRepository = AuthRepository(supabaseClient: mockSupabaseClient);
  });

  group('AuthRepository', () {
    const testPhone = '+221771234567';
    const testPassword = 'password123';
    const testEmail = '$testPhone@tontinehub.app';

    test('register should call Supabase signUp with correct parameters', () async {
      // Arrange
      when(mockGoTrueClient.signUp(
        email: anyNamed('email'),
        password: anyNamed('password'),
        phone: anyNamed('phone'),
      )).thenAnswer((_) async => AuthResponse(session: null, user: User(id: '123', appMetadata: {}, userMetadata: {}, aud: '')));

      // Act
      await authRepository.register(phone: testPhone, password: testPassword);

      // Assert
      verify(mockGoTrueClient.signUp(
        email: testEmail,
        password: testPassword,
        phone: testPhone,
      )).called(1);
    });

    test('login should call Supabase signInWithPassword with correct parameters', () async {
      // Arrange
       when(mockGoTrueClient.signInWithPassword(
        phone: anyNamed('phone'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => AuthResponse(session: null, user: User(id: '123', appMetadata: {}, userMetadata: {}, aud: '')));

      // Act
      await authRepository.login(phone: testPhone, password: testPassword);

      // Assert
      verify(mockGoTrueClient.signInWithPassword(
        phone: testPhone,
        password: testPassword,
      )).called(1);
    });
  });
}
