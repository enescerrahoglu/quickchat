import 'package:quickchat/pages/app_pages/home_page.dart';
import 'package:quickchat/pages/app_pages/indicator_page.dart';
import 'package:quickchat/pages/app_pages/navigation_page.dart';
import 'package:quickchat/pages/app_pages/profile_page.dart';
import 'package:quickchat/pages/app_pages/update_profile_page.dart';
import 'package:quickchat/pages/authentication_pages/email_page.dart';
import 'package:quickchat/pages/authentication_pages/login_page.dart';
import 'package:quickchat/pages/authentication_pages/register_page.dart';
import 'package:quickchat/pages/authentication_pages/update_password_page.dart';
import 'package:quickchat/pages/authentication_pages/verify_mail_code_page.dart';
import 'package:quickchat/pages/settings_pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quickchat/routes/route_constants.dart';

class RouteGenerator {
  static Route<dynamic> createRoute(Widget routeToGo, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // return MaterialPageRoute(builder: (_) => _RouteToGo, settings: settings); //android
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (c, a1, a2) => routeToGo,
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 100),
        reverseTransitionDuration: const Duration(milliseconds: 100),
      );
      // return PageRouteBuilder(
      //   pageBuilder: (context, animation, secondaryAnimation) => _RouteToGo,
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     const begin = Offset(0.0, 1.0);
      //     const end = Offset.zero;
      //     const curve = Curves.ease;

      //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      //     return SlideTransition(
      //       position: animation.drive(tween),
      //       child: child,
      //     );
      //   },
      // );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(builder: (_) => routeToGo, settings: settings); //ios
    } else {
      return CupertinoPageRoute(builder: (_) => routeToGo, settings: settings); //web
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPageRoute:
        return createRoute(const LoginPage(), settings);
      case registerPageRoute:
        return createRoute(const RegisterPage(), settings);
      case indicatorPageRoute:
        return createRoute(const IndicatorPage(), settings);
      case homePageRoute:
        return createRoute(const HomePage(), settings);
      case settingsPageRoute:
        return createRoute(const SettingsPage(), settings);
      case profilePageRoute:
        return createRoute(const ProfilePage(), settings);
      case updateProfilePageRoute:
        return createRoute(const UpdateProfilePage(), settings);
      case verifyMailCodePageRoute:
        return createRoute(const VerifyMailCodePage(), settings);
      case emailPageRoute:
        return createRoute(const EmailPage(), settings);
      case updatePasswordPageRoute:
        return createRoute(const UpdatePasswordPage(), settings);
      case navigationPageRoute:
        return createRoute(const NavigationPage(), settings);
      default:
        return createRoute(const LoginPage(), settings);
    }
  }
}
