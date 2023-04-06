import 'package:quickchat/constants/string_constants.dart';
import 'package:quickchat/helpers/shared_preferences_helper.dart';
import 'package:quickchat/localization/app_localization.dart';
import 'package:quickchat/localization/language_localization.dart';
import 'package:quickchat/pages/app_pages/home_page.dart';
import 'package:quickchat/providers/theme_provider.dart';
import 'package:quickchat/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings =
      await messaging.requestPermission(alert: true, announcement: true, badge: true, carPlay: false, criticalAlert: true, provisional: false, sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint("User granted permission");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint("User granted provisional permission");
  } else {
    debugPrint("User declined or has not accepted permission!");
  }
}

initInfo() {
  var androidInitialize = const AndroidInitializationSettings('@mipmap/launcher_icon');
  var iOSInitialize = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {}
      } catch (e) {
        debugPrint("initInfo Error: $e");
      }
      return;
    },
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "quickchat",
      "quickchat",
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.max,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const IOSNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, message.notification?.title, message.notification?.body, platformChannelSpecifics,
        payload: message.data['body']);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const riverpod.ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper(WidgetsBinding.instance.window.locale).getSettingsSharedPreferencesValues();
  }

  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => provider.ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: provider.Consumer<ThemeProvider>(builder: (context, ThemeProvider themeProvider, child) {
          if (count == 0) {
            themeProvider.toggleTheme();
            count++;
          }
          return MaterialApp(
            locale: _locale,
            supportedLocales: const [
              Locale("en", "US"),
              Locale("tr", "TR"),
            ],
            localizationsDelegates: const [
              Localization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.generateRoute,
            title: getTranslated(context, CommonKeys.appName),
            themeMode: themeProvider.themeMode,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: CustomBehavior(),
                child: child!,
              );
            },
            home: const HomePage(),
          );
        }),
      );
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
