import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class GameLog {
  final DateTime date;
  final bool hasWon;
  final bool hasAbandon;
  
  GameLog({
    required this.date,
    required this.hasWon,
    required this.hasAbandon,
  });
  
  factory GameLog.fromJson(Map<String, dynamic> json) {
    try {
      tz_data.initializeTimeZones();
      final parsedUtcDate = DateTime.parse(json['date'] as String);
      final montrealLocation = tz.getLocation('America/Montreal');
      final montrealDateTime = tz.TZDateTime.from(parsedUtcDate, montrealLocation);
      
      return GameLog(
        date: DateTime(
          montrealDateTime.year,
          montrealDateTime.month,
          montrealDateTime.day,
          montrealDateTime.hour,
          montrealDateTime.minute,
          montrealDateTime.second,
        ),
        hasWon: json['hasWon'] as bool,
        hasAbandon: json['hasAbandon'] as bool,
      );
    } catch (e) {
      return GameLog(
        date: DateTime.parse(json['date'] as String),
        hasWon: json['hasWon'] as bool,
        hasAbandon: json['hasAbandon'] as bool,
      );
    }
  }
}