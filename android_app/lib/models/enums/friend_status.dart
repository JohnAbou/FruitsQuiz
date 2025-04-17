enum FriendStatus {
  none(1),
  friend(2),
  receivedRequest(3),
  sentRequest(4),
  self(5);

  final int value;
  const FriendStatus(this.value);
}