import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color backgroundColor;
  final Color sidebarColor;
  final Color headerColor;
  final Color textColor;
  final Color boxColor;
  final Color accentColor;
  final Color accentText;
  final Color sidebarText;
  final Color sidebarBox;
  final Color chatBox;
  final Color chatListBackground;
  final Color chatListSelected;
  final Color chatHover;
  final Color chatInput;
  final Color sidebarButtonSelected;
  final Color gameCard;
  final Color scrollbarThumb;
  final Color scrollbarTrack;
  final Color buttonBox;
  final Color buttonText;
  final Color qcmBank;
  final Color qrlBank;
  final Color qreBank;
  final String logoUrl;
  final String backgroundUrl;
  final String siteName;
  final Color profileCardBorder;
  final Color profileAchievementBox;
  final Color profileTextColor;



  const CustomColors({
    required this.backgroundColor,
    required this.sidebarColor,
    required this.headerColor,
    required this.textColor,
    required this.boxColor,
    required this.accentColor,
    required this.accentText,
    required this.sidebarText,
    required this.sidebarBox,
    required this.chatBox,
    required this.chatListBackground,
    required this.chatListSelected,
    required this.chatHover,
    required this.chatInput,
    required this.sidebarButtonSelected,
    required this.gameCard,
    required this.scrollbarThumb,
    required this.scrollbarTrack,
    required this.buttonBox,
    required this.buttonText,
    required this.qcmBank,
    required this.qrlBank,
    required this.qreBank,
    required this.logoUrl,
    required this.backgroundUrl,
    required this.siteName,
    required this.profileCardBorder,
    required this.profileAchievementBox,
    required this.profileTextColor,
  });

  @override
  CustomColors copyWith({
    Color? backgroundColor,
    Color? sidebarColor,
    Color? headerColor,
    Color? textColor,
    Color? boxColor,
    Color? accentColor,
    Color? accentText,
    Color? sidebarText,
    Color? sidebarBox,
    Color? chatBox,
    Color? chatListBackground,
    Color? chatListSelected,
    Color? chatHover,
    Color? chatInput,
    Color? sidebarButtonSelected,
    Color? gameCard,
    Color? scrollbarThumb,
    Color? scrollbarTrack,
    Color? buttonBox,
    Color? buttonText,
    Color? qcmBank,
    Color? qrlBank,
    Color? qreBank,
    String? logoUrl,
    String? backgroundUrl,
    String? siteName,
    Color? profileCardBorder,
    Color? profileAchievementBox,
    Color? profileTextColor,
    
  }) {
    return CustomColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      sidebarColor: sidebarColor ?? this.sidebarColor,
      headerColor: headerColor ?? this.headerColor,
      textColor: textColor ?? this.textColor,
      boxColor: boxColor ?? this.boxColor,
      accentColor: accentColor ?? this.accentColor,
      accentText: accentText ?? this.accentText,
      sidebarText: sidebarText ?? this.sidebarText,
      sidebarBox: sidebarBox ?? this.sidebarBox,
      chatBox: chatBox ?? this.chatBox,
      chatListBackground: chatListBackground ?? this.chatListBackground,
      chatListSelected: chatListSelected ?? this.chatListSelected,
      chatHover: chatHover ?? this.chatHover,
      chatInput: chatInput ?? this.chatInput,
      sidebarButtonSelected: sidebarButtonSelected ?? this.sidebarButtonSelected,
      gameCard: gameCard ?? this.gameCard,
      scrollbarThumb: scrollbarThumb ?? this.scrollbarThumb,
      scrollbarTrack: scrollbarTrack ?? this.scrollbarTrack,
      buttonBox: buttonBox ?? this.buttonBox,
      buttonText: buttonText ?? this.buttonText,
      qcmBank: qcmBank ?? this.qcmBank,
      qrlBank: qrlBank ?? this.qrlBank,
      qreBank: qreBank ?? this.qreBank,
      logoUrl: logoUrl ?? this.logoUrl,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      siteName: siteName ?? this.siteName,
      profileCardBorder: profileCardBorder ?? this.profileCardBorder,
      profileAchievementBox: profileAchievementBox ?? this.profileAchievementBox,
      profileTextColor: profileTextColor ?? this.profileTextColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      sidebarColor: Color.lerp(sidebarColor, other.sidebarColor, t)!,
      headerColor: Color.lerp(headerColor, other.headerColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      boxColor: Color.lerp(boxColor, other.boxColor, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t)!,
      sidebarBox: Color.lerp(sidebarBox, other.sidebarBox, t)!,
      chatBox: Color.lerp(chatBox, other.chatBox, t)!,
      chatListBackground:
          Color.lerp(chatListBackground, other.chatListBackground, t)!,
      chatListSelected:
          Color.lerp(chatListSelected, other.chatListSelected, t)!,
      chatHover: Color.lerp(chatHover, other.chatHover, t)!,
      chatInput: Color.lerp(chatInput, other.chatInput, t)!,
      sidebarButtonSelected:
          Color.lerp(sidebarButtonSelected, other.sidebarButtonSelected, t)!,
      gameCard: Color.lerp(gameCard, other.gameCard, t)!,
      scrollbarThumb: Color.lerp(scrollbarThumb, other.scrollbarThumb, t)!,
      scrollbarTrack: Color.lerp(scrollbarTrack, other.scrollbarTrack, t)!,
      buttonBox: Color.lerp(buttonBox, other.buttonBox, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
      qcmBank: Color.lerp(qcmBank, other.qcmBank, t)!,
      qrlBank: Color.lerp(qrlBank, other.qrlBank, t)!,
      qreBank: Color.lerp(qreBank, other.qreBank, t)!,
      profileCardBorder: Color.lerp(profileCardBorder, other.profileCardBorder, t)!,
      profileAchievementBox: Color.lerp(profileAchievementBox, other.profileAchievementBox,t)!,
      profileTextColor: Color.lerp(profileTextColor, other.profileTextColor, t)!,
      logoUrl: t < 0.5 ? logoUrl : other.logoUrl,
      backgroundUrl: t < 0.5 ? backgroundUrl : other.backgroundUrl,
      siteName: t < 0.5 ? siteName : other.siteName,
    );
  }
}
