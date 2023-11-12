import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:trungtamgiasu/services/firebase_api.dart';
import 'controllers/route_manager.dart';
import 'firebase_options.dart';
import 'services/get_current_user.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final updatedUser = await getUserInfo(loggedInUser);
  if (updatedUser.uid == "1hTWuEYv9nYt3GLomYkrNrn79ny2") {
    await FirebaseApi().unsubscribeToTopic();
  } else {
    await FirebaseApi().initNotifications();
  }

  supportedLocales:
  [const Locale('en'), const Locale('fr')];
  await initializeDateFormatting('vi_VN', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', ''),// arabic, no country code
      ],
      builder: EasyLoading.init(),
      initialRoute: RouteManager.splashScreen,
      onGenerateRoute: RouteManager.generateRoute,
      navigatorKey: Get.key,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
