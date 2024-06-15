import '../entities/auth_entity.dart';

abstract class AbstractAuthService {
  Future<AuthEntity?> login(String username, String password);
  Future<AuthEntity?> changePassword(AuthEntity authEntity, String oldPassword,  String newPassword);
  Future<AuthEntity?> getMe();
  Future<void> logout();
  String hashPasswordWithSha256(String password);
}