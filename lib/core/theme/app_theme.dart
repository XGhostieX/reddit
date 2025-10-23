import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../utils/service_locator.dart';
import 'app_colors.dart';

enum ThemeMode { light, dark }

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode mode;
  final Ref ref;

  ThemeNotifier({this.mode = ThemeMode.dark, required this.ref}) : super(darkTheme) {
    getTheme();
  }

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.whiteColor,
    cardColor: AppColors.greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.blackColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.whiteColor),
    primaryColor: AppColors.redColor,
    // backgroundColor: AppColors.whiteColor,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.blackColor,
    cardColor: AppColors.greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.drawerColor,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.drawerColor),
    primaryColor: AppColors.redColor,
    colorScheme: const ColorScheme.dark(surface: AppColors.drawerColor),
  );

  void getTheme() async {
    final prefs = await ref.read(sharedPreferencesProvider);
    final theme = prefs.getString('theme');
    if (theme == 'light') {
      mode = ThemeMode.light;
      state = lightTheme;
    } else {
      mode = ThemeMode.dark;
      state = darkTheme;
    }
  }

  void toggleTheme() async {
    final prefs = await ref.read(sharedPreferencesProvider);
    if (mode == ThemeMode.dark) {
      mode = ThemeMode.light;
      state = lightTheme;
      prefs.setString('theme', 'light');
    } else {
      mode = ThemeMode.dark;
      state = darkTheme;
      prefs.setString('theme', 'dark');
    }
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(ref: ref),
);
