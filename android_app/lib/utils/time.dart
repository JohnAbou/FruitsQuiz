String formatTime(double seconds) {
  int totalSeconds = seconds.toInt();
  int hours = (totalSeconds ~/ 3600);
  int minutes = (totalSeconds % 3600) ~/ 60;
  int remainingSeconds = totalSeconds % 60;

  String time = '';
  if (hours > 0) time += '${hours}h';
  if (hours > 0 || minutes > 0) time += ' ${minutes}m';
  time += ' ${remainingSeconds}s';

  return time.trimLeft();
}
