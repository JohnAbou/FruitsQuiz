import 'package:android_app/widgets/friend_widgets/friend_requests.dart';
import 'package:android_app/widgets/friend_widgets/friends_list.dart';
import 'package:flutter/material.dart';

class PersonalProfileFriendsTab extends StatelessWidget {
  const PersonalProfileFriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: screenHeight * 0.8,
            width: screenWidth * 0.38,
            child: FriendsList(),
          ),
          SizedBox(
            height: screenHeight * 0.8,
            width: screenWidth * 0.38,
            child: FriendRequests(),
          ),
        ],
      ),
    );
  }
}
