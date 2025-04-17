enum BotAvatarType {
  lemon,
  orange,
  apple,
  grape,
}

extension BotAvatarTypeExtension on BotAvatarType {
  String get name {
    return toString().split('.').last;
  }

  static BotAvatarType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'lemon':
        return BotAvatarType.lemon;
      case 'orange':
        return BotAvatarType.orange;
      case 'apple':
        return BotAvatarType.apple;
      case 'grape':
        return BotAvatarType.grape;
      default:
        throw ArgumentError('Invalid BotAvatarType: $value');
    }
  }
}
