import 'package:android_app/generated/l10n.dart';

final Map<int, String> _messages = {
  10000: S.current.game_joining_no_game_found,
  10001: S.current.game_joining_invalid_game_id,
  10002: S.current.game_joining_game_already_started,
  10005: S.current.game_joining_lobby_locked,
  10010: S.current.game_joining_banned_user,
  10015: S.current.game_joining_friends_only,
  10016: S.current.game_joining_not_enough_coins,

  21000:S.current.kicked_out_message_organizer_left,
  21005:S.current.kicked_out_message_no_players_left,
  21010:S.current.kicked_out_message_banned,
};

String getTranslatedMessage(int code) {
  final message = _messages[code];

  if (message == null) {
    throw Exception("Unknown message code: $code");
  }

  return message;
}

//Ik its disgusting but whatever we won't touch it ever again
String getTranslatedMessageWithValues(int code, Map<String, dynamic> values) {

  if (code == 20000) {
    return S.current.game_message_correction_with_bonus(values["score"]);
  } else if (code == 20005) {
    return S.current.game_message_correction_without_bonus(values["score"]);
  } else if (code == 20010) {
    return S.current.game_message_correction_with_percentage(values["percent"], values["points"]);
  } else {
    throw Exception("Invalid message function for code: $code");
  }
}