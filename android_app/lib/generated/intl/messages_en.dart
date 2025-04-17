// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(price) => "Price: ${price} coins";

  static String m1(questionType) =>
      "To complete this challenge, you need to answer correctly every ${questionType}.";

  static String m2(questionType) =>
      "You didn\'t answer all ${questionType} correctly.";

  static String m3(questionType) =>
      "Excellent! You answered all ${questionType} correctly!";

  static String m4(status) => "Status: ${status}";

  static String m5(username) =>
      "This chatroom is restricted to friends of ${username}";

  static String m6(chatName) =>
      "Do you really want to delete the chatroom \'${chatName}\' ?";

  static String m7(chatName) =>
      "Do you really want to leave the chatroom \'${chatName}\' ?";

  static String m8(count) => "${count} New Friend Requests";

  static String m9(username) => "New friend request from ${username}";

  static String m10(username) => "${username} accepted your friend request";

  static String m11(count) => "You can\'t select more than ${count} questions";

  static String m12(amount) =>
      "You need to pay ${amount} coins to join this game";

  static String m13(price) => "You won the game pot of ${price} coins!";

  static String m14(score) =>
      "You obtained ${score} points thanks to the bonus";

  static String m15(percent, points) =>
      "You obtained ${percent}% which is ${points} points";

  static String m16(score) => "You obtained ${score} points";

  static String m17(price) => "Buy a Hint : ${price} coins";

  static String m18(value) => "The correct answer is: ${value}";

  static String m19(value, tolerance) =>
      "The correct answer is: ${value} ± ${tolerance}";

  static String m20(value) => "${value}";

  static String m21(value) => "${value}";

  static String m22(count) => "Contains ${count} questions";

  static String m23(description) => "Description: ${description}";

  static String m24(duration) => "Time to answer: ${duration}s";

  static String m25(date) => "Last modification: ${date}";

  static String m26(owner) => "Creator: ${owner}";

  static String m27(count) => "Number of questions: ${count}";

  static String m28(title) => "Title: ${title}";

  static String m29(count) => "You selected ${count} questions";

  static String m30(totalQuestions) =>
      "Contains 5 to ${totalQuestions} questions";

  static String m31(questionSurvived, questionCount) =>
      "You survived the first ${questionSurvived} questions out of ${questionCount}";

  static String m32(username) => "${username} has joined";

  static String m33(username) => "${username} has left";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AccountValidation_alreadyLoggedIn": MessageLookupByLibrary.simpleMessage(
      "This account is already logged in",
    ),
    "AccountValidation_avatarRequired": MessageLookupByLibrary.simpleMessage(
      "Please select an avatar",
    ),
    "AccountValidation_emailInvalid": MessageLookupByLibrary.simpleMessage(
      "The email must follow the format example@domain.com",
    ),
    "AccountValidation_emailRequired": MessageLookupByLibrary.simpleMessage(
      "Email is required",
    ),
    "AccountValidation_emailTaken": MessageLookupByLibrary.simpleMessage(
      "This email address is already in use",
    ),
    "AccountValidation_incorrectCredentials":
        MessageLookupByLibrary.simpleMessage("Incorrect username or password"),
    "AccountValidation_missingFields": MessageLookupByLibrary.simpleMessage(
      "Username and password are required",
    ),
    "AccountValidation_passwordInvalid": MessageLookupByLibrary.simpleMessage(
      "The password can only contain letters, numbers, and special characters",
    ),
    "AccountValidation_passwordLength": MessageLookupByLibrary.simpleMessage(
      "The password must be at least 5 characters",
    ),
    "AccountValidation_passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "The passwords do not match",
    ),
    "AccountValidation_passwordRequired": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "AccountValidation_termsRequired": MessageLookupByLibrary.simpleMessage(
      "Please accept the terms and conditions",
    ),
    "AccountValidation_unknownError": MessageLookupByLibrary.simpleMessage(
      "An unknown error occurred",
    ),
    "AccountValidation_updateError": MessageLookupByLibrary.simpleMessage(
      "Failed to update username",
    ),
    "AccountValidation_usernameExists": MessageLookupByLibrary.simpleMessage(
      "The username is already taken",
    ),
    "AccountValidation_usernameInvalid": MessageLookupByLibrary.simpleMessage(
      "The username is invalid. It can only contain letters, numbers, and underscores",
    ),
    "AccountValidation_usernameLength": MessageLookupByLibrary.simpleMessage(
      "The username must be between 4 and 12 characters",
    ),
    "AccountValidation_usernameRequired": MessageLookupByLibrary.simpleMessage(
      "Username is required",
    ),
    "AccountValidation_usernameSystem": MessageLookupByLibrary.simpleMessage(
      "The username cannot contain system reserved words",
    ),
    "AccountValidation_usernameTaken": MessageLookupByLibrary.simpleMessage(
      "This username is already taken",
    ),
    "Camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "HomeCarousel_BestSurvivalScore": MessageLookupByLibrary.simpleMessage(
      "Best Survival Score",
    ),
    "HomeCarousel_BestWinStreak": MessageLookupByLibrary.simpleMessage(
      "Best Win Streak",
    ),
    "HomeCarousel_HighestCurrentWinStreak":
        MessageLookupByLibrary.simpleMessage("Highest Current Win Streak"),
    "HomeCarousel_LongestGameTime": MessageLookupByLibrary.simpleMessage(
      "Longest Game Time",
    ),
    "HomeCarousel_MostCoinsSpent": MessageLookupByLibrary.simpleMessage(
      "Most Coins Spent",
    ),
    "HomeCarousel_MostPoints": MessageLookupByLibrary.simpleMessage(
      "Most Points",
    ),
    "HomeCarousel_MostWins": MessageLookupByLibrary.simpleMessage("Most Wins"),
    "HomeCarousel_NoDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No data available",
    ),
    "Or": MessageLookupByLibrary.simpleMessage("OR"),
    "Upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "XP": MessageLookupByLibrary.simpleMessage("EXP"),
    "achievements": MessageLookupByLibrary.simpleMessage("Achievements"),
    "add_bot": MessageLookupByLibrary.simpleMessage("Add Bot"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
    "background": MessageLookupByLibrary.simpleMessage("Background"),
    "best_streak": MessageLookupByLibrary.simpleMessage("Best Streak"),
    "blueberry_background": MessageLookupByLibrary.simpleMessage(
      "Blueberry Background",
    ),
    "blueberry_theme": MessageLookupByLibrary.simpleMessage("Blueberry Theme"),
    "bot_difficulty_beginner": MessageLookupByLibrary.simpleMessage("Beginner"),
    "bot_difficulty_expert": MessageLookupByLibrary.simpleMessage("Expert"),
    "bot_difficulty_intermediate": MessageLookupByLibrary.simpleMessage(
      "Intermediate",
    ),
    "bought": MessageLookupByLibrary.simpleMessage("Bought"),
    "buy": MessageLookupByLibrary.simpleMessage("Buy"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "challenge_answer_streak_description": MessageLookupByLibrary.simpleMessage(
      "To complete this challenge, you need to answer 3 questions correctly in a row.",
    ),
    "challenge_answer_streak_failure": MessageLookupByLibrary.simpleMessage(
      "You didn\'t manage to answer 3 questions correctly in a row.",
    ),
    "challenge_answer_streak_success": MessageLookupByLibrary.simpleMessage(
      "Congratulations! You answered 3 questions correctly in a row!",
    ),
    "challenge_answer_streak_title": MessageLookupByLibrary.simpleMessage(
      "Answer Streak Challenge",
    ),
    "challenge_bonus_collector_description": MessageLookupByLibrary.simpleMessage(
      "To complete this challenge, you need to get at least half of the possible bonus in this game.",
    ),
    "challenge_bonus_collector_failure": MessageLookupByLibrary.simpleMessage(
      "You didn\'t collect enough bonuses to complete the challenge.",
    ),
    "challenge_bonus_collector_success": MessageLookupByLibrary.simpleMessage(
      "Great job! You collected more than half of the possible bonuses!",
    ),
    "challenge_bonus_collector_title": MessageLookupByLibrary.simpleMessage(
      "Bonus Collector Challenge",
    ),
    "challenge_fastest_description": MessageLookupByLibrary.simpleMessage(
      "To complete this challenge, your average answer time must be under 5 seconds.",
    ),
    "challenge_fastest_failure": MessageLookupByLibrary.simpleMessage(
      "Your average response time was above 5 seconds.",
    ),
    "challenge_fastest_success": MessageLookupByLibrary.simpleMessage(
      "Amazing! Your average response time was under 5 seconds!",
    ),
    "challenge_fastest_title": MessageLookupByLibrary.simpleMessage(
      "Fastest Challenge",
    ),
    "challenge_never_last_description": MessageLookupByLibrary.simpleMessage(
      "To complete this challenge, you need to never be the last player to answer a question.",
    ),
    "challenge_never_last_failure": MessageLookupByLibrary.simpleMessage(
      "You were the last to answer at least once.",
    ),
    "challenge_never_last_success": MessageLookupByLibrary.simpleMessage(
      "Perfect! You were never the last to answer!",
    ),
    "challenge_never_last_title": MessageLookupByLibrary.simpleMessage(
      "Never Last Challenge",
    ),
    "challenge_price": m0,
    "challenge_question_master_description": m1,
    "challenge_question_master_failure": m2,
    "challenge_question_master_success": m3,
    "challenge_question_master_title": MessageLookupByLibrary.simpleMessage(
      "Question Master Challenge",
    ),
    "challenge_status": m4,
    "change_avatar": MessageLookupByLibrary.simpleMessage("Change your avatar"),
    "chat_banned_service_added": MessageLookupByLibrary.simpleMessage(
      "granted",
    ),
    "chat_banned_service_chat_right": MessageLookupByLibrary.simpleMessage(
      "your right to use the chat of the game.",
    ),
    "chat_banned_service_organizer": MessageLookupByLibrary.simpleMessage(
      "The organizer has",
    ),
    "chat_banned_service_removed": MessageLookupByLibrary.simpleMessage(
      "removed",
    ),
    "chat_friend_only_response": m5,
    "chat_name_empty_error": MessageLookupByLibrary.simpleMessage(
      "The chatroom name cannot be empty.",
    ),
    "chat_name_placeholder": MessageLookupByLibrary.simpleMessage(
      "Chatroom name",
    ),
    "chat_name_restricted_error": MessageLookupByLibrary.simpleMessage(
      "This chatroom name is restricted.",
    ),
    "chat_name_taken_error": MessageLookupByLibrary.simpleMessage(
      "This chatroom name is already taken.",
    ),
    "chatrooms": MessageLookupByLibrary.simpleMessage("chatrooms"),
    "choose_avatar": MessageLookupByLibrary.simpleMessage("Choose an Avatar"),
    "choose_number_header": MessageLookupByLibrary.simpleMessage(
      "Use the controls below to adjust the number of questions for your game",
    ),
    "coins": MessageLookupByLibrary.simpleMessage("coins"),
    "coins_spent": MessageLookupByLibrary.simpleMessage("Coins Spent"),
    "confirm_delete_chat": m6,
    "confirm_leave_chat": m7,
    "confirm_password_label": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "continue_game": MessageLookupByLibrary.simpleMessage("Next"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "create_account": MessageLookupByLibrary.simpleMessage("Create one"),
    "create_chatroom": MessageLookupByLibrary.simpleMessage(
      "Create a chatroom",
    ),
    "current_level": MessageLookupByLibrary.simpleMessage("Level"),
    "current_streak": MessageLookupByLibrary.simpleMessage("Current Streak"),
    "delete_chat_title": MessageLookupByLibrary.simpleMessage(
      "Delete a Chatroom",
    ),
    "elimination_modal": MessageLookupByLibrary.simpleMessage("Eliminated"),
    "elimination_modal_title": MessageLookupByLibrary.simpleMessage(
      "Eliminated!",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email address"),
    "email_label": MessageLookupByLibrary.simpleMessage("Email"),
    "enter_answer": MessageLookupByLibrary.simpleMessage("Enter your answer"),
    "enter_game_code": MessageLookupByLibrary.simpleMessage(
      "Enter the game code: ",
    ),
    "error_avatar": MessageLookupByLibrary.simpleMessage(
      "You have to choose an avatar to continue.",
    ),
    "error_email_invalid": MessageLookupByLibrary.simpleMessage(
      "The email must follow the format example@domain.com",
    ),
    "error_email_required": MessageLookupByLibrary.simpleMessage(
      "Email is required",
    ),
    "error_icon_label": MessageLookupByLibrary.simpleMessage("Error"),
    "error_joining_game": MessageLookupByLibrary.simpleMessage(
      "Error joining the game",
    ),
    "error_password_invalid": MessageLookupByLibrary.simpleMessage(
      "The password can only contain letters, numbers, and special characters",
    ),
    "error_password_length": MessageLookupByLibrary.simpleMessage(
      "The password must be at least 5 characters",
    ),
    "error_password_required": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "error_username_invalid": MessageLookupByLibrary.simpleMessage(
      "The username is invalid. It can only contain letters, numbers, and underscores",
    ),
    "error_username_length": MessageLookupByLibrary.simpleMessage(
      "The username must be between 4 and 12 characters",
    ),
    "error_username_required": MessageLookupByLibrary.simpleMessage(
      "The username is required",
    ),
    "error_username_system": MessageLookupByLibrary.simpleMessage(
      "The username cannot contain system reserved words",
    ),
    "experience": MessageLookupByLibrary.simpleMessage("XP"),
    "filter_placeholder": MessageLookupByLibrary.simpleMessage("Filter"),
    "friend_page": MessageLookupByLibrary.simpleMessage("Friends"),
    "friend_request_control_accept": MessageLookupByLibrary.simpleMessage(
      "Accept",
    ),
    "friend_request_control_add_friend": MessageLookupByLibrary.simpleMessage(
      "Add friend",
    ),
    "friend_request_control_add_yourself_error":
        MessageLookupByLibrary.simpleMessage("Can\'t add yourself as a friend"),
    "friend_request_control_delete_friend":
        MessageLookupByLibrary.simpleMessage("Delete Friend"),
    "friend_request_control_delete_request":
        MessageLookupByLibrary.simpleMessage("Delete request"),
    "friend_request_control_friend": MessageLookupByLibrary.simpleMessage(
      "Friend",
    ),
    "friend_request_control_receive_request":
        MessageLookupByLibrary.simpleMessage("Received a request"),
    "friend_request_control_refuse": MessageLookupByLibrary.simpleMessage(
      "Refuse",
    ),
    "friend_request_control_send_request": MessageLookupByLibrary.simpleMessage(
      "Sent a request",
    ),
    "friend_request_tooltips_accept_request":
        MessageLookupByLibrary.simpleMessage("Accept request"),
    "friend_request_tooltips_decline_request":
        MessageLookupByLibrary.simpleMessage("Decline request"),
    "friend_request_tooltips_revoke_request":
        MessageLookupByLibrary.simpleMessage("Revoke request"),
    "friend_request_tooltips_send_request":
        MessageLookupByLibrary.simpleMessage("Send friend request"),
    "friend_requests_add_friend": MessageLookupByLibrary.simpleMessage(
      "Add friend",
    ),
    "friend_requests_answer_request": MessageLookupByLibrary.simpleMessage(
      "Answer received request",
    ),
    "friend_requests_multiple_requests": m8,
    "friend_requests_new_request_from": m9,
    "friend_requests_no_received_requests":
        MessageLookupByLibrary.simpleMessage(
          "You don\'t have any pending friend requests.",
        ),
    "friend_requests_no_sent_requests": MessageLookupByLibrary.simpleMessage(
      "You haven\'t sent any friend requests yet.",
    ),
    "friend_requests_received_requests": MessageLookupByLibrary.simpleMessage(
      "Received Requests",
    ),
    "friend_requests_request_accepted": m10,
    "friend_requests_revoke_sent_request": MessageLookupByLibrary.simpleMessage(
      "Revoke sent request",
    ),
    "friend_requests_sent_requests": MessageLookupByLibrary.simpleMessage(
      "Sent Requests",
    ),
    "friend_requests_title": MessageLookupByLibrary.simpleMessage(
      "Friend Requests",
    ),
    "friends": MessageLookupByLibrary.simpleMessage("Friends"),
    "friends_list_find_new_friends": MessageLookupByLibrary.simpleMessage(
      "Find new friends",
    ),
    "friends_list_no_friends": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any friends yet. Start connecting!",
    ),
    "friends_list_title": MessageLookupByLibrary.simpleMessage("Friends"),
    "friends_only": MessageLookupByLibrary.simpleMessage("Friends only"),
    "game_chat_name": MessageLookupByLibrary.simpleMessage("Game"),
    "game_creation_available_questions": MessageLookupByLibrary.simpleMessage(
      "Available Questions",
    ),
    "game_creation_classic_description": MessageLookupByLibrary.simpleMessage(
      "Choose a quiz and compete with other players",
    ),
    "game_creation_classic_mode": MessageLookupByLibrary.simpleMessage(
      "Classic Mode",
    ),
    "game_creation_create_game": MessageLookupByLibrary.simpleMessage(
      "Create Game",
    ),
    "game_creation_elimination_description":
        MessageLookupByLibrary.simpleMessage(
          "Players are eliminated after each question",
        ),
    "game_creation_elimination_mode": MessageLookupByLibrary.simpleMessage(
      "Elimination Mode",
    ),
    "game_creation_entry_price": MessageLookupByLibrary.simpleMessage(
      "Entry Price",
    ),
    "game_creation_friends_only": MessageLookupByLibrary.simpleMessage(
      "Friends Only Game",
    ),
    "game_creation_friends_only_game": MessageLookupByLibrary.simpleMessage(
      "Friends Only",
    ),
    "game_creation_game_options": MessageLookupByLibrary.simpleMessage(
      "Game Options",
    ),
    "game_creation_max_questions": m11,
    "game_creation_not_enough_balance": MessageLookupByLibrary.simpleMessage(
      "Not enough balance to create this game",
    ),
    "game_creation_not_enough_questions": MessageLookupByLibrary.simpleMessage(
      "You need at least 5 questions to create a game",
    ),
    "game_creation_public": MessageLookupByLibrary.simpleMessage("Public Game"),
    "game_creation_public_game": MessageLookupByLibrary.simpleMessage(
      "Public Game",
    ),
    "game_creation_question_count": MessageLookupByLibrary.simpleMessage(
      "Number of Questions: ",
    ),
    "game_creation_question_list": MessageLookupByLibrary.simpleMessage(
      "List of Questions",
    ),
    "game_creation_select_game": MessageLookupByLibrary.simpleMessage(
      "Classic Mode",
    ),
    "game_creation_survival_description": MessageLookupByLibrary.simpleMessage(
      "Answer questions as fast as possible to survive",
    ),
    "game_creation_survival_mode": MessageLookupByLibrary.simpleMessage(
      "Survival Mode",
    ),
    "game_creation_unavailable_quiz": MessageLookupByLibrary.simpleMessage(
      "The selected quiz is no longer available",
    ),
    "game_elimination_service_last_answer":
        MessageLookupByLibrary.simpleMessage("You were the last to answer"),
    "game_elimination_service_no_answer": MessageLookupByLibrary.simpleMessage(
      "You didn\'t answer in time",
    ),
    "game_elimination_service_wrong_answer":
        MessageLookupByLibrary.simpleMessage("You answered wrong"),
    "game_header_random_quiz_title": MessageLookupByLibrary.simpleMessage(
      "Random Quiz",
    ),
    "game_joining_banned_user": MessageLookupByLibrary.simpleMessage(
      "You are banned from the game",
    ),
    "game_joining_create_one": MessageLookupByLibrary.simpleMessage(
      "Create one!",
    ),
    "game_joining_friends_only": MessageLookupByLibrary.simpleMessage(
      "This game room is friend\'s only",
    ),
    "game_joining_game_already_started": MessageLookupByLibrary.simpleMessage(
      "The game is in progress",
    ),
    "game_joining_game_id": MessageLookupByLibrary.simpleMessage("Game ID"),
    "game_joining_header_random_quiz_title":
        MessageLookupByLibrary.simpleMessage("Random Quiz"),
    "game_joining_invalid_game_id": MessageLookupByLibrary.simpleMessage(
      "Id must be a 4 digit number",
    ),
    "game_joining_lobby_locked": MessageLookupByLibrary.simpleMessage(
      "This game room is locked",
    ),
    "game_joining_no_game_currently": MessageLookupByLibrary.simpleMessage(
      "There is no active game at the moment",
    ),
    "game_joining_no_game_found": MessageLookupByLibrary.simpleMessage(
      "The game does not exist",
    ),
    "game_joining_not_enough_coins": MessageLookupByLibrary.simpleMessage(
      "You do not have enough coins to join this game",
    ),
    "game_joining_pay_to_join": m12,
    "game_joining_players": MessageLookupByLibrary.simpleMessage("Players"),
    "game_joining_rating": MessageLookupByLibrary.simpleMessage("Quiz Rating"),
    "game_joining_status": MessageLookupByLibrary.simpleMessage("Status"),
    "game_joining_title": MessageLookupByLibrary.simpleMessage("Title"),
    "game_joining_type": MessageLookupByLibrary.simpleMessage("Mode"),
    "game_leaderboard_fun": MessageLookupByLibrary.simpleMessage("Fun"),
    "game_leaderboard_fun_stats": MessageLookupByLibrary.simpleMessage(
      "Fun Statistics",
    ),
    "game_leaderboard_quiz": MessageLookupByLibrary.simpleMessage("Quiz"),
    "game_leaderboard_stats": MessageLookupByLibrary.simpleMessage(
      "User Statistics",
    ),
    "game_leaderboard_title": MessageLookupByLibrary.simpleMessage(
      "Leaderboard",
    ),
    "game_leaderboard_user": MessageLookupByLibrary.simpleMessage("User"),
    "game_lobby_lock_game": MessageLookupByLibrary.simpleMessage("Unlocked"),
    "game_lobby_start_game": MessageLookupByLibrary.simpleMessage("Start game"),
    "game_lobby_unlock_game": MessageLookupByLibrary.simpleMessage("Locked"),
    "game_loot_challenge_coins_gained": MessageLookupByLibrary.simpleMessage(
      "Challenge Rewards",
    ),
    "game_loot_coins": MessageLookupByLibrary.simpleMessage("Coins"),
    "game_loot_coins_gained": MessageLookupByLibrary.simpleMessage(
      "Coins Gained",
    ),
    "game_loot_coins_paid": MessageLookupByLibrary.simpleMessage("Entry Fee"),
    "game_loot_experience": MessageLookupByLibrary.simpleMessage("Experience"),
    "game_loot_level_up": MessageLookupByLibrary.simpleMessage(
      "You leveled up!",
    ),
    "game_loot_won_game_pot": m13,
    "game_loot_xp_gained": MessageLookupByLibrary.simpleMessage(
      "Experience Gained",
    ),
    "game_loot_xp_label": MessageLookupByLibrary.simpleMessage(
      "Experience Points",
    ),
    "game_message_answers_sent": MessageLookupByLibrary.simpleMessage(
      "Answers sent",
    ),
    "game_message_correction_with_bonus": m14,
    "game_message_correction_with_percentage": m15,
    "game_message_correction_without_bonus": m16,
    "game_metrics_game_time_added": MessageLookupByLibrary.simpleMessage(
      "Game time",
    ),
    "game_metrics_game_won": MessageLookupByLibrary.simpleMessage("Games won"),
    "game_metrics_no_improvements": MessageLookupByLibrary.simpleMessage(
      "No Improvements",
    ),
    "game_metrics_points_gained": MessageLookupByLibrary.simpleMessage(
      "Points Gained",
    ),
    "game_metrics_questions_survived": MessageLookupByLibrary.simpleMessage(
      "Questions Survived",
    ),
    "game_metrics_title": MessageLookupByLibrary.simpleMessage(
      "Game Stats Improvements",
    ),
    "game_mode_classical": MessageLookupByLibrary.simpleMessage("Classical"),
    "game_mode_elimination": MessageLookupByLibrary.simpleMessage(
      "Elimination",
    ),
    "game_mode_survival": MessageLookupByLibrary.simpleMessage("Survival"),
    "game_organizer_correcting_answers": MessageLookupByLibrary.simpleMessage(
      "Evaluate the response",
    ),
    "game_organizer_waiting_answers": MessageLookupByLibrary.simpleMessage(
      "Player\'s are answering",
    ),
    "game_play_top_bar_title": MessageLookupByLibrary.simpleMessage(
      "Game view",
    ),
    "game_player_waiting_correction_title":
        MessageLookupByLibrary.simpleMessage("Correction of the responses"),
    "game_result_next_slide_button": MessageLookupByLibrary.simpleMessage(
      "Next",
    ),
    "game_result_previous_slide_button": MessageLookupByLibrary.simpleMessage(
      "Previous",
    ),
    "game_score_alive": MessageLookupByLibrary.simpleMessage("Alive"),
    "game_score_eliminated": MessageLookupByLibrary.simpleMessage("Eliminated"),
    "game_score_your_score": MessageLookupByLibrary.simpleMessage("Your score"),
    "game_time": MessageLookupByLibrary.simpleMessage("Game Time"),
    "game_top_bar_leave": MessageLookupByLibrary.simpleMessage("Give Up"),
    "game_top_bar_logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "game_top_bar_quit": MessageLookupByLibrary.simpleMessage("Quit"),
    "game_top_bar_terminate": MessageLookupByLibrary.simpleMessage("Terminate"),
    "game_win_streak_streak_best": MessageLookupByLibrary.simpleMessage(
      "You\'ve reached your best win streak!",
    ),
    "game_win_streak_streak_improved": MessageLookupByLibrary.simpleMessage(
      "Your win streak has improved!",
    ),
    "game_win_streak_streak_lost": MessageLookupByLibrary.simpleMessage(
      "You lost the win streak!",
    ),
    "games_won": MessageLookupByLibrary.simpleMessage("Games Won"),
    "go_to_shop": MessageLookupByLibrary.simpleMessage("Go to the shop"),
    "golden_blueberry_avatar": MessageLookupByLibrary.simpleMessage(
      "Golden Blueberry Avatar",
    ),
    "golden_lemon_avatar": MessageLookupByLibrary.simpleMessage(
      "Golden Lemon Avatar",
    ),
    "golden_watermelon_avatar": MessageLookupByLibrary.simpleMessage(
      "Golden Watermelon Avatar",
    ),
    "header_avatar_button": MessageLookupByLibrary.simpleMessage("Avatar"),
    "header_confirm_logout": MessageLookupByLibrary.simpleMessage(
      "Do you really want to logout?",
    ),
    "header_create_game_button": MessageLookupByLibrary.simpleMessage(
      "Create a Game",
    ),
    "header_game_history": MessageLookupByLibrary.simpleMessage("Game History"),
    "header_game_history_button": MessageLookupByLibrary.simpleMessage(
      "History",
    ),
    "header_game_menu": MessageLookupByLibrary.simpleMessage("Game Menu"),
    "header_history_button": MessageLookupByLibrary.simpleMessage("History"),
    "header_join_game_button": MessageLookupByLibrary.simpleMessage(
      "Join a Game",
    ),
    "header_leaderboard_button": MessageLookupByLibrary.simpleMessage(
      "Leaderboard",
    ),
    "header_library_button": MessageLookupByLibrary.simpleMessage("Library"),
    "header_logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "header_logout_button": MessageLookupByLibrary.simpleMessage("Logout"),
    "header_profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "header_profile_button": MessageLookupByLibrary.simpleMessage("Profile"),
    "header_shop_button": MessageLookupByLibrary.simpleMessage("Shop"),
    "header_users_button": MessageLookupByLibrary.simpleMessage("Users"),
    "header_widget_avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
    "header_widget_create_game": MessageLookupByLibrary.simpleMessage(
      "Create Game",
    ),
    "header_widget_join_game": MessageLookupByLibrary.simpleMessage(
      "Join Game",
    ),
    "header_widget_leaderboard": MessageLookupByLibrary.simpleMessage(
      "Leaderboard",
    ),
    "header_widget_library": MessageLookupByLibrary.simpleMessage("Library"),
    "header_widget_shop": MessageLookupByLibrary.simpleMessage("Shop"),
    "header_widget_users_button": MessageLookupByLibrary.simpleMessage(
      "Users list",
    ),
    "hint_widget_buy_hint": m17,
    "home_page_create_game": MessageLookupByLibrary.simpleMessage(
      "Create a game",
    ),
    "home_page_join_game": MessageLookupByLibrary.simpleMessage("Join a game"),
    "home_page_no_choice_text": MessageLookupByLibrary.simpleMessage(
      "No Choice Text",
    ),
    "home_page_no_description": MessageLookupByLibrary.simpleMessage(
      "No Description",
    ),
    "home_page_no_question_text": MessageLookupByLibrary.simpleMessage(
      "No Question Text",
    ),
    "home_page_no_title": MessageLookupByLibrary.simpleMessage("No Title"),
    "home_page_team": MessageLookupByLibrary.simpleMessage("Team 101"),
    "home_page_team_members": MessageLookupByLibrary.simpleMessage(
      "Lyne Dahan, Jérôme Fréchette, Skander Hellal, Philippe Martin, John Abou Nakoul, Yacine Barka",
    ),
    "image_load_failed": MessageLookupByLibrary.simpleMessage(
      "Failed to load image",
    ),
    "image_not_available": MessageLookupByLibrary.simpleMessage(
      "Image not available",
    ),
    "image_zoom": MessageLookupByLibrary.simpleMessage("Zoom"),
    "information": MessageLookupByLibrary.simpleMessage("Information"),
    "information_header": MessageLookupByLibrary.simpleMessage("Informations"),
    "information_modal_understood": MessageLookupByLibrary.simpleMessage(
      "Understood",
    ),
    "information_profile_blueberry_theme": MessageLookupByLibrary.simpleMessage(
      "Blueberry",
    ),
    "information_profile_lemon_theme": MessageLookupByLibrary.simpleMessage(
      "Lemon",
    ),
    "information_profile_orange_theme": MessageLookupByLibrary.simpleMessage(
      "Orange",
    ),
    "information_profile_select_background":
        MessageLookupByLibrary.simpleMessage("Select a Background"),
    "information_profile_select_theme": MessageLookupByLibrary.simpleMessage(
      "Select a Theme",
    ),
    "information_profile_strawberry_theme":
        MessageLookupByLibrary.simpleMessage("Strawberry"),
    "information_profile_username": MessageLookupByLibrary.simpleMessage(
      "Username",
    ),
    "information_profile_watermelon_theme":
        MessageLookupByLibrary.simpleMessage("Watermelon"),
    "join": MessageLookupByLibrary.simpleMessage("Join"),
    "join_chatroom": MessageLookupByLibrary.simpleMessage("Join a chatroom"),
    "join_game": MessageLookupByLibrary.simpleMessage("Join a Game"),
    "kicked_out_message_banned": MessageLookupByLibrary.simpleMessage(
      "You have been banned",
    ),
    "kicked_out_message_no_players_left": MessageLookupByLibrary.simpleMessage(
      "There are no more players participating",
    ),
    "kicked_out_message_organizer_left": MessageLookupByLibrary.simpleMessage(
      "The organizer has terminated the game",
    ),
    "leaderboardPage_BestStreak": MessageLookupByLibrary.simpleMessage(
      "Best Win Streak",
    ),
    "leaderboardPage_CoinsGained": MessageLookupByLibrary.simpleMessage(
      "Coins Gained",
    ),
    "leaderboardPage_CoinsSpent": MessageLookupByLibrary.simpleMessage(
      "Coins Spent",
    ),
    "leaderboardPage_CurrentStreak": MessageLookupByLibrary.simpleMessage(
      "Current Win Streak",
    ),
    "leaderboardPage_GameTime": MessageLookupByLibrary.simpleMessage(
      "Game Time",
    ),
    "leaderboardPage_GamesWon": MessageLookupByLibrary.simpleMessage(
      "Games Won",
    ),
    "leaderboardPage_Leaderboard": MessageLookupByLibrary.simpleMessage(
      "Leaderboard",
    ),
    "leaderboardPage_Points": MessageLookupByLibrary.simpleMessage(
      "Points accumulated",
    ),
    "leaderboardPage_Questions": MessageLookupByLibrary.simpleMessage(
      "Questions",
    ),
    "leaderboardPage_Rank": MessageLookupByLibrary.simpleMessage("Rank"),
    "leaderboardPage_User": MessageLookupByLibrary.simpleMessage("User"),
    "leave_chat_title": MessageLookupByLibrary.simpleMessage(
      "Leave a Chatroom",
    ),
    "lemon_background": MessageLookupByLibrary.simpleMessage(
      "Lemon Background",
    ),
    "level_XP": MessageLookupByLibrary.simpleMessage("Level XP:"),
    "locked_item_message": MessageLookupByLibrary.simpleMessage(
      "Visit the shop to buy items.",
    ),
    "locked_item_title": MessageLookupByLibrary.simpleMessage("Item Locked"),
    "log_history_android": MessageLookupByLibrary.simpleMessage("Mobile"),
    "log_history_auth_logs": MessageLookupByLibrary.simpleMessage(
      "Sign In/Out History",
    ),
    "log_history_back": MessageLookupByLibrary.simpleMessage("Back to Home"),
    "log_history_desktop": MessageLookupByLibrary.simpleMessage("PC"),
    "log_history_device_type": MessageLookupByLibrary.simpleMessage("Device"),
    "log_history_game_logs": MessageLookupByLibrary.simpleMessage(
      "Game Sessions",
    ),
    "log_history_has_abandon": MessageLookupByLibrary.simpleMessage(
      "Abandoned",
    ),
    "log_history_has_won": MessageLookupByLibrary.simpleMessage("Victory"),
    "log_history_login_time": MessageLookupByLibrary.simpleMessage(
      "Signed In At",
    ),
    "log_history_logout_time": MessageLookupByLibrary.simpleMessage(
      "Signed Out At",
    ),
    "log_history_no_records": MessageLookupByLibrary.simpleMessage(
      "No records",
    ),
    "log_history_start_date": MessageLookupByLibrary.simpleMessage(
      "Game Started",
    ),
    "log_history_title": MessageLookupByLibrary.simpleMessage("My History"),
    "login_button": MessageLookupByLibrary.simpleMessage("LOG IN"),
    "login_here": MessageLookupByLibrary.simpleMessage("Log in here"),
    "login_title": MessageLookupByLibrary.simpleMessage("Log in"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "new_message": MessageLookupByLibrary.simpleMessage("New message"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "no_account": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "no_chats": MessageLookupByLibrary.simpleMessage("No chatroom found..."),
    "no_empty_name": MessageLookupByLibrary.simpleMessage(
      "The chatroom name cannot be empty.",
    ),
    "no_items": MessageLookupByLibrary.simpleMessage(
      "No items available for this category.",
    ),
    "notification_close_button": MessageLookupByLibrary.simpleMessage("Close"),
    "orange_background": MessageLookupByLibrary.simpleMessage(
      "Orange Background",
    ),
    "organizer_correcting": MessageLookupByLibrary.simpleMessage(
      "The organizer is correcting the answers",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "password_label": MessageLookupByLibrary.simpleMessage("Password"),
    "password_mismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "personal_info_error_title": MessageLookupByLibrary.simpleMessage(
      "Error while saving",
    ),
    "personal_info_header": MessageLookupByLibrary.simpleMessage("Information"),
    "personal_info_success_title": MessageLookupByLibrary.simpleMessage(
      "Success",
    ),
    "personal_profile_challenge_completed":
        MessageLookupByLibrary.simpleMessage("Challenges Completed"),
    "personal_profile_correct_answers": MessageLookupByLibrary.simpleMessage(
      "Average Correct Answers",
    ),
    "personal_profile_email": MessageLookupByLibrary.simpleMessage("Email:"),
    "personal_profile_game_played": MessageLookupByLibrary.simpleMessage(
      "Games Played",
    ),
    "personal_profile_game_time": MessageLookupByLibrary.simpleMessage(
      "Average Game Time",
    ),
    "personal_profile_game_won": MessageLookupByLibrary.simpleMessage(
      "Games Won",
    ),
    "personal_profile_info": MessageLookupByLibrary.simpleMessage(
      "Personal Information:",
    ),
    "personal_profile_language_choice": MessageLookupByLibrary.simpleMessage(
      "Choose a language :",
    ),
    "personal_profile_language_english": MessageLookupByLibrary.simpleMessage(
      "English",
    ),
    "personal_profile_language_french": MessageLookupByLibrary.simpleMessage(
      "French",
    ),
    "personal_profile_level": MessageLookupByLibrary.simpleMessage("Level"),
    "personal_profile_selected_page": MessageLookupByLibrary.simpleMessage(
      "Selected page:",
    ),
    "personal_profile_statistics": MessageLookupByLibrary.simpleMessage(
      "Statistics",
    ),
    "personal_profile_username": MessageLookupByLibrary.simpleMessage(
      "Username:",
    ),
    "player": MessageLookupByLibrary.simpleMessage("Player"),
    "player_list_round_survived": MessageLookupByLibrary.simpleMessage(
      "Rounds Survived",
    ),
    "player_list_score": MessageLookupByLibrary.simpleMessage("Score"),
    "player_list_title": MessageLookupByLibrary.simpleMessage("Player\'s List"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
    "premium_avatar": MessageLookupByLibrary.simpleMessage("Premium avatars"),
    "premium_lemon_avatar": MessageLookupByLibrary.simpleMessage(
      "Premium Lemon Avatar",
    ),
    "premium_orange_avatar": MessageLookupByLibrary.simpleMessage(
      "Premium Orange Avatar",
    ),
    "prepare_yourself": MessageLookupByLibrary.simpleMessage(
      "Prepare Yourself",
    ),
    "price": MessageLookupByLibrary.simpleMessage("Price:"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "public_profile_user_unfound": MessageLookupByLibrary.simpleMessage(
      "User not found",
    ),
    "qre_answer_player_correct": MessageLookupByLibrary.simpleMessage(
      "Correct Answer:",
    ),
    "qre_answer_player_hint": MessageLookupByLibrary.simpleMessage(
      "Enter your answer",
    ),
    "qre_correct_answer_is": m18,
    "qre_correct_answer_with_tolerance": m19,
    "qre_enter_answer_hint": MessageLookupByLibrary.simpleMessage(
      "Enter your answer",
    ),
    "qre_slider_max_value": m20,
    "qre_slider_min_value": m21,
    "qrl_correction_finished": MessageLookupByLibrary.simpleMessage(
      "Correction terminée",
    ),
    "question_header_zoom": MessageLookupByLibrary.simpleMessage("Zoom"),
    "question_type_qcm": MessageLookupByLibrary.simpleMessage(
      "Multiple Choice",
    ),
    "question_type_qre": MessageLookupByLibrary.simpleMessage(
      "Estimated Response",
    ),
    "question_type_qrl": MessageLookupByLibrary.simpleMessage("Long Response"),
    "question_type_unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "questions_survived": MessageLookupByLibrary.simpleMessage(
      "Questions Survived",
    ),
    "quick_join_button": MessageLookupByLibrary.simpleMessage("Join"),
    "quick_join_label": MessageLookupByLibrary.simpleMessage("Game code"),
    "quit_button": MessageLookupByLibrary.simpleMessage("Quit"),
    "quiz_contains_questions": m22,
    "quiz_description": m23,
    "quiz_detail_component_creator": MessageLookupByLibrary.simpleMessage(
      "Created by:",
    ),
    "quiz_detail_component_description": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "quiz_detail_component_nb_questions": MessageLookupByLibrary.simpleMessage(
      "Number of questions:",
    ),
    "quiz_detail_component_time_to_respond":
        MessageLookupByLibrary.simpleMessage("Time to respond:"),
    "quiz_duration": m24,
    "quiz_last_modified": m25,
    "quiz_owner": m26,
    "quiz_question_count": m27,
    "quiz_questions": MessageLookupByLibrary.simpleMessage("questions"),
    "quiz_send_rating_rate_quiz": MessageLookupByLibrary.simpleMessage(
      "Rate this quiz",
    ),
    "quiz_send_rating_update_rating": MessageLookupByLibrary.simpleMessage(
      "Update your rating",
    ),
    "quiz_title": m28,
    "quiz_view_rating_quiz_rating": MessageLookupByLibrary.simpleMessage(
      "Quiz Rating",
    ),
    "quiz_view_rating_reviews": MessageLookupByLibrary.simpleMessage("reviews"),
    "quiz_view_rating_unrateable": MessageLookupByLibrary.simpleMessage(
      "Unrateable",
    ),
    "random_quiz_description": MessageLookupByLibrary.simpleMessage(
      "Questions are selected randomly from the quiz bank",
    ),
    "random_quiz_header_title": MessageLookupByLibrary.simpleMessage(
      "Elimination Quiz",
    ),
    "random_quiz_time_limit": MessageLookupByLibrary.simpleMessage(
      "Time to answer: 20s",
    ),
    "random_quiz_title": MessageLookupByLibrary.simpleMessage(
      "Elimination Mode Quiz",
    ),
    "register_title": MessageLookupByLibrary.simpleMessage("Create an account"),
    "result_view_achivements": MessageLookupByLibrary.simpleMessage(
      "Achievements",
    ),
    "result_view_cant_rate_system_quiz": MessageLookupByLibrary.simpleMessage(
      "Cannot rate system quiz",
    ),
    "result_view_challenges": MessageLookupByLibrary.simpleMessage(
      "Game Challenges",
    ),
    "result_view_created_by": MessageLookupByLibrary.simpleMessage(
      "Created by: ",
    ),
    "result_view_game_loot": MessageLookupByLibrary.simpleMessage("Game Loots"),
    "result_view_leaderboard": MessageLookupByLibrary.simpleMessage(
      "Leaderboard",
    ),
    "result_view_quiz_stats": MessageLookupByLibrary.simpleMessage(
      "Quiz & Feedback",
    ),
    "result_view_title": MessageLookupByLibrary.simpleMessage("Game Results"),
    "result_winner_answered_faster": MessageLookupByLibrary.simpleMessage(
      "answered faster",
    ),
    "result_winner_tie_breaker": MessageLookupByLibrary.simpleMessage(
      "Tie Breaker: ",
    ),
    "result_winner_winner": MessageLookupByLibrary.simpleMessage("Winner: "),
    "results_stats_quiz_cannot_rate": MessageLookupByLibrary.simpleMessage(
      "Cannot rate system quiz",
    ),
    "results_stats_quiz_created": MessageLookupByLibrary.simpleMessage(
      "Created by:",
    ),
    "results_stats_quiz_fun_stats": MessageLookupByLibrary.simpleMessage(
      "Fun statistics",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save as new avatar"),
    "select_chatroom": MessageLookupByLibrary.simpleMessage("Open a chatroom"),
    "select_game": MessageLookupByLibrary.simpleMessage(
      "Select a quiz to test or start a game!",
    ),
    "select_quiz_details": MessageLookupByLibrary.simpleMessage(
      "Select a quiz to see the details",
    ),
    "shop_title": MessageLookupByLibrary.simpleMessage("Your Shop"),
    "side_bar_accomplishements": MessageLookupByLibrary.simpleMessage(
      "Achievements",
    ),
    "side_bar_friends": MessageLookupByLibrary.simpleMessage("Friends"),
    "side_bar_preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
    "side_bar_themes": MessageLookupByLibrary.simpleMessage("Themes"),
    "sidebar_widget_accomplishments": MessageLookupByLibrary.simpleMessage(
      "Accomplishments",
    ),
    "sidebar_widget_friends": MessageLookupByLibrary.simpleMessage("Friends"),
    "sidebar_widget_info": MessageLookupByLibrary.simpleMessage("Information"),
    "sidebar_widget_languages": MessageLookupByLibrary.simpleMessage(
      "Languages",
    ),
    "sidebar_widget_themes": MessageLookupByLibrary.simpleMessage("Themes"),
    "signup_button": MessageLookupByLibrary.simpleMessage("SIGN UP"),
    "special_quiz_activate_condition": MessageLookupByLibrary.simpleMessage(
      "You need at least 5 QCM or QRE to activate this quiz",
    ),
    "special_quiz_cant_change": MessageLookupByLibrary.simpleMessage(
      "Create new QCM or QRE if you want more than 5 questions",
    ),
    "special_quiz_count_selected": m29,
    "special_quiz_nb_question_details": MessageLookupByLibrary.simpleMessage(
      "Select a number of questions: ",
    ),
    "special_quiz_nb_question_header": m30,
    "strawberry_background": MessageLookupByLibrary.simpleMessage(
      "Strawberry Background",
    ),
    "strawberry_theme": MessageLookupByLibrary.simpleMessage(
      "Strawberry Theme",
    ),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "survival_best_score_best_score": MessageLookupByLibrary.simpleMessage(
      "Best Score",
    ),
    "survival_best_score_current_score": MessageLookupByLibrary.simpleMessage(
      "Current Score",
    ),
    "survival_best_score_title": MessageLookupByLibrary.simpleMessage(
      "Survival Mode",
    ),
    "survival_mode_progression_title": MessageLookupByLibrary.simpleMessage(
      "Survival Mode",
    ),
    "survival_quiz_description": MessageLookupByLibrary.simpleMessage(
      "Questions are selected randomly from the quiz bank",
    ),
    "survival_quiz_header_title": MessageLookupByLibrary.simpleMessage(
      "Survival Quiz",
    ),
    "survival_quiz_time_limit": MessageLookupByLibrary.simpleMessage(
      "Time to answer: 20s",
    ),
    "survival_quiz_title": MessageLookupByLibrary.simpleMessage(
      "Survival Mode Quiz",
    ),
    "survival_result_lost_title": MessageLookupByLibrary.simpleMessage(
      "Defeat, you couldn\'t survive",
    ),
    "survival_result_mode": MessageLookupByLibrary.simpleMessage(
      "Questions Survived",
    ),
    "survival_result_questions_correct": m31,
    "survival_result_won_title": MessageLookupByLibrary.simpleMessage(
      "Victory, you survived until the end",
    ),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "the_chatroom": MessageLookupByLibrary.simpleMessage("the chatroom"),
    "the_game": MessageLookupByLibrary.simpleMessage("the game"),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "total_points": MessageLookupByLibrary.simpleMessage("Total Points"),
    "user_joined": m32,
    "user_left": m33,
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "username_empty": MessageLookupByLibrary.simpleMessage(
      "You can not leave the username empty.",
    ),
    "username_empty_error": MessageLookupByLibrary.simpleMessage(
      "The username can not be empty.",
    ),
    "username_label": MessageLookupByLibrary.simpleMessage("Username"),
    "username_taken": MessageLookupByLibrary.simpleMessage(
      "This username is already taken",
    ),
    "username_updated": MessageLookupByLibrary.simpleMessage(
      "Your username has been changed.",
    ),
    "users_list_filter_label": MessageLookupByLibrary.simpleMessage(
      "Filter by username",
    ),
    "users_list_no_result": MessageLookupByLibrary.simpleMessage(
      "No users match your search",
    ),
    "users_list_title": MessageLookupByLibrary.simpleMessage(
      "Discover new users",
    ),
    "users_list_visit_account": MessageLookupByLibrary.simpleMessage(
      "View user profile",
    ),
    "waiting_for_players": MessageLookupByLibrary.simpleMessage(
      "Waiting for players...",
    ),
    "waiting_room": MessageLookupByLibrary.simpleMessage("Waiting Room"),
    "watermelon_background": MessageLookupByLibrary.simpleMessage(
      "Watermelon Background",
    ),
    "watermelon_theme": MessageLookupByLibrary.simpleMessage(
      "Watermelon Theme",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "your_stats": MessageLookupByLibrary.simpleMessage("Achievements"),
  };
}
