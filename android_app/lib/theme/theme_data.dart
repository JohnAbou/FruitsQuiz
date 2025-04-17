import 'package:flutter/material.dart';
import 'custom_colors.dart';

class BackgroundData {
  final String backgroundUrl;
  final Color backgroundColor;

  BackgroundData({
    required this.backgroundUrl,
    required this.backgroundColor,
  });
}

BackgroundData getBackgroundData(String backgroundName, String themeName) {
  switch (backgroundName) {
    case 'lemon':
      return BackgroundData(
        backgroundUrl: "assets/images/lemonbackground.png",
        backgroundColor: const Color(0xFFDFFFDE),
      );
    case 'oranges':
      return BackgroundData(
        backgroundUrl: "assets/images/orangesbackground.png",
        backgroundColor: const Color(0xFFFFE9D6),
      );
    case 'strawberries':
      return BackgroundData(
        backgroundUrl: "assets/images/strawberrybackground.png",
        backgroundColor: const Color(0xFFFFD6DF),
      );
    case 'blueberries':
      return BackgroundData(
        backgroundUrl: "assets/images/blueberrybackground.png",
        backgroundColor: const Color(0xFFD6ECFF),
      );
    case 'watermelon':
      return BackgroundData(
        backgroundUrl: "assets/images/watermelonbackground.png",
        backgroundColor: const Color(0xFFE6F5E6),
      );
    case 'none':
    default:
      switch (themeName) {
        case 'lemon-theme':
          return BackgroundData(
            backgroundUrl: "",
            backgroundColor: const Color(0xFFDFFFDE),
          );
        case 'oranges-theme':
          return BackgroundData(
            backgroundUrl: "",
            backgroundColor: const Color(0xFFFFE9D6),
          );
        case 'strawberries-theme':
          return BackgroundData(
            backgroundUrl: "",
            backgroundColor: const Color(0xFFFFD6DF),
          );
        case 'blueberries-theme':
          return BackgroundData(
            backgroundUrl: "",
            backgroundColor: const Color(0xFFD6ECFF),
          );
        case 'watermelon-theme':
          return BackgroundData(
            backgroundUrl: "",
            backgroundColor: const Color(0xFFE6F5E6),
          );
        default:
          return BackgroundData(
            backgroundUrl: "",
            backgroundColor: Colors.white,
          );
      }
  }
}

