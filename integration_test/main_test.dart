import 'package:integration_test/integration_test.dart';
import 'reset_password_test.dart' as reset_password;
import 'login_test.dart' as login;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  reset_password.test();
  login.test();
}