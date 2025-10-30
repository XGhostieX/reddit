import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../utils/enums.dart';
import '../utils/service_locator.dart';
import 'app_colors.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode mode;
  final Ref ref;

  ThemeNotifier({this.mode = ThemeMode.dark, required this.ref}) : super(darkTheme) {
    getTheme();
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Reddit Sans',
    scaffoldBackgroundColor: AppColors.whiteColor,
    cardColor: AppColors.greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.blackColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xF5F5F5F5)),
    primaryColor: AppColors.redColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.blackColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: AppColors.whiteColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: AppColors.blackColor),
    ),
    // backgroundColor: AppColors.whiteColor,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Reddit Sans',
    scaffoldBackgroundColor: AppColors.blackColor,
    cardColor: AppColors.greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.drawerColor,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.drawerColor),
    primaryColor: AppColors.redColor,
    colorScheme: const ColorScheme.dark(surface: AppColors.drawerColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.whiteColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: AppColors.whiteColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: AppColors.whiteColor),
    ),
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