ThemeData getThemeData(String theme, String background) {
  final backgroundData = getBackgroundData(background, theme);

  switch (theme) {
    case 'lemon-theme':
      return ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF009688),
          secondary: const Color(0xFFCDDC39),
          error: const Color(0xFF4CAF50),
          surface: backgroundData.backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundData.backgroundColor,
        textTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF009688),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            backgroundColor: backgroundData.backgroundColor,
            sidebarColor: const Color(0xFFA7E8A4),
            headerColor: const Color(0xFFD1EED0),
            textColor: const Color(0xFF467A45),
            boxColor: const Color(0xFFD1EED0),
            accentColor: const Color(0xFFCDDC39),
            accentText: const Color(0xFF009688),
            sidebarText: const Color(0xFF618A5E),
            sidebarBox: const Color(0xFFBADAB8),
            chatBox: const Color(0xFFBADAB8),
            chatListBackground: const Color(0xE17BA688),
            chatListSelected: const Color(0x698D74E1),
            chatHover: const Color(0xFFCDDC39),
            chatInput: backgroundData.backgroundColor,
            sidebarButtonSelected: const Color(0xFFA2D39E),
            gameCard: const Color(0xFFD1EED0),
            scrollbarThumb: const Color(0xFF009688),
            scrollbarTrack: const Color(0xFF2F2F2F),
            buttonBox: const Color(0xFF009688),
            buttonText: Colors.white,
            qcmBank: const Color(0xFFC0F3D8),
            qrlBank: const Color(0xFF8FD8B7),
            qreBank: const Color(0xff8adaa6e3),
            profileCardBorder: Color(0xFF618A5E),
            profileAchievementBox: Color(0xFFA2C794),
            profileTextColor: Color(0xFF618A5E),
            logoUrl: "assets/images/logo.png",
            backgroundUrl: backgroundData.backgroundUrl,
            siteName: "FRUITS QUIZ",
          ),
        ],
      );
    // ... (the rest of your theme cases remain unchanged, using backgroundData.backgroundColor and backgroundData.backgroundUrl)
    case 'oranges-theme':
      return ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFB8C00),
          secondary: const Color(0xFFFF9800),
          error: const Color(0xFFFF5722),
          surface: backgroundData.backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundData.backgroundColor,
        textTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFFFCC80),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            backgroundColor: backgroundData.backgroundColor,
            sidebarColor: const Color(0xFFF4CAAF),
            headerColor: const Color(0xFFF2C69F),
            textColor: const Color(0xFFA56324),
            boxColor: const Color(0xFFF2C69F),
            accentColor: const Color(0xFFFF9800),
            accentText: const Color(0xFFFF9800),
            sidebarText: const Color(0xFFA56324),
            sidebarBox: const Color(0xFFF4CAAF),
            chatBox: const Color(0xFFF4CAAF),
            chatListBackground: const Color(0xFFFFCC80),
            chatListSelected: const Color(0xE6B16AE1),
            chatHover: const Color(0xFFFF9800),
            chatInput: backgroundData.backgroundColor,
            sidebarButtonSelected: const Color(0xFFE1997A),
            gameCard: const Color(0xFFF2C69F),
            scrollbarThumb: const Color(0xFFFF9800),
            scrollbarTrack: const Color(0xFF2F2F2F),
            buttonBox: const Color(0xFFFFCC80),
            buttonText: Colors.black,
            qcmBank: const Color(0xffff965c96),
            qrlBank: const Color(0xFFFF9B76),
            qreBank: Color.fromRGBO(255, 177, 120, 0.89),
            profileCardBorder: const Color(0xFFA56324),
            profileAchievementBox: const Color(0xFFDCC1A0),
            profileTextColor: const Color(0xFFA56324),
            logoUrl: "assets/images/orangeslogo.png",
            backgroundUrl: backgroundData.backgroundUrl,
            siteName: "FRUITS QUIZ",
          ),
        ],
      );
    // Repeat similar updates for the rest of your themes:
    // 'strawberries-theme', 'blueberries-theme', 'watermelon-theme'
    case 'strawberries-theme':
      return ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFF44336),
          secondary: const Color(0xFFEF5350),
          error: const Color(0xFFD32F2F),
          surface: backgroundData.backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundData.backgroundColor,
        textTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFFFCDD2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            backgroundColor: backgroundData.backgroundColor,
            sidebarColor: const Color(0xFFF4AFC5),
            headerColor: const Color(0xFFF6BBCF),
            textColor: const Color(0xFFA5245C),
            boxColor: const Color(0xFFF6BBCF),
            accentColor: const Color(0xFFEF5350),
            accentText: const Color(0xFFEF5350),
            sidebarText: const Color(0xFFA5245C),
            sidebarBox: const Color(0xFFF4AFC5),
            chatBox: const Color(0xFFF4AFC5),
            chatListBackground: const Color(0xFFFFCDD2),
            chatListSelected: const Color(0xE699A0E1),
            chatHover: const Color(0xFFEF5350),
            chatInput: backgroundData.backgroundColor,
            sidebarButtonSelected: const Color(0xFFE17AA7),
            gameCard: const Color(0xFFF6BBCF),
            scrollbarThumb: const Color(0xFFEF5350),
            scrollbarTrack: const Color(0xFF2F2F2F),
            buttonBox: const Color(0xFFFFCDD2),
            buttonText: Colors.black,
            qcmBank: const Color(0xffff5c6d96),
            qrlBank: const Color(0xfff54f4fa1),
            qreBank: Color.fromRGBO(255, 161, 175, 0.89),
            profileCardBorder: const Color(0xFFA5245C),
            profileAchievementBox: const Color(0xFFDCA7A0),
            profileTextColor: const Color(0xFFA5245C),
            logoUrl: "assets/images/strawberrylogo.png",
            backgroundUrl: backgroundData.backgroundUrl,
            siteName: "FRUITS QUIZ",
          ),
        ],
      );
    case 'blueberries-theme':
      return ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2196F3),
          secondary: const Color(0xFF42A5F5),
          error: const Color(0xFF607D8B),
          surface: backgroundData.backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundData.backgroundColor,
        textTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFBBDEFB),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            backgroundColor: backgroundData.backgroundColor,
            sidebarColor: const Color(0xFFAFD0F4),
            headerColor: const Color(0xFFBBD2F6),
            textColor: const Color(0xFF243EA5),
            boxColor: const Color(0xFFBBD2F6),
            accentColor: const Color(0xFF42A5F5),
            accentText: const Color(0xFF42A5F5),
            sidebarText: const Color(0xFF243EA5),
            sidebarBox: const Color(0xFFAFD0F4),
            chatBox: const Color(0xFFAFD0F4),
            chatListBackground: const Color(0xFFBBDEFB),
            chatListSelected: const Color(0x90BCE0E1),
            chatHover: const Color(0xFF42A5F5),
            chatInput: backgroundData.backgroundColor,
            sidebarButtonSelected: const Color(0xFF7AB3E1),
            gameCard: const Color(0xFFBBD2F6),
            scrollbarThumb: const Color(0xFF42A5F5),
            scrollbarTrack: const Color(0xFF2F2F2F),
            buttonBox: const Color(0xFFBBDEFB),
            buttonText: Colors.black,
            qcmBank: const Color(0xffa69ef396),
            qrlBank: const Color(0xff6d5ff1a1),
            qreBank: Color.fromRGBO(161, 169, 255, 0.89),
            profileCardBorder: const Color(0xFF243EA5),
            profileAchievementBox: const Color(0xFFA0C4DC),
            profileTextColor: const Color(0xFF243EA5),
            logoUrl: "assets/images/blueberrylogo1.png",
            backgroundUrl: backgroundData.backgroundUrl,
            siteName: "FRUITS QUIZ",
          ),
        ],
      );
    case 'watermelon-theme':
      return ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF3F9142),
          secondary: const Color(0xFFFF7676),
          error: Colors.red,
          surface: backgroundData.backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundData.backgroundColor,
        textTheme: const TextTheme().apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFC1EAC5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            backgroundColor: backgroundData.backgroundColor,
            sidebarColor: const Color(0xFFC2E0C2),
            headerColor: const Color(0xFFB3D9B3),
            textColor: const Color(0xFF2F4F2F),
            boxColor: const Color(0xFFB3D9B3),
            accentColor: const Color(0xFFFF7676),
            accentText: const Color(0xFFFF7676),
            sidebarText: const Color(0xFF2F4F2F),
            sidebarBox: const Color(0xFFD0EAD0),
            chatBox: const Color(0xFFD0EAD0),
            chatListBackground: const Color(0xFFFFCFCF),
            chatListSelected: const Color(0xFFFFB6B6),
            chatHover: const Color(0xFFFF9D9D),
            chatInput: backgroundData.backgroundColor,
            sidebarButtonSelected: const Color(0xFFA8D3A8),
            gameCard: const Color(0xFFB3D9B3),
            scrollbarThumb: const Color(0xFF3F9142),
            scrollbarTrack: const Color(0xFF2F2F2F),
            buttonBox: const Color(0xFFFF7676),
            buttonText: Colors.white,
            qcmBank: const Color(0xFFD0F0C0),
            qrlBank: const Color(0xFFF5C6CB),
            qreBank: Color.fromRGBO(255, 200, 200, 0.89),
            profileCardBorder: const Color(0xFF2F4F2F),
            profileAchievementBox: const Color(0xFFA0C4DC),
            profileTextColor: const Color(0xFF2F4F2F),
            logoUrl: "assets/images/watermelonlogo.png",
            backgroundUrl: backgroundData.backgroundUrl,
            siteName: "FRUITS QUIZ",
          ),
        ],
      );
    default:
      return getThemeData('lemon-theme', background);
  }
}
