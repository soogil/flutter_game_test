import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_library/flutter_library.dart';
import 'package:flutter_game_test/routes/routes/route_names.dart';
import 'package:flutter_game_test/routes/routes/route_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(const KpnpGameApp());
}


class KpnpGameApp extends StatelessWidget {
  const KpnpGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () => GetMaterialApp(
        initialRoute: RouteNames.select,
        debugShowCheckedModeBanner: false,
        getPages: RoutePages.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}