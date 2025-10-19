import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../basic_features.dart';

class AppThemes {
  static appThemeData(String fontFamily) => {
    AppTheme.lightTheme: ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: ColorConst.whiteColor,
      brightness: Brightness.light,
      colorScheme: lightThemeColors(),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 20,
        backgroundColor: ColorConst.onBottomNavBackgroundLight,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorConst.primaryColor,
        unselectedItemColor: ColorConst.onSecondaryColorLight,
        selectedLabelStyle: fontStyleMedium10,
        unselectedLabelStyle: fontStyleMedium10,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConst.whiteColor,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      fontFamily: fontFamily,
      dividerColor: ColorConst.dividerColor,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: Dimensions.sp18,
          color: ColorConst.blackColor,
          fontWeight: FontAsset.regular,
        ),
        headlineMedium: TextStyle(
          fontSize: Dimensions.sp16,
          color: ColorConst.blackColor,
          fontWeight: FontAsset.regular,
        ),
        headlineSmall: TextStyle(
          fontSize: Dimensions.sp15,
          color: ColorConst.blackColor,
          fontWeight: FontAsset.regular,
        ),
        bodyLarge: TextStyle(
          fontSize: Dimensions.sp14,
          color: ColorConst.blackColor,
          fontWeight: FontAsset.regular,
        ),
        bodyMedium: TextStyle(
          fontSize: Dimensions.sp12,
          color: ColorConst.blackColor,
          fontWeight: FontAsset.regular,
        ),
        bodySmall: TextStyle(
          fontSize: Dimensions.sp10,
          color: ColorConst.blackColor,
          fontWeight: FontAsset.regular,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorConst.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimensions.r15,
          ), // Adjust the radius here
        ),
        elevation: 7,
        shadowColor: ColorConst.blackColor.withOpacity(0.3),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorConst.dividerColor,
        indent: 0,
        endIndent: 0,
        space: 0,
        thickness: 1.5,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
          // Set checkbox color based on its state
          if (states.contains(WidgetState.selected)) {
            return ColorConst.primaryColor; // Color when checkbox is selected
          }
          return Colors.white; // Default color
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: const BorderSide(color: ColorConst.blackColor),
        ),
      ),
    ),
    AppTheme.darkTheme: ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: ColorConst.blackColor,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 20,
        backgroundColor: ColorConst.onBottomNavBackgroundDark,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorConst.primaryContainerLight,
        unselectedItemColor: ColorConst.onSecondaryColorLight,
        selectedLabelStyle: fontStyleMedium10,
        unselectedLabelStyle: fontStyleMedium10,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConst.blackColor,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      dividerColor: ColorConst.dividerDarkColor,
      colorScheme: darkThemeColors(),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: Dimensions.sp18,
          color: ColorConst.whiteColor,
          fontWeight: FontAsset.regular,
        ),
        headlineMedium: TextStyle(
          fontSize: Dimensions.sp16,
          color: ColorConst.whiteColor,
          fontWeight: FontAsset.regular,
        ),
        headlineSmall: TextStyle(
          fontSize: Dimensions.sp15,
          color: ColorConst.whiteColor,
          fontWeight: FontAsset.regular,
        ),
        bodyLarge: TextStyle(
          fontSize: Dimensions.sp14,
          color: ColorConst.whiteColor,
          fontWeight: FontAsset.regular,
        ),
        bodyMedium: TextStyle(
          fontSize: Dimensions.sp12,
          color: ColorConst.whiteColor,
          fontWeight: FontAsset.regular,
        ),
        bodySmall: TextStyle(
          fontSize: Dimensions.sp10,
          color: ColorConst.whiteColor,
          fontWeight: FontAsset.regular,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorConst.darkCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimensions.r15,
          ), // Adjust the radius here
        ),
        elevation: 7,
      ),
      dividerTheme: const DividerThemeData(
        color: ColorConst.blackColor,
        indent: 0,
        endIndent: 0,
        space: 0,
        thickness: 1.5,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
          // Set checkbox color based on its state
          if (states.contains(WidgetState.selected)) {
            return ColorConst.primaryColor; // Color when checkbox is selected
          }
          return ColorConst.darkCardColor; // Default color
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: const BorderSide(color: ColorConst.whiteColor),
        ),
      ),
    ),
  };
}

enum AppTheme { lightTheme, darkTheme }

ColorScheme lightThemeColors() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: ColorConst.primaryColor,
    onPrimary: ColorConst.whiteColor,
    secondary: ColorConst.secondaryColor,
    onSecondary: ColorConst.onSecondaryColorLight,
    primaryContainer: ColorConst.whiteColor,
    onPrimaryContainer: ColorConst.whiteColor,
    error: Color(0xFFF32424),
    onError: Color(0xFFF32424),
    background: ColorConst.whiteColor,
    onBackground: ColorConst.primaryColorLight,
    surface: Color(0xFFf3f3f3),
    onSurface: Color(0xFFf3f3f3),
    outline: ColorConst.dashGreyLight,
    secondaryContainer: ColorConst.buttonGreyColor,
  );
}

ColorScheme darkThemeColors() {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: ColorConst.primaryColor,
    onPrimary: ColorConst.onPrimaryColorDark,
    primaryContainer: ColorConst.primaryContainerDark,
    onPrimaryContainer: ColorConst.onPrimaryContainerDark,
    secondary: ColorConst.secondaryColor,
    onSecondary: ColorConst.onSecondaryColorDark,
    error: Color(0xFFF32424),
    onError: Color(0xFFF32424),
    background: ColorConst.blackColor,
    onBackground: ColorConst.primaryColorDark,
    surface: Color(0xFF505050),
    onSurface: Color(0xFF505050),
    outline: ColorConst.dashGreyDark,
    secondaryContainer: ColorConst.darkCardColor,
  );
}
