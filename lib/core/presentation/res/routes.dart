import 'package:firebasestarter/features/events/presentation/pages/add_event.dart';
import 'package:firebasestarter/features/events/presentation/pages/event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebasestarter/features/auth/presentation/pages/home.dart';
import 'package:firebasestarter/features/auth/presentation/pages/splash.dart';
import 'package:firebasestarter/features/auth/presentation/pages/user_info.dart';
import 'package:firebasestarter/features/profile/presentation/pages/edit_profile.dart';
import 'package:firebasestarter/features/profile/presentation/pages/profile.dart';

class AppRoutes {
  static const home = "/";
  static const splash = "splash";
  static const login = "login";
  static const signup = "signup";
  static const userInfo = "user_info";
  static const String profile = "profile";
  static const String editProfile = "edit_profile";
  static const String addEvent = "add_event";
  static const String editEvent = "edit_event";
  static const String viewEvent = "view_event";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (_) {
          switch (settings.name) {
            case editEvent:
              return AddEventPage(event: settings.arguments);
            case viewEvent:
              return EventDetails(event: settings.arguments);
            case addEvent:
              return AddEventPage(
                selectedDate: settings.arguments,
              );
            case home:
              return AuthHomePage();
            case userInfo:
              return UserInfoPage();
            case editProfile:
              return EditProfile(
                user: settings.arguments,
              );
            case profile:
              return UserProfile();
            case splash:
            default:
              return Splash();
          }
        });
  }
}
