import '../../../../data/models/user_model.dart';
import '../services/auth_service.dart';

class LoginUseCase {
  final AuthService _authService;

  LoginUseCase(this._authService);

  Future<UserModel> execute(String mobile) async {
    return await _authService.login(mobile);
  }
}