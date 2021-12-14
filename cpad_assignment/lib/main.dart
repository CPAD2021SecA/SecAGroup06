import 'package:cpad_assignment/provider/members_provider.dart';
import 'package:cpad_assignment/provider/mom_provider.dart';
import 'package:cpad_assignment/provider/poll_provider.dart';
import 'package:cpad_assignment/ui/screens/splash_screen.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cpad_assignment/provider/concern_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await AppData.getInstance(); //init Shared Pref
    runApp(
      const MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MembersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MOMProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PollProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConcernProvider(),
        ),
      ],
      child: GetMaterialApp(
        title: 'CPAD Assignment',
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: BotToastInit(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
