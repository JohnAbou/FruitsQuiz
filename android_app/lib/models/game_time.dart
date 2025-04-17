class GameTimeUpdate {
  final double currentTime;
  final double addedTime;

  GameTimeUpdate({required this.currentTime, required this.addedTime});

  factory GameTimeUpdate.fromJson(Map<String, dynamic> json) {
    return GameTimeUpdate(
        currentTime: (json['currentTime'] is int) 
          ? (json['currentTime'] as int).toDouble() 
          : (json['currentTime'] as double),
        addedTime: (json['addedTime'] is int) 
          ? (json['addedTime'] as int).toDouble() 
          : (json['addedTime'] as double)
    );
  }
}
