import '../../../../data/models/user_model.dart';
import '../services/auth_service.dart';

class RegisterUseCase {
  final AuthService _authService;

  RegisterUseCase(this._authService);

  Future<UserModel> execute(String name, String mobile) async {
    return await _authService.signup(name, mobile);
  }
}