import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
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
    // backgroundColor: AppColors.drawerColor,
  );
}
