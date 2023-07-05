import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_literacy_app/screens/splash.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:provider/provider.dart';

// void main() {
//   // FlutterError.onError = (details) {
//   //   print(details);
//   //   // FlutterError.presentError(details);
//   //   // if (kReleaseMode) exit(1);
//   // };
//   runApp(const MediaLiteracyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MediaLiteracyApp());
}

class MediaLiteracyApp extends StatelessWidget {
  const MediaLiteracyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
