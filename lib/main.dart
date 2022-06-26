import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'state_managment/dark_mode_state_manager.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool darkMode = ref.watch(darkModeStateManagerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web for Slides',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xff333333),
        backgroundColor: Colors.white,
        shadowColor: const Color(0xff333333),
        cardColor: Colors.white,

        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        primaryColor: Colors.white,
        shadowColor: Colors.white24,
        cardColor: Colors.black45,

        /* dark theme settings */
      ),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreenView(
        navigateRoute: const MainScreen(),
        duration: 5000,
        imageSize: 130,
        imageSrc: "assets/images/view.png",
        text: "Accelerated Learning \n \n Flash Cards",
        textType: TextType.TyperAnimatedText,
        textStyle: GoogleFonts.robotoSlab(
          textStyle: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 50)),
        ),
        // backgroundColor: Colors.white,
      ),
    );
  }
}
