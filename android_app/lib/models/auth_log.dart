import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class AuthLog {
  final String userId;
  final DateTime loginTime;
  final DateTime? logoutTime;
  final String? deviceType;

  AuthLog({
    required this.userId,
    required this.loginTime,
    this.logoutTime,
    this.deviceType,
  });

  factory AuthLog.fromJson(Map<String, dynamic> json) {
    try {
      tz_data.initializeTimeZones();
      final montrealLocation = tz.getLocation('America/Montreal');
      
      // Convert loginTime
      final parsedLoginUtc = DateTime.parse(json['loginTime'] as String);
      final montrealLoginTime = tz.TZDateTime.from(parsedLoginUtc, montrealLocation);
      final convertedLoginTime = DateTime(
        montrealLoginTime.year,
        montrealLoginTime.month,
        montrealLoginTime.day,
        montrealLoginTime.hour,
        montrealLoginTime.minute,
        montrealLoginTime.second,
      );
      
      // Convert logoutTime if it exists
      DateTime? convertedLogoutTime;
      if (json['logoutTime'] != null) {
        final parsedLogoutUtc = DateTime.parse(json['logoutTime'] as String);
        final montrealLogoutTime = tz.TZDateTime.from(parsedLogoutUtc, montrealLocation);
        convertedLogoutTime = DateTime(
          montrealLogoutTime.year,
          montrealLogoutTime.month,
          montrealLogoutTime.day,
          montrealLogoutTime.hour,
          montrealLogoutTime.minute,
          montrealLogoutTime.second,
        );
      }
      
      return AuthLog(
        userId: json['userId'] as String,
        loginTime: convertedLoginTime,
        logoutTime: convertedLogoutTime,
        deviceType: json['deviceType'] as String?,
      );
    } catch (e) {
      return AuthLog(
        userId: json['userId'] as String,
        loginTime: DateTime.parse(json['loginTime'] as String),
        logoutTime: json['logoutTime'] != null 
            ? DateTime.parse(json['logoutTime'] as String) 
            : null,
        deviceType: json['deviceType'] as String?,
      );
    }
  }
}