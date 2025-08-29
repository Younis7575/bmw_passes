import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = "".obs;
  var password = "".obs;

  void login() {
    // TODO: Replace with API or Firebase login logic
    Get.snackbar(
      "Login",
      "Email: ${email.value}, Password: ${password.value}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
