import 'Templates/UserTemplate.dart';

class UserProvider {
  static String username = "";
  static UserTemplate? user;

  static void setUsername(String username) {
    UserProvider.username = username;
  }

  static String getusername() {
    return username;
  }

  static setUser(UserTemplate user1) {
    user = user1;
  }

  static UserTemplate? getUser() {
    print('${user!.id} from UserProvider');
    return user;
  }
}
