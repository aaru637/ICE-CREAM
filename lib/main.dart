import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ik/Home_Screens/Home_Page.dart';
import 'package:ik/Login_Screens/Login_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth/Login_Auth.dart';
import 'Templates/UserTemplate.dart';
import 'User_Provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();
  runApp(const Splash_Screen());
}

class Splash_Screen extends StatelessWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

dynamic checkLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (!preferences.containsKey("username")) {
    Get.off(() => const Login_Page(),
        transition: Transition.rightToLeftWithFade);
  } else {
    UserProvider.setUsername(preferences.getString("username")!);
    UserTemplate? user =
        await Login_Auth.getUser(preferences.getString("username")!);
    UserProvider.setUser(user!);
    Get.off(() => Home_Page(data: preferences.getString("username").toString()),
        transition: Transition.rightToLeftWithFade);
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 4,
              right: MediaQuery.of(context).size.width / 4,
              top: MediaQuery.of(context).size.height * 0.04,
            ),
            child: Center(
              child: Text(
                "ICE-CREAM",
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontFamily: "Georgia",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    overflow: TextOverflow.fade,
                    wordSpacing: 2.0,
                    shadows: const [
                      Shadow(
                        blurRadius: 50.0,
                        color: Colors.green,
                        offset: Offset(2.0, 2.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
