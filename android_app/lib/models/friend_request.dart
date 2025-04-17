class FriendRequest {
  final String id;
  final String senderUsername;
  final String receiverUsername;
  bool seen;

  FriendRequest({
    required this.id,
    required this.senderUsername,
    required this.receiverUsername,
    this.seen = false,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'],
      senderUsername: json['senderUsername'],
      receiverUsername: json['receiverUsername'],
      seen: json['seen'] ?? false,
    );
  }
}
