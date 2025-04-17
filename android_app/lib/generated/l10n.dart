// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log in`
  String get login_title {
    return Intl.message('Log in', name: 'login_title', desc: '', args: []);
  }

  /// `Username`
  String get username_label {
    return Intl.message('Username', name: 'username_label', desc: '', args: []);
  }

  /// `Password`
  String get password_label {
    return Intl.message('Password', name: 'password_label', desc: '', args: []);
  }

  /// `LOG IN`
  String get login_button {
    return Intl.message('LOG IN', name: 'login_button', desc: '', args: []);
  }

  /// `Error`
  String get error_icon_label {
    return Intl.message('Error', name: 'error_icon_label', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get no_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'no_account',
      desc: '',
      args: [],
    );
  }

  /// `Create one`
  String get create_account {
    return Intl.message(
      'Create one',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get register_title {
    return Intl.message(
      'Create an account',
      name: 'register_title',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email_label {
    return Intl.message('Email', name: 'email_label', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirm_password_label {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password_label',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get signup_button {
    return Intl.message('SIGN UP', name: 'signup_button', desc: '', args: []);
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Log in here`
  String get login_here {
    return Intl.message('Log in here', name: 'login_here', desc: '', args: []);
  }

  /// `Passwords do not match`
  String get password_mismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `The username is required`
  String get error_username_required {
    return Intl.message(
      'The username is required',
      name: 'error_username_required',
      desc: '',
      args: [],
    );
  }

  /// `The username is invalid. It can only contain letters, numbers, and underscores`
  String get error_username_invalid {
    return Intl.message(
      'The username is invalid. It can only contain letters, numbers, and underscores',
      name: 'error_username_invalid',
      desc: '',
      args: [],
    );
  }

  /// `The username cannot contain system reserved words`
  String get error_username_system {
    return Intl.message(
      'The username cannot contain system reserved words',
      name: 'error_username_system',
      desc: '',
      args: [],
    );
  }

  /// `The username must be between 4 and 12 characters`
  String get error_username_length {
    return Intl.message(
      'The username must be between 4 and 12 characters',
      name: 'error_username_length',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get error_password_required {
    return Intl.message(
      'Password is required',
      name: 'error_password_required',
      desc: '',
      args: [],
    );
  }

  /// `The password must be at least 5 characters`
  String get error_password_length {
    return Intl.message(
      'The password must be at least 5 characters',
      name: 'error_password_length',
      desc: '',
      args: [],
    );
  }

  /// `The password can only contain letters, numbers, and special characters`
  String get error_password_invalid {
    return Intl.message(
      'The password can only contain letters, numbers, and special characters',
      name: 'error_password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get error_email_required {
    return Intl.message(
      'Email is required',
      name: 'error_email_required',
      desc: '',
      args: [],
    );
  }

  /// `The email must follow the format example@domain.com`
  String get error_email_invalid {
    return Intl.message(
      'The email must follow the format example@domain.com',
      name: 'error_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Most Wins`
  String get HomeCarousel_MostWins {
    return Intl.message(
      'Most Wins',
      name: 'HomeCarousel_MostWins',
      desc: '',
      args: [],
    );
  }

  /// `Most Coins Spent`
  String get HomeCarousel_MostCoinsSpent {
    return Intl.message(
      'Most Coins Spent',
      name: 'HomeCarousel_MostCoinsSpent',
      desc: '',
      args: [],
    );
  }

  /// `Most Points`
  String get HomeCarousel_MostPoints {
    return Intl.message(
      'Most Points',
      name: 'HomeCarousel_MostPoints',
      desc: '',
      args: [],
    );
  }

  /// `Best Survival Score`
  String get HomeCarousel_BestSurvivalScore {
    return Intl.message(
      'Best Survival Score',
      name: 'HomeCarousel_BestSurvivalScore',
      desc: '',
      args: [],
    );
  }

  /// `Longest Game Time`
  String get HomeCarousel_LongestGameTime {
    return Intl.message(
      'Longest Game Time',
      name: 'HomeCarousel_LongestGameTime',
      desc: '',
      args: [],
    );
  }

  /// `Highest Current Win Streak`
  String get HomeCarousel_HighestCurrentWinStreak {
    return Intl.message(
      'Highest Current Win Streak',
      name: 'HomeCarousel_HighestCurrentWinStreak',
      desc: '',
      args: [],
    );
  }

  /// `Best Win Streak`
  String get HomeCarousel_BestWinStreak {
    return Intl.message(
      'Best Win Streak',
      name: 'HomeCarousel_BestWinStreak',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get HomeCarousel_NoDataAvailable {
    return Intl.message(
      'No data available',
      name: 'HomeCarousel_NoDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Username and password are required`
  String get AccountValidation_missingFields {
    return Intl.message(
      'Username and password are required',
      name: 'AccountValidation_missingFields',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect username or password`
  String get AccountValidation_incorrectCredentials {
    return Intl.message(
      'Incorrect username or password',
      name: 'AccountValidation_incorrectCredentials',
      desc: '',
      args: [],
    );
  }

  /// `This account is already logged in`
  String get AccountValidation_alreadyLoggedIn {
    return Intl.message(
      'This account is already logged in',
      name: 'AccountValidation_alreadyLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `This email address is already in use`
  String get AccountValidation_emailTaken {
    return Intl.message(
      'This email address is already in use',
      name: 'AccountValidation_emailTaken',
      desc: '',
      args: [],
    );
  }

  /// `This username is already taken`
  String get AccountValidation_usernameTaken {
    return Intl.message(
      'This username is already taken',
      name: 'AccountValidation_usernameTaken',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred`
  String get AccountValidation_unknownError {
    return Intl.message(
      'An unknown error occurred',
      name: 'AccountValidation_unknownError',
      desc: '',
      args: [],
    );
  }

  /// `The username is already taken`
  String get AccountValidation_usernameExists {
    return Intl.message(
      'The username is already taken',
      name: 'AccountValidation_usernameExists',
      desc: '',
      args: [],
    );
  }

  /// `Username is required`
  String get AccountValidation_usernameRequired {
    return Intl.message(
      'Username is required',
      name: 'AccountValidation_usernameRequired',
      desc: '',
      args: [],
    );
  }

  /// `The username is invalid. It can only contain letters, numbers, and underscores`
  String get AccountValidation_usernameInvalid {
    return Intl.message(
      'The username is invalid. It can only contain letters, numbers, and underscores',
      name: 'AccountValidation_usernameInvalid',
      desc: '',
      args: [],
    );
  }

  /// `The username cannot contain system reserved words`
  String get AccountValidation_usernameSystem {
    return Intl.message(
      'The username cannot contain system reserved words',
      name: 'AccountValidation_usernameSystem',
      desc: '',
      args: [],
    );
  }

  /// `The username must be between 4 and 12 characters`
  String get AccountValidation_usernameLength {
    return Intl.message(
      'The username must be between 4 and 12 characters',
      name: 'AccountValidation_usernameLength',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get AccountValidation_passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'AccountValidation_passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `The password must be at least 5 characters`
  String get AccountValidation_passwordLength {
    return Intl.message(
      'The password must be at least 5 characters',
      name: 'AccountValidation_passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `The password can only contain letters, numbers, and special characters`
  String get AccountValidation_passwordInvalid {
    return Intl.message(
      'The password can only contain letters, numbers, and special characters',
      name: 'AccountValidation_passwordInvalid',
      desc: '',
      args: [],
    );
  }

  /// `The passwords do not match`
  String get AccountValidation_passwordMismatch {
    return Intl.message(
      'The passwords do not match',
      name: 'AccountValidation_passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get AccountValidation_emailRequired {
    return Intl.message(
      'Email is required',
      name: 'AccountValidation_emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `The email must follow the format example@domain.com`
  String get AccountValidation_emailInvalid {
    return Intl.message(
      'The email must follow the format example@domain.com',
      name: 'AccountValidation_emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please select an avatar`
  String get AccountValidation_avatarRequired {
    return Intl.message(
      'Please select an avatar',
      name: 'AccountValidation_avatarRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the terms and conditions`
  String get AccountValidation_termsRequired {
    return Intl.message(
      'Please accept the terms and conditions',
      name: 'AccountValidation_termsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update username`
  String get AccountValidation_updateError {
    return Intl.message(
      'Failed to update username',
      name: 'AccountValidation_updateError',
      desc: '',
      args: [],
    );
  }

  /// `Join a Game`
  String get join_game {
    return Intl.message('Join a Game', name: 'join_game', desc: '', args: []);
  }

  /// `Game code`
  String get quick_join_label {
    return Intl.message(
      'Game code',
      name: 'quick_join_label',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get quick_join_button {
    return Intl.message('Join', name: 'quick_join_button', desc: '', args: []);
  }

  /// `Friends`
  String get friend_page {
    return Intl.message('Friends', name: 'friend_page', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Select a quiz to test or start a game!`
  String get select_game {
    return Intl.message(
      'Select a quiz to test or start a game!',
      name: 'select_game',
      desc: '',
      args: [],
    );
  }

  /// `Select a quiz to see the details`
  String get select_quiz_details {
    return Intl.message(
      'Select a quiz to see the details',
      name: 'select_quiz_details',
      desc: '',
      args: [],
    );
  }

  /// `Classic Mode`
  String get game_creation_select_game {
    return Intl.message(
      'Classic Mode',
      name: 'game_creation_select_game',
      desc: '',
      args: [],
    );
  }

  /// `Create Game`
  String get game_creation_create_game {
    return Intl.message(
      'Create Game',
      name: 'game_creation_create_game',
      desc: '',
      args: [],
    );
  }

  /// `Friends Only Game`
  String get game_creation_friends_only {
    return Intl.message(
      'Friends Only Game',
      name: 'game_creation_friends_only',
      desc: '',
      args: [],
    );
  }

  /// `Public Game`
  String get game_creation_public {
    return Intl.message(
      'Public Game',
      name: 'game_creation_public',
      desc: '',
      args: [],
    );
  }

  /// `The selected quiz is no longer available`
  String get game_creation_unavailable_quiz {
    return Intl.message(
      'The selected quiz is no longer available',
      name: 'game_creation_unavailable_quiz',
      desc: '',
      args: [],
    );
  }

  /// `Prepare Yourself`
  String get prepare_yourself {
    return Intl.message(
      'Prepare Yourself',
      name: 'prepare_yourself',
      desc: '',
      args: [],
    );
  }

  /// `The game does not exist`
  String get game_joining_no_game_found {
    return Intl.message(
      'The game does not exist',
      name: 'game_joining_no_game_found',
      desc: '',
      args: [],
    );
  }

  /// `Id must be a 4 digit number`
  String get game_joining_invalid_game_id {
    return Intl.message(
      'Id must be a 4 digit number',
      name: 'game_joining_invalid_game_id',
      desc: '',
      args: [],
    );
  }

  /// `The game is in progress`
  String get game_joining_game_already_started {
    return Intl.message(
      'The game is in progress',
      name: 'game_joining_game_already_started',
      desc: '',
      args: [],
    );
  }

  /// `This game room is locked`
  String get game_joining_lobby_locked {
    return Intl.message(
      'This game room is locked',
      name: 'game_joining_lobby_locked',
      desc: '',
      args: [],
    );
  }

  /// `You are banned from the game`
  String get game_joining_banned_user {
    return Intl.message(
      'You are banned from the game',
      name: 'game_joining_banned_user',
      desc: '',
      args: [],
    );
  }

  /// `This game room is friend's only`
  String get game_joining_friends_only {
    return Intl.message(
      'This game room is friend\'s only',
      name: 'game_joining_friends_only',
      desc: '',
      args: [],
    );
  }

  /// `There is no active game at the moment`
  String get game_joining_no_game_currently {
    return Intl.message(
      'There is no active game at the moment',
      name: 'game_joining_no_game_currently',
      desc: '',
      args: [],
    );
  }

  /// `Create one!`
  String get game_joining_create_one {
    return Intl.message(
      'Create one!',
      name: 'game_joining_create_one',
      desc: '',
      args: [],
    );
  }

  /// `Game ID`
  String get game_joining_game_id {
    return Intl.message(
      'Game ID',
      name: 'game_joining_game_id',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get game_joining_title {
    return Intl.message(
      'Title',
      name: 'game_joining_title',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get game_joining_type {
    return Intl.message('Mode', name: 'game_joining_type', desc: '', args: []);
  }

  /// `Quiz Rating`
  String get game_joining_rating {
    return Intl.message(
      'Quiz Rating',
      name: 'game_joining_rating',
      desc: '',
      args: [],
    );
  }

  /// `Players`
  String get game_joining_players {
    return Intl.message(
      'Players',
      name: 'game_joining_players',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get game_joining_status {
    return Intl.message(
      'Status',
      name: 'game_joining_status',
      desc: '',
      args: [],
    );
  }

  /// `Random Quiz`
  String get game_joining_header_random_quiz_title {
    return Intl.message(
      'Random Quiz',
      name: 'game_joining_header_random_quiz_title',
      desc: '',
      args: [],
    );
  }

  /// `You need to pay {amount} coins to join this game`
  String game_joining_pay_to_join(Object amount) {
    return Intl.message(
      'You need to pay $amount coins to join this game',
      name: 'game_joining_pay_to_join',
      desc: '',
      args: [amount],
    );
  }

  /// `You do not have enough coins to join this game`
  String get game_joining_not_enough_coins {
    return Intl.message(
      'You do not have enough coins to join this game',
      name: 'game_joining_not_enough_coins',
      desc: '',
      args: [],
    );
  }

  /// `Entry Price`
  String get game_creation_entry_price {
    return Intl.message(
      'Entry Price',
      name: 'game_creation_entry_price',
      desc: '',
      args: [],
    );
  }

  /// `Game Challenges`
  String get result_view_challenges {
    return Intl.message(
      'Game Challenges',
      name: 'result_view_challenges',
      desc: '',
      args: [],
    );
  }

  /// `Enter the game code: `
  String get enter_game_code {
    return Intl.message(
      'Enter the game code: ',
      name: 'enter_game_code',
      desc: '',
      args: [],
    );
  }

  /// `Error joining the game`
  String get error_joining_game {
    return Intl.message(
      'Error joining the game',
      name: 'error_joining_game',
      desc: '',
      args: [],
    );
  }

  /// `Waiting Room`
  String get waiting_room {
    return Intl.message(
      'Waiting Room',
      name: 'waiting_room',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for players...`
  String get waiting_for_players {
    return Intl.message(
      'Waiting for players...',
      name: 'waiting_for_players',
      desc: '',
      args: [],
    );
  }

  /// `Elimination`
  String get game_mode_elimination {
    return Intl.message(
      'Elimination',
      name: 'game_mode_elimination',
      desc: '',
      args: [],
    );
  }

  /// `Survival`
  String get game_mode_survival {
    return Intl.message(
      'Survival',
      name: 'game_mode_survival',
      desc: '',
      args: [],
    );
  }

  /// `Classical`
  String get game_mode_classical {
    return Intl.message(
      'Classical',
      name: 'game_mode_classical',
      desc: '',
      args: [],
    );
  }

  /// `The organizer is correcting the answers`
  String get organizer_correcting {
    return Intl.message(
      'The organizer is correcting the answers',
      name: 'organizer_correcting',
      desc: '',
      args: [],
    );
  }

  /// `Enter your answer`
  String get enter_answer {
    return Intl.message(
      'Enter your answer',
      name: 'enter_answer',
      desc: '',
      args: [],
    );
  }

  /// `Correction terminée`
  String get qrl_correction_finished {
    return Intl.message(
      'Correction terminée',
      name: 'qrl_correction_finished',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `questions`
  String get quiz_questions {
    return Intl.message(
      'questions',
      name: 'quiz_questions',
      desc: '',
      args: [],
    );
  }

  /// `Title: {title}`
  String quiz_title(Object title) {
    return Intl.message(
      'Title: $title',
      name: 'quiz_title',
      desc: '',
      args: [title],
    );
  }

  /// `Description: {description}`
  String quiz_description(Object description) {
    return Intl.message(
      'Description: $description',
      name: 'quiz_description',
      desc: '',
      args: [description],
    );
  }

  /// `Time to answer: {duration}s`
  String quiz_duration(Object duration) {
    return Intl.message(
      'Time to answer: ${duration}s',
      name: 'quiz_duration',
      desc: '',
      args: [duration],
    );
  }

  /// `Number of questions: {count}`
  String quiz_question_count(Object count) {
    return Intl.message(
      'Number of questions: $count',
      name: 'quiz_question_count',
      desc: '',
      args: [count],
    );
  }

  /// `Last modification: {date}`
  String quiz_last_modified(Object date) {
    return Intl.message(
      'Last modification: $date',
      name: 'quiz_last_modified',
      desc: '',
      args: [date],
    );
  }

  /// `Creator: {owner}`
  String quiz_owner(Object owner) {
    return Intl.message(
      'Creator: $owner',
      name: 'quiz_owner',
      desc: '',
      args: [owner],
    );
  }

  /// `Quiz Rating`
  String get quiz_view_rating_quiz_rating {
    return Intl.message(
      'Quiz Rating',
      name: 'quiz_view_rating_quiz_rating',
      desc: '',
      args: [],
    );
  }

  /// `reviews`
  String get quiz_view_rating_reviews {
    return Intl.message(
      'reviews',
      name: 'quiz_view_rating_reviews',
      desc: '',
      args: [],
    );
  }

  /// `Unrateable`
  String get quiz_view_rating_unrateable {
    return Intl.message(
      'Unrateable',
      name: 'quiz_view_rating_unrateable',
      desc: '',
      args: [],
    );
  }

  /// `Rate this quiz`
  String get quiz_send_rating_rate_quiz {
    return Intl.message(
      'Rate this quiz',
      name: 'quiz_send_rating_rate_quiz',
      desc: '',
      args: [],
    );
  }

  /// `Update your rating`
  String get quiz_send_rating_update_rating {
    return Intl.message(
      'Update your rating',
      name: 'quiz_send_rating_update_rating',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Choice`
  String get question_type_qcm {
    return Intl.message(
      'Multiple Choice',
      name: 'question_type_qcm',
      desc: '',
      args: [],
    );
  }

  /// `Long Response`
  String get question_type_qrl {
    return Intl.message(
      'Long Response',
      name: 'question_type_qrl',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Response`
  String get question_type_qre {
    return Intl.message(
      'Estimated Response',
      name: 'question_type_qre',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get question_type_unknown {
    return Intl.message(
      'Unknown',
      name: 'question_type_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Contains {count} questions`
  String quiz_contains_questions(Object count) {
    return Intl.message(
      'Contains $count questions',
      name: 'quiz_contains_questions',
      desc: '',
      args: [count],
    );
  }

  /// `Random Quiz`
  String get game_header_random_quiz_title {
    return Intl.message(
      'Random Quiz',
      name: 'game_header_random_quiz_title',
      desc: '',
      args: [],
    );
  }

  /// `Elimination Mode Quiz`
  String get random_quiz_title {
    return Intl.message(
      'Elimination Mode Quiz',
      name: 'random_quiz_title',
      desc: '',
      args: [],
    );
  }

  /// `Questions are selected randomly from the quiz bank`
  String get random_quiz_description {
    return Intl.message(
      'Questions are selected randomly from the quiz bank',
      name: 'random_quiz_description',
      desc: '',
      args: [],
    );
  }

  /// `Time to answer: 20s`
  String get random_quiz_time_limit {
    return Intl.message(
      'Time to answer: 20s',
      name: 'random_quiz_time_limit',
      desc: '',
      args: [],
    );
  }

  /// `Elimination Quiz`
  String get random_quiz_header_title {
    return Intl.message(
      'Elimination Quiz',
      name: 'random_quiz_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Survival Mode Quiz`
  String get survival_quiz_title {
    return Intl.message(
      'Survival Mode Quiz',
      name: 'survival_quiz_title',
      desc: '',
      args: [],
    );
  }

  /// `Questions are selected randomly from the quiz bank`
  String get survival_quiz_description {
    return Intl.message(
      'Questions are selected randomly from the quiz bank',
      name: 'survival_quiz_description',
      desc: '',
      args: [],
    );
  }

  /// `Time to answer: 20s`
  String get survival_quiz_time_limit {
    return Intl.message(
      'Time to answer: 20s',
      name: 'survival_quiz_time_limit',
      desc: '',
      args: [],
    );
  }

  /// `Survival Quiz`
  String get survival_quiz_header_title {
    return Intl.message(
      'Survival Quiz',
      name: 'survival_quiz_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Create new QCM or QRE if you want more than 5 questions`
  String get special_quiz_cant_change {
    return Intl.message(
      'Create new QCM or QRE if you want more than 5 questions',
      name: 'special_quiz_cant_change',
      desc: '',
      args: [],
    );
  }

  /// `You selected {count} questions`
  String special_quiz_count_selected(Object count) {
    return Intl.message(
      'You selected $count questions',
      name: 'special_quiz_count_selected',
      desc: '',
      args: [count],
    );
  }

  /// `Select a number of questions: `
  String get special_quiz_nb_question_details {
    return Intl.message(
      'Select a number of questions: ',
      name: 'special_quiz_nb_question_details',
      desc: '',
      args: [],
    );
  }

  /// `Contains 5 to {totalQuestions} questions`
  String special_quiz_nb_question_header(Object totalQuestions) {
    return Intl.message(
      'Contains 5 to $totalQuestions questions',
      name: 'special_quiz_nb_question_header',
      desc: '',
      args: [totalQuestions],
    );
  }

  /// `You need at least 5 QCM or QRE to activate this quiz`
  String get special_quiz_activate_condition {
    return Intl.message(
      'You need at least 5 QCM or QRE to activate this quiz',
      name: 'special_quiz_activate_condition',
      desc: '',
      args: [],
    );
  }

  /// `Survival Mode`
  String get survival_mode_progression_title {
    return Intl.message(
      'Survival Mode',
      name: 'survival_mode_progression_title',
      desc: '',
      args: [],
    );
  }

  /// `Give Up`
  String get game_top_bar_leave {
    return Intl.message(
      'Give Up',
      name: 'game_top_bar_leave',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get game_top_bar_logout {
    return Intl.message(
      'Log out',
      name: 'game_top_bar_logout',
      desc: '',
      args: [],
    );
  }

  /// `Quit`
  String get game_top_bar_quit {
    return Intl.message('Quit', name: 'game_top_bar_quit', desc: '', args: []);
  }

  /// `Terminate`
  String get game_top_bar_terminate {
    return Intl.message(
      'Terminate',
      name: 'game_top_bar_terminate',
      desc: '',
      args: [],
    );
  }

  /// `Player's List`
  String get player_list_title {
    return Intl.message(
      'Player\'s List',
      name: 'player_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get player_list_score {
    return Intl.message('Score', name: 'player_list_score', desc: '', args: []);
  }

  /// `Rounds Survived`
  String get player_list_round_survived {
    return Intl.message(
      'Rounds Survived',
      name: 'player_list_round_survived',
      desc: '',
      args: [],
    );
  }

  /// `Start game`
  String get game_lobby_start_game {
    return Intl.message(
      'Start game',
      name: 'game_lobby_start_game',
      desc: '',
      args: [],
    );
  }

  /// `Unlocked`
  String get game_lobby_lock_game {
    return Intl.message(
      'Unlocked',
      name: 'game_lobby_lock_game',
      desc: '',
      args: [],
    );
  }

  /// `Locked`
  String get game_lobby_unlock_game {
    return Intl.message(
      'Locked',
      name: 'game_lobby_unlock_game',
      desc: '',
      args: [],
    );
  }

  /// `Game view`
  String get game_play_top_bar_title {
    return Intl.message(
      'Game view',
      name: 'game_play_top_bar_title',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get continue_game {
    return Intl.message('Next', name: 'continue_game', desc: '', args: []);
  }

  /// `Player's are answering`
  String get game_organizer_waiting_answers {
    return Intl.message(
      'Player\'s are answering',
      name: 'game_organizer_waiting_answers',
      desc: '',
      args: [],
    );
  }

  /// `Evaluate the response`
  String get game_organizer_correcting_answers {
    return Intl.message(
      'Evaluate the response',
      name: 'game_organizer_correcting_answers',
      desc: '',
      args: [],
    );
  }

  /// `Correction of the responses`
  String get game_player_waiting_correction_title {
    return Intl.message(
      'Correction of the responses',
      name: 'game_player_waiting_correction_title',
      desc: '',
      args: [],
    );
  }

  /// `Game`
  String get game_chat_name {
    return Intl.message('Game', name: 'game_chat_name', desc: '', args: []);
  }

  /// `Do you really want to leave the chatroom '{chatName}' ?`
  String confirm_leave_chat(Object chatName) {
    return Intl.message(
      'Do you really want to leave the chatroom \'$chatName\' ?',
      name: 'confirm_leave_chat',
      desc: '',
      args: [chatName],
    );
  }

  /// `Do you really want to delete the chatroom '{chatName}' ?`
  String confirm_delete_chat(Object chatName) {
    return Intl.message(
      'Do you really want to delete the chatroom \'$chatName\' ?',
      name: 'confirm_delete_chat',
      desc: '',
      args: [chatName],
    );
  }

  /// `Leave a Chatroom`
  String get leave_chat_title {
    return Intl.message(
      'Leave a Chatroom',
      name: 'leave_chat_title',
      desc: '',
      args: [],
    );
  }

  /// `Delete a Chatroom`
  String get delete_chat_title {
    return Intl.message(
      'Delete a Chatroom',
      name: 'delete_chat_title',
      desc: '',
      args: [],
    );
  }

  /// `The chatroom name cannot be empty.`
  String get no_empty_name {
    return Intl.message(
      'The chatroom name cannot be empty.',
      name: 'no_empty_name',
      desc: '',
      args: [],
    );
  }

  /// `Friends only`
  String get friends_only {
    return Intl.message(
      'Friends only',
      name: 'friends_only',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Join`
  String get join {
    return Intl.message('Join', name: 'join', desc: '', args: []);
  }

  /// `No chatroom found...`
  String get no_chats {
    return Intl.message(
      'No chatroom found...',
      name: 'no_chats',
      desc: '',
      args: [],
    );
  }

  /// `Create a chatroom`
  String get create_chatroom {
    return Intl.message(
      'Create a chatroom',
      name: 'create_chatroom',
      desc: '',
      args: [],
    );
  }

  /// `Join a chatroom`
  String get join_chatroom {
    return Intl.message(
      'Join a chatroom',
      name: 'join_chatroom',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter_placeholder {
    return Intl.message(
      'Filter',
      name: 'filter_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Chatroom name`
  String get chat_name_placeholder {
    return Intl.message(
      'Chatroom name',
      name: 'chat_name_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Open a chatroom`
  String get select_chatroom {
    return Intl.message(
      'Open a chatroom',
      name: 'select_chatroom',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `chatrooms`
  String get chatrooms {
    return Intl.message('chatrooms', name: 'chatrooms', desc: '', args: []);
  }

  /// `The chatroom name cannot be empty.`
  String get chat_name_empty_error {
    return Intl.message(
      'The chatroom name cannot be empty.',
      name: 'chat_name_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `This chatroom name is already taken.`
  String get chat_name_taken_error {
    return Intl.message(
      'This chatroom name is already taken.',
      name: 'chat_name_taken_error',
      desc: '',
      args: [],
    );
  }

  /// `This chatroom name is restricted.`
  String get chat_name_restricted_error {
    return Intl.message(
      'This chatroom name is restricted.',
      name: 'chat_name_restricted_error',
      desc: '',
      args: [],
    );
  }

  /// `{username} has left`
  String user_left(Object username) {
    return Intl.message(
      '$username has left',
      name: 'user_left',
      desc: '',
      args: [username],
    );
  }

  /// `{username} has joined`
  String user_joined(Object username) {
    return Intl.message(
      '$username has joined',
      name: 'user_joined',
      desc: '',
      args: [username],
    );
  }

  /// `the game`
  String get the_game {
    return Intl.message('the game', name: 'the_game', desc: '', args: []);
  }

  /// `the chatroom`
  String get the_chatroom {
    return Intl.message(
      'the chatroom',
      name: 'the_chatroom',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Enter your answer`
  String get qre_enter_answer_hint {
    return Intl.message(
      'Enter your answer',
      name: 'qre_enter_answer_hint',
      desc: '',
      args: [],
    );
  }

  /// `The correct answer is: {value}`
  String qre_correct_answer_is(Object value) {
    return Intl.message(
      'The correct answer is: $value',
      name: 'qre_correct_answer_is',
      desc: '',
      args: [value],
    );
  }

  /// `The correct answer is: {value} ± {tolerance}`
  String qre_correct_answer_with_tolerance(Object value, Object tolerance) {
    return Intl.message(
      'The correct answer is: $value ± $tolerance',
      name: 'qre_correct_answer_with_tolerance',
      desc: '',
      args: [value, tolerance],
    );
  }

  /// `{value}`
  String qre_slider_min_value(Object value) {
    return Intl.message(
      '$value',
      name: 'qre_slider_min_value',
      desc: '',
      args: [value],
    );
  }

  /// `{value}`
  String qre_slider_max_value(Object value) {
    return Intl.message(
      '$value',
      name: 'qre_slider_max_value',
      desc: '',
      args: [value],
    );
  }

  /// `Failed to load image`
  String get image_load_failed {
    return Intl.message(
      'Failed to load image',
      name: 'image_load_failed',
      desc: '',
      args: [],
    );
  }

  /// `Image not available`
  String get image_not_available {
    return Intl.message(
      'Image not available',
      name: 'image_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Zoom`
  String get image_zoom {
    return Intl.message('Zoom', name: 'image_zoom', desc: '', args: []);
  }

  /// `Eliminated`
  String get elimination_modal {
    return Intl.message(
      'Eliminated',
      name: 'elimination_modal',
      desc: '',
      args: [],
    );
  }

  /// `You answered wrong`
  String get game_elimination_service_wrong_answer {
    return Intl.message(
      'You answered wrong',
      name: 'game_elimination_service_wrong_answer',
      desc: '',
      args: [],
    );
  }

  /// `You were the last to answer`
  String get game_elimination_service_last_answer {
    return Intl.message(
      'You were the last to answer',
      name: 'game_elimination_service_last_answer',
      desc: '',
      args: [],
    );
  }

  /// `You didn't answer in time`
  String get game_elimination_service_no_answer {
    return Intl.message(
      'You didn\'t answer in time',
      name: 'game_elimination_service_no_answer',
      desc: '',
      args: [],
    );
  }

  /// `Users list`
  String get header_widget_users_button {
    return Intl.message(
      'Users list',
      name: 'header_widget_users_button',
      desc: '',
      args: [],
    );
  }

  /// `Discover new users`
  String get users_list_title {
    return Intl.message(
      'Discover new users',
      name: 'users_list_title',
      desc: '',
      args: [],
    );
  }

  /// `Filter by username`
  String get users_list_filter_label {
    return Intl.message(
      'Filter by username',
      name: 'users_list_filter_label',
      desc: '',
      args: [],
    );
  }

  /// `No users match your search`
  String get users_list_no_result {
    return Intl.message(
      'No users match your search',
      name: 'users_list_no_result',
      desc: '',
      args: [],
    );
  }

  /// `View user profile`
  String get users_list_visit_account {
    return Intl.message(
      'View user profile',
      name: 'users_list_visit_account',
      desc: '',
      args: [],
    );
  }

  /// `Friend Requests`
  String get friend_requests_title {
    return Intl.message(
      'Friend Requests',
      name: 'friend_requests_title',
      desc: '',
      args: [],
    );
  }

  /// `Sent Requests`
  String get friend_requests_sent_requests {
    return Intl.message(
      'Sent Requests',
      name: 'friend_requests_sent_requests',
      desc: '',
      args: [],
    );
  }

  /// `Received Requests`
  String get friend_requests_received_requests {
    return Intl.message(
      'Received Requests',
      name: 'friend_requests_received_requests',
      desc: '',
      args: [],
    );
  }

  /// `You haven't sent any friend requests yet.`
  String get friend_requests_no_sent_requests {
    return Intl.message(
      'You haven\'t sent any friend requests yet.',
      name: 'friend_requests_no_sent_requests',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any pending friend requests.`
  String get friend_requests_no_received_requests {
    return Intl.message(
      'You don\'t have any pending friend requests.',
      name: 'friend_requests_no_received_requests',
      desc: '',
      args: [],
    );
  }

  /// `New friend request from {username}`
  String friend_requests_new_request_from(Object username) {
    return Intl.message(
      'New friend request from $username',
      name: 'friend_requests_new_request_from',
      desc: '',
      args: [username],
    );
  }

  /// `{count} New Friend Requests`
  String friend_requests_multiple_requests(Object count) {
    return Intl.message(
      '$count New Friend Requests',
      name: 'friend_requests_multiple_requests',
      desc: '',
      args: [count],
    );
  }

  /// `{username} accepted your friend request`
  String friend_requests_request_accepted(Object username) {
    return Intl.message(
      '$username accepted your friend request',
      name: 'friend_requests_request_accepted',
      desc: '',
      args: [username],
    );
  }

  /// `Add friend`
  String get friend_requests_add_friend {
    return Intl.message(
      'Add friend',
      name: 'friend_requests_add_friend',
      desc: '',
      args: [],
    );
  }

  /// `Answer received request`
  String get friend_requests_answer_request {
    return Intl.message(
      'Answer received request',
      name: 'friend_requests_answer_request',
      desc: '',
      args: [],
    );
  }

  /// `Revoke sent request`
  String get friend_requests_revoke_sent_request {
    return Intl.message(
      'Revoke sent request',
      name: 'friend_requests_revoke_sent_request',
      desc: '',
      args: [],
    );
  }

  /// `Send friend request`
  String get friend_request_tooltips_send_request {
    return Intl.message(
      'Send friend request',
      name: 'friend_request_tooltips_send_request',
      desc: '',
      args: [],
    );
  }

  /// `Accept request`
  String get friend_request_tooltips_accept_request {
    return Intl.message(
      'Accept request',
      name: 'friend_request_tooltips_accept_request',
      desc: '',
      args: [],
    );
  }

  /// `Decline request`
  String get friend_request_tooltips_decline_request {
    return Intl.message(
      'Decline request',
      name: 'friend_request_tooltips_decline_request',
      desc: '',
      args: [],
    );
  }

  /// `Revoke request`
  String get friend_request_tooltips_revoke_request {
    return Intl.message(
      'Revoke request',
      name: 'friend_request_tooltips_revoke_request',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends_list_title {
    return Intl.message(
      'Friends',
      name: 'friends_list_title',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any friends yet. Start connecting!`
  String get friends_list_no_friends {
    return Intl.message(
      'You don\'t have any friends yet. Start connecting!',
      name: 'friends_list_no_friends',
      desc: '',
      args: [],
    );
  }

  /// `Find new friends`
  String get friends_list_find_new_friends {
    return Intl.message(
      'Find new friends',
      name: 'friends_list_find_new_friends',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get game_leaderboard_title {
    return Intl.message(
      'Leaderboard',
      name: 'game_leaderboard_title',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get game_leaderboard_user {
    return Intl.message(
      'User',
      name: 'game_leaderboard_user',
      desc: '',
      args: [],
    );
  }

  /// `Fun`
  String get game_leaderboard_fun {
    return Intl.message(
      'Fun',
      name: 'game_leaderboard_fun',
      desc: '',
      args: [],
    );
  }

  /// `Fun Statistics`
  String get game_leaderboard_fun_stats {
    return Intl.message(
      'Fun Statistics',
      name: 'game_leaderboard_fun_stats',
      desc: '',
      args: [],
    );
  }

  /// `Quiz`
  String get game_leaderboard_quiz {
    return Intl.message(
      'Quiz',
      name: 'game_leaderboard_quiz',
      desc: '',
      args: [],
    );
  }

  /// `User Statistics`
  String get game_leaderboard_stats {
    return Intl.message(
      'User Statistics',
      name: 'game_leaderboard_stats',
      desc: '',
      args: [],
    );
  }

  /// `No Title`
  String get home_page_no_title {
    return Intl.message(
      'No Title',
      name: 'home_page_no_title',
      desc: '',
      args: [],
    );
  }

  /// `No Description`
  String get home_page_no_description {
    return Intl.message(
      'No Description',
      name: 'home_page_no_description',
      desc: '',
      args: [],
    );
  }

  /// `No Question Text`
  String get home_page_no_question_text {
    return Intl.message(
      'No Question Text',
      name: 'home_page_no_question_text',
      desc: '',
      args: [],
    );
  }

  /// `No Choice Text`
  String get home_page_no_choice_text {
    return Intl.message(
      'No Choice Text',
      name: 'home_page_no_choice_text',
      desc: '',
      args: [],
    );
  }

  /// `Selected page:`
  String get personal_profile_selected_page {
    return Intl.message(
      'Selected page:',
      name: 'personal_profile_selected_page',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get public_profile_user_unfound {
    return Intl.message(
      'User not found',
      name: 'public_profile_user_unfound',
      desc: '',
      args: [],
    );
  }

  /// `Correct Answer:`
  String get qre_answer_player_correct {
    return Intl.message(
      'Correct Answer:',
      name: 'qre_answer_player_correct',
      desc: '',
      args: [],
    );
  }

  /// `Enter your answer`
  String get qre_answer_player_hint {
    return Intl.message(
      'Enter your answer',
      name: 'qre_answer_player_hint',
      desc: '',
      args: [],
    );
  }

  /// `Fun statistics`
  String get results_stats_quiz_fun_stats {
    return Intl.message(
      'Fun statistics',
      name: 'results_stats_quiz_fun_stats',
      desc: '',
      args: [],
    );
  }

  /// `Cannot rate system quiz`
  String get results_stats_quiz_cannot_rate {
    return Intl.message(
      'Cannot rate system quiz',
      name: 'results_stats_quiz_cannot_rate',
      desc: '',
      args: [],
    );
  }

  /// `Add friend`
  String get friend_request_control_add_friend {
    return Intl.message(
      'Add friend',
      name: 'friend_request_control_add_friend',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get friend_request_control_friend {
    return Intl.message(
      'Friend',
      name: 'friend_request_control_friend',
      desc: '',
      args: [],
    );
  }

  /// `Delete Friend`
  String get friend_request_control_delete_friend {
    return Intl.message(
      'Delete Friend',
      name: 'friend_request_control_delete_friend',
      desc: '',
      args: [],
    );
  }

  /// `Received a request`
  String get friend_request_control_receive_request {
    return Intl.message(
      'Received a request',
      name: 'friend_request_control_receive_request',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get friend_request_control_accept {
    return Intl.message(
      'Accept',
      name: 'friend_request_control_accept',
      desc: '',
      args: [],
    );
  }

  /// `Refuse`
  String get friend_request_control_refuse {
    return Intl.message(
      'Refuse',
      name: 'friend_request_control_refuse',
      desc: '',
      args: [],
    );
  }

  /// `Sent a request`
  String get friend_request_control_send_request {
    return Intl.message(
      'Sent a request',
      name: 'friend_request_control_send_request',
      desc: '',
      args: [],
    );
  }

  /// `Delete request`
  String get friend_request_control_delete_request {
    return Intl.message(
      'Delete request',
      name: 'friend_request_control_delete_request',
      desc: '',
      args: [],
    );
  }

  /// `Can't add yourself as a friend`
  String get friend_request_control_add_yourself_error {
    return Intl.message(
      'Can\'t add yourself as a friend',
      name: 'friend_request_control_add_yourself_error',
      desc: '',
      args: [],
    );
  }

  /// `This chatroom is restricted to friends of {username}`
  String chat_friend_only_response(Object username) {
    return Intl.message(
      'This chatroom is restricted to friends of $username',
      name: 'chat_friend_only_response',
      desc: '',
      args: [username],
    );
  }

  /// `Eliminated`
  String get game_score_eliminated {
    return Intl.message(
      'Eliminated',
      name: 'game_score_eliminated',
      desc: '',
      args: [],
    );
  }

  /// `Alive`
  String get game_score_alive {
    return Intl.message('Alive', name: 'game_score_alive', desc: '', args: []);
  }

  /// `Game History`
  String get header_game_history {
    return Intl.message(
      'Game History',
      name: 'header_game_history',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get header_profile {
    return Intl.message('Profile', name: 'header_profile', desc: '', args: []);
  }

  /// `Logout`
  String get header_logout {
    return Intl.message('Logout', name: 'header_logout', desc: '', args: []);
  }

  /// `Personal Information:`
  String get personal_profile_info {
    return Intl.message(
      'Personal Information:',
      name: 'personal_profile_info',
      desc: '',
      args: [],
    );
  }

  /// `Username:`
  String get personal_profile_username {
    return Intl.message(
      'Username:',
      name: 'personal_profile_username',
      desc: '',
      args: [],
    );
  }

  /// `Email:`
  String get personal_profile_email {
    return Intl.message(
      'Email:',
      name: 'personal_profile_email',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get personal_profile_level {
    return Intl.message(
      'Level',
      name: 'personal_profile_level',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get personal_profile_statistics {
    return Intl.message(
      'Statistics',
      name: 'personal_profile_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Games Played`
  String get personal_profile_game_played {
    return Intl.message(
      'Games Played',
      name: 'personal_profile_game_played',
      desc: '',
      args: [],
    );
  }

  /// `Games Won`
  String get personal_profile_game_won {
    return Intl.message(
      'Games Won',
      name: 'personal_profile_game_won',
      desc: '',
      args: [],
    );
  }

  /// `Average Correct Answers`
  String get personal_profile_correct_answers {
    return Intl.message(
      'Average Correct Answers',
      name: 'personal_profile_correct_answers',
      desc: '',
      args: [],
    );
  }

  /// `Average Game Time`
  String get personal_profile_game_time {
    return Intl.message(
      'Average Game Time',
      name: 'personal_profile_game_time',
      desc: '',
      args: [],
    );
  }

  /// `Challenges Completed`
  String get personal_profile_challenge_completed {
    return Intl.message(
      'Challenges Completed',
      name: 'personal_profile_challenge_completed',
      desc: '',
      args: [],
    );
  }

  /// `Zoom`
  String get question_header_zoom {
    return Intl.message(
      'Zoom',
      name: 'question_header_zoom',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get side_bar_accomplishements {
    return Intl.message(
      'Achievements',
      name: 'side_bar_accomplishements',
      desc: '',
      args: [],
    );
  }

  /// `Themes`
  String get side_bar_themes {
    return Intl.message('Themes', name: 'side_bar_themes', desc: '', args: []);
  }

  /// `Preferences`
  String get side_bar_preferences {
    return Intl.message(
      'Preferences',
      name: 'side_bar_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get side_bar_friends {
    return Intl.message(
      'Friends',
      name: 'side_bar_friends',
      desc: '',
      args: [],
    );
  }

  /// `Add Bot`
  String get add_bot {
    return Intl.message('Add Bot', name: 'add_bot', desc: '', args: []);
  }

  /// `Beginner`
  String get bot_difficulty_beginner {
    return Intl.message(
      'Beginner',
      name: 'bot_difficulty_beginner',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get bot_difficulty_intermediate {
    return Intl.message(
      'Intermediate',
      name: 'bot_difficulty_intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Expert`
  String get bot_difficulty_expert {
    return Intl.message(
      'Expert',
      name: 'bot_difficulty_expert',
      desc: '',
      args: [],
    );
  }

  /// `You obtained {score} points thanks to the bonus`
  String game_message_correction_with_bonus(Object score) {
    return Intl.message(
      'You obtained $score points thanks to the bonus',
      name: 'game_message_correction_with_bonus',
      desc: '',
      args: [score],
    );
  }

  /// `You obtained {score} points`
  String game_message_correction_without_bonus(Object score) {
    return Intl.message(
      'You obtained $score points',
      name: 'game_message_correction_without_bonus',
      desc: '',
      args: [score],
    );
  }

  /// `You obtained {percent}% which is {points} points`
  String game_message_correction_with_percentage(
    Object percent,
    Object points,
  ) {
    return Intl.message(
      'You obtained $percent% which is $points points',
      name: 'game_message_correction_with_percentage',
      desc: '',
      args: [percent, points],
    );
  }

  /// `Answers sent`
  String get game_message_answers_sent {
    return Intl.message(
      'Answers sent',
      name: 'game_message_answers_sent',
      desc: '',
      args: [],
    );
  }

  /// `Understood`
  String get information_modal_understood {
    return Intl.message(
      'Understood',
      name: 'information_modal_understood',
      desc: '',
      args: [],
    );
  }

  /// `The organizer has terminated the game`
  String get kicked_out_message_organizer_left {
    return Intl.message(
      'The organizer has terminated the game',
      name: 'kicked_out_message_organizer_left',
      desc: '',
      args: [],
    );
  }

  /// `There are no more players participating`
  String get kicked_out_message_no_players_left {
    return Intl.message(
      'There are no more players participating',
      name: 'kicked_out_message_no_players_left',
      desc: '',
      args: [],
    );
  }

  /// `You have been banned`
  String get kicked_out_message_banned {
    return Intl.message(
      'You have been banned',
      name: 'kicked_out_message_banned',
      desc: '',
      args: [],
    );
  }

  /// `Created by:`
  String get results_stats_quiz_created {
    return Intl.message(
      'Created by:',
      name: 'results_stats_quiz_created',
      desc: '',
      args: [],
    );
  }

  /// `Create Game`
  String get header_widget_create_game {
    return Intl.message(
      'Create Game',
      name: 'header_widget_create_game',
      desc: '',
      args: [],
    );
  }

  /// `Join Game`
  String get header_widget_join_game {
    return Intl.message(
      'Join Game',
      name: 'header_widget_join_game',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get header_widget_library {
    return Intl.message(
      'Library',
      name: 'header_widget_library',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get header_widget_leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'header_widget_leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get header_widget_shop {
    return Intl.message('Shop', name: 'header_widget_shop', desc: '', args: []);
  }

  /// `Avatar`
  String get header_widget_avatar {
    return Intl.message(
      'Avatar',
      name: 'header_widget_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get sidebar_widget_info {
    return Intl.message(
      'Information',
      name: 'sidebar_widget_info',
      desc: '',
      args: [],
    );
  }

  /// `Accomplishments`
  String get sidebar_widget_accomplishments {
    return Intl.message(
      'Accomplishments',
      name: 'sidebar_widget_accomplishments',
      desc: '',
      args: [],
    );
  }

  /// `Themes`
  String get sidebar_widget_themes {
    return Intl.message(
      'Themes',
      name: 'sidebar_widget_themes',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get sidebar_widget_languages {
    return Intl.message(
      'Languages',
      name: 'sidebar_widget_languages',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get sidebar_widget_friends {
    return Intl.message(
      'Friends',
      name: 'sidebar_widget_friends',
      desc: '',
      args: [],
    );
  }

  /// `Victory, you survived until the end`
  String get survival_result_won_title {
    return Intl.message(
      'Victory, you survived until the end',
      name: 'survival_result_won_title',
      desc: '',
      args: [],
    );
  }

  /// `Defeat, you couldn't survive`
  String get survival_result_lost_title {
    return Intl.message(
      'Defeat, you couldn\'t survive',
      name: 'survival_result_lost_title',
      desc: '',
      args: [],
    );
  }

  /// `Questions Survived`
  String get survival_result_mode {
    return Intl.message(
      'Questions Survived',
      name: 'survival_result_mode',
      desc: '',
      args: [],
    );
  }

  /// `You survived the first {questionSurvived} questions out of {questionCount}`
  String survival_result_questions_correct(
    Object questionSurvived,
    Object questionCount,
  ) {
    return Intl.message(
      'You survived the first $questionSurvived questions out of $questionCount',
      name: 'survival_result_questions_correct',
      desc: '',
      args: [questionSurvived, questionCount],
    );
  }

  /// `Quit`
  String get quit_button {
    return Intl.message('Quit', name: 'quit_button', desc: '', args: []);
  }

  /// `Choose an Avatar`
  String get choose_avatar {
    return Intl.message(
      'Choose an Avatar',
      name: 'choose_avatar',
      desc: '',
      args: [],
    );
  }

  /// `You have to choose an avatar to continue.`
  String get error_avatar {
    return Intl.message(
      'You have to choose an avatar to continue.',
      name: 'error_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Winner: `
  String get result_winner_winner {
    return Intl.message(
      'Winner: ',
      name: 'result_winner_winner',
      desc: '',
      args: [],
    );
  }

  /// `Tie Breaker: `
  String get result_winner_tie_breaker {
    return Intl.message(
      'Tie Breaker: ',
      name: 'result_winner_tie_breaker',
      desc: '',
      args: [],
    );
  }

  /// `answered faster`
  String get result_winner_answered_faster {
    return Intl.message(
      'answered faster',
      name: 'result_winner_answered_faster',
      desc: '',
      args: [],
    );
  }

  /// `Game Results`
  String get result_view_title {
    return Intl.message(
      'Game Results',
      name: 'result_view_title',
      desc: '',
      args: [],
    );
  }

  /// `Cannot rate system quiz`
  String get result_view_cant_rate_system_quiz {
    return Intl.message(
      'Cannot rate system quiz',
      name: 'result_view_cant_rate_system_quiz',
      desc: '',
      args: [],
    );
  }

  /// `Created by: `
  String get result_view_created_by {
    return Intl.message(
      'Created by: ',
      name: 'result_view_created_by',
      desc: '',
      args: [],
    );
  }

  /// `My History`
  String get log_history_title {
    return Intl.message(
      'My History',
      name: 'log_history_title',
      desc: '',
      args: [],
    );
  }

  /// `Game Sessions`
  String get log_history_game_logs {
    return Intl.message(
      'Game Sessions',
      name: 'log_history_game_logs',
      desc: '',
      args: [],
    );
  }

  /// `Game Started`
  String get log_history_start_date {
    return Intl.message(
      'Game Started',
      name: 'log_history_start_date',
      desc: '',
      args: [],
    );
  }

  /// `Victory`
  String get log_history_has_won {
    return Intl.message(
      'Victory',
      name: 'log_history_has_won',
      desc: '',
      args: [],
    );
  }

  /// `Abandoned`
  String get log_history_has_abandon {
    return Intl.message(
      'Abandoned',
      name: 'log_history_has_abandon',
      desc: '',
      args: [],
    );
  }

  /// `Sign In/Out History`
  String get log_history_auth_logs {
    return Intl.message(
      'Sign In/Out History',
      name: 'log_history_auth_logs',
      desc: '',
      args: [],
    );
  }

  /// `Signed In At`
  String get log_history_login_time {
    return Intl.message(
      'Signed In At',
      name: 'log_history_login_time',
      desc: '',
      args: [],
    );
  }

  /// `Signed Out At`
  String get log_history_logout_time {
    return Intl.message(
      'Signed Out At',
      name: 'log_history_logout_time',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get log_history_device_type {
    return Intl.message(
      'Device',
      name: 'log_history_device_type',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get log_history_back {
    return Intl.message(
      'Back to Home',
      name: 'log_history_back',
      desc: '',
      args: [],
    );
  }

  /// `PC`
  String get log_history_desktop {
    return Intl.message('PC', name: 'log_history_desktop', desc: '', args: []);
  }

  /// `Mobile`
  String get log_history_android {
    return Intl.message(
      'Mobile',
      name: 'log_history_android',
      desc: '',
      args: [],
    );
  }

  /// `No records`
  String get log_history_no_records {
    return Intl.message(
      'No records',
      name: 'log_history_no_records',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get header_history_button {
    return Intl.message(
      'History',
      name: 'header_history_button',
      desc: '',
      args: [],
    );
  }

  /// `Error while saving`
  String get personal_info_error_title {
    return Intl.message(
      'Error while saving',
      name: 'personal_info_error_title',
      desc: '',
      args: [],
    );
  }

  /// `The username can not be empty.`
  String get username_empty_error {
    return Intl.message(
      'The username can not be empty.',
      name: 'username_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get personal_info_success_title {
    return Intl.message(
      'Success',
      name: 'personal_info_success_title',
      desc: '',
      args: [],
    );
  }

  /// `Your username has been changed.`
  String get username_updated {
    return Intl.message(
      'Your username has been changed.',
      name: 'username_updated',
      desc: '',
      args: [],
    );
  }

  /// `This username is already taken`
  String get username_taken {
    return Intl.message(
      'This username is already taken',
      name: 'username_taken',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get personal_info_header {
    return Intl.message(
      'Information',
      name: 'personal_info_header',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message('Preferences', name: 'preferences', desc: '', args: []);
  }

  /// `Friends`
  String get friends {
    return Intl.message('Friends', name: 'friends', desc: '', args: []);
  }

  /// `Level`
  String get current_level {
    return Intl.message('Level', name: 'current_level', desc: '', args: []);
  }

  /// `Level XP:`
  String get level_XP {
    return Intl.message('Level XP:', name: 'level_XP', desc: '', args: []);
  }

  /// `XP`
  String get experience {
    return Intl.message('XP', name: 'experience', desc: '', args: []);
  }

  /// `Information`
  String get information {
    return Intl.message('Information', name: 'information', desc: '', args: []);
  }

  /// `Informations`
  String get information_header {
    return Intl.message(
      'Informations',
      name: 'information_header',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Email address`
  String get email {
    return Intl.message('Email address', name: 'email', desc: '', args: []);
  }

  /// `You can not leave the username empty.`
  String get username_empty {
    return Intl.message(
      'You can not leave the username empty.',
      name: 'username_empty',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get Or {
    return Intl.message('OR', name: 'Or', desc: '', args: []);
  }

  /// `Change your avatar`
  String get change_avatar {
    return Intl.message(
      'Change your avatar',
      name: 'change_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get Upload {
    return Intl.message('Upload', name: 'Upload', desc: '', args: []);
  }

  /// `Camera`
  String get Camera {
    return Intl.message('Camera', name: 'Camera', desc: '', args: []);
  }

  /// `Save as new avatar`
  String get save {
    return Intl.message('Save as new avatar', name: 'save', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Premium avatars`
  String get premium_avatar {
    return Intl.message(
      'Premium avatars',
      name: 'premium_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Select a Theme`
  String get information_profile_select_theme {
    return Intl.message(
      'Select a Theme',
      name: 'information_profile_select_theme',
      desc: '',
      args: [],
    );
  }

  /// `Select a Background`
  String get information_profile_select_background {
    return Intl.message(
      'Select a Background',
      name: 'information_profile_select_background',
      desc: '',
      args: [],
    );
  }

  /// `Lemon`
  String get information_profile_lemon_theme {
    return Intl.message(
      'Lemon',
      name: 'information_profile_lemon_theme',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get information_profile_orange_theme {
    return Intl.message(
      'Orange',
      name: 'information_profile_orange_theme',
      desc: '',
      args: [],
    );
  }

  /// `Strawberry`
  String get information_profile_strawberry_theme {
    return Intl.message(
      'Strawberry',
      name: 'information_profile_strawberry_theme',
      desc: '',
      args: [],
    );
  }

  /// `Blueberry`
  String get information_profile_blueberry_theme {
    return Intl.message(
      'Blueberry',
      name: 'information_profile_blueberry_theme',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get information_profile_username {
    return Intl.message(
      'Username',
      name: 'information_profile_username',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get personal_profile_language_french {
    return Intl.message(
      'French',
      name: 'personal_profile_language_french',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get personal_profile_language_english {
    return Intl.message(
      'English',
      name: 'personal_profile_language_english',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language :`
  String get personal_profile_language_choice {
    return Intl.message(
      'Choose a language :',
      name: 'personal_profile_language_choice',
      desc: '',
      args: [],
    );
  }

  /// `You lost the win streak!`
  String get game_win_streak_streak_lost {
    return Intl.message(
      'You lost the win streak!',
      name: 'game_win_streak_streak_lost',
      desc: '',
      args: [],
    );
  }

  /// `Your win streak has improved!`
  String get game_win_streak_streak_improved {
    return Intl.message(
      'Your win streak has improved!',
      name: 'game_win_streak_streak_improved',
      desc: '',
      args: [],
    );
  }

  /// `You've reached your best win streak!`
  String get game_win_streak_streak_best {
    return Intl.message(
      'You\'ve reached your best win streak!',
      name: 'game_win_streak_streak_best',
      desc: '',
      args: [],
    );
  }

  /// `Game Stats Improvements`
  String get game_metrics_title {
    return Intl.message(
      'Game Stats Improvements',
      name: 'game_metrics_title',
      desc: '',
      args: [],
    );
  }

  /// `No Improvements`
  String get game_metrics_no_improvements {
    return Intl.message(
      'No Improvements',
      name: 'game_metrics_no_improvements',
      desc: '',
      args: [],
    );
  }

  /// `Points Gained`
  String get game_metrics_points_gained {
    return Intl.message(
      'Points Gained',
      name: 'game_metrics_points_gained',
      desc: '',
      args: [],
    );
  }

  /// `Questions Survived`
  String get game_metrics_questions_survived {
    return Intl.message(
      'Questions Survived',
      name: 'game_metrics_questions_survived',
      desc: '',
      args: [],
    );
  }

  /// `Game time`
  String get game_metrics_game_time_added {
    return Intl.message(
      'Game time',
      name: 'game_metrics_game_time_added',
      desc: '',
      args: [],
    );
  }

  /// `Games won`
  String get game_metrics_game_won {
    return Intl.message(
      'Games won',
      name: 'game_metrics_game_won',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get leaderboardPage_Leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'leaderboardPage_Leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get leaderboardPage_Rank {
    return Intl.message(
      'Rank',
      name: 'leaderboardPage_Rank',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get leaderboardPage_User {
    return Intl.message(
      'User',
      name: 'leaderboardPage_User',
      desc: '',
      args: [],
    );
  }

  /// `Points accumulated`
  String get leaderboardPage_Points {
    return Intl.message(
      'Points accumulated',
      name: 'leaderboardPage_Points',
      desc: '',
      args: [],
    );
  }

  /// `Questions`
  String get leaderboardPage_Questions {
    return Intl.message(
      'Questions',
      name: 'leaderboardPage_Questions',
      desc: '',
      args: [],
    );
  }

  /// `Game Time`
  String get leaderboardPage_GameTime {
    return Intl.message(
      'Game Time',
      name: 'leaderboardPage_GameTime',
      desc: '',
      args: [],
    );
  }

  /// `Games Won`
  String get leaderboardPage_GamesWon {
    return Intl.message(
      'Games Won',
      name: 'leaderboardPage_GamesWon',
      desc: '',
      args: [],
    );
  }

  /// `Current Win Streak`
  String get leaderboardPage_CurrentStreak {
    return Intl.message(
      'Current Win Streak',
      name: 'leaderboardPage_CurrentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Best Win Streak`
  String get leaderboardPage_BestStreak {
    return Intl.message(
      'Best Win Streak',
      name: 'leaderboardPage_BestStreak',
      desc: '',
      args: [],
    );
  }

  /// `Coins Spent`
  String get leaderboardPage_CoinsSpent {
    return Intl.message(
      'Coins Spent',
      name: 'leaderboardPage_CoinsSpent',
      desc: '',
      args: [],
    );
  }

  /// `Coins Gained`
  String get leaderboardPage_CoinsGained {
    return Intl.message(
      'Coins Gained',
      name: 'leaderboardPage_CoinsGained',
      desc: '',
      args: [],
    );
  }

  /// `The organizer has`
  String get chat_banned_service_organizer {
    return Intl.message(
      'The organizer has',
      name: 'chat_banned_service_organizer',
      desc: '',
      args: [],
    );
  }

  /// `removed`
  String get chat_banned_service_removed {
    return Intl.message(
      'removed',
      name: 'chat_banned_service_removed',
      desc: '',
      args: [],
    );
  }

  /// `granted`
  String get chat_banned_service_added {
    return Intl.message(
      'granted',
      name: 'chat_banned_service_added',
      desc: '',
      args: [],
    );
  }

  /// `your right to use the chat of the game.`
  String get chat_banned_service_chat_right {
    return Intl.message(
      'your right to use the chat of the game.',
      name: 'chat_banned_service_chat_right',
      desc: '',
      args: [],
    );
  }

  /// `New message`
  String get new_message {
    return Intl.message('New message', name: 'new_message', desc: '', args: []);
  }

  /// `Watermelon`
  String get information_profile_watermelon_theme {
    return Intl.message(
      'Watermelon',
      name: 'information_profile_watermelon_theme',
      desc: '',
      args: [],
    );
  }

  /// `Team 101`
  String get home_page_team {
    return Intl.message('Team 101', name: 'home_page_team', desc: '', args: []);
  }

  /// `Lyne Dahan, Jérôme Fréchette, Skander Hellal, Philippe Martin, John Abou Nakoul, Yacine Barka`
  String get home_page_team_members {
    return Intl.message(
      'Lyne Dahan, Jérôme Fréchette, Skander Hellal, Philippe Martin, John Abou Nakoul, Yacine Barka',
      name: 'home_page_team_members',
      desc: '',
      args: [],
    );
  }

  /// `Join a game`
  String get home_page_join_game {
    return Intl.message(
      'Join a game',
      name: 'home_page_join_game',
      desc: '',
      args: [],
    );
  }

  /// `Create a game`
  String get home_page_create_game {
    return Intl.message(
      'Create a game',
      name: 'home_page_create_game',
      desc: '',
      args: [],
    );
  }

  /// `Create a Game`
  String get header_create_game_button {
    return Intl.message(
      'Create a Game',
      name: 'header_create_game_button',
      desc: '',
      args: [],
    );
  }

  /// `Join a Game`
  String get header_join_game_button {
    return Intl.message(
      'Join a Game',
      name: 'header_join_game_button',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get header_library_button {
    return Intl.message(
      'Library',
      name: 'header_library_button',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get header_leaderboard_button {
    return Intl.message(
      'Leaderboard',
      name: 'header_leaderboard_button',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get header_users_button {
    return Intl.message(
      'Users',
      name: 'header_users_button',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get header_shop_button {
    return Intl.message('Shop', name: 'header_shop_button', desc: '', args: []);
  }

  /// `Avatar`
  String get header_avatar_button {
    return Intl.message(
      'Avatar',
      name: 'header_avatar_button',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get header_profile_button {
    return Intl.message(
      'Profile',
      name: 'header_profile_button',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get header_game_history_button {
    return Intl.message(
      'History',
      name: 'header_game_history_button',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get header_logout_button {
    return Intl.message(
      'Logout',
      name: 'header_logout_button',
      desc: '',
      args: [],
    );
  }

  /// `Buy a Hint : {price} coins`
  String hint_widget_buy_hint(Object price) {
    return Intl.message(
      'Buy a Hint : $price coins',
      name: 'hint_widget_buy_hint',
      desc: '',
      args: [price],
    );
  }

  /// `Best Streak`
  String get best_streak {
    return Intl.message('Best Streak', name: 'best_streak', desc: '', args: []);
  }

  /// `Current Streak`
  String get current_streak {
    return Intl.message(
      'Current Streak',
      name: 'current_streak',
      desc: '',
      args: [],
    );
  }

  /// `Games Won`
  String get games_won {
    return Intl.message('Games Won', name: 'games_won', desc: '', args: []);
  }

  /// `Total Points`
  String get total_points {
    return Intl.message(
      'Total Points',
      name: 'total_points',
      desc: '',
      args: [],
    );
  }

  /// `Questions Survived`
  String get questions_survived {
    return Intl.message(
      'Questions Survived',
      name: 'questions_survived',
      desc: '',
      args: [],
    );
  }

  /// `Coins Spent`
  String get coins_spent {
    return Intl.message('Coins Spent', name: 'coins_spent', desc: '', args: []);
  }

  /// `Game Time`
  String get game_time {
    return Intl.message('Game Time', name: 'game_time', desc: '', args: []);
  }

  /// `EXP`
  String get XP {
    return Intl.message('EXP', name: 'XP', desc: '', args: []);
  }

  /// `Quiz & Feedback`
  String get result_view_quiz_stats {
    return Intl.message(
      'Quiz & Feedback',
      name: 'result_view_quiz_stats',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get result_view_leaderboard {
    return Intl.message(
      'Leaderboard',
      name: 'result_view_leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get result_view_achivements {
    return Intl.message(
      'Achievements',
      name: 'result_view_achivements',
      desc: '',
      args: [],
    );
  }

  /// `Game Loots`
  String get result_view_game_loot {
    return Intl.message(
      'Game Loots',
      name: 'result_view_game_loot',
      desc: '',
      args: [],
    );
  }

  /// `Answer Streak Challenge`
  String get challenge_answer_streak_title {
    return Intl.message(
      'Answer Streak Challenge',
      name: 'challenge_answer_streak_title',
      desc: '',
      args: [],
    );
  }

  /// `To complete this challenge, you need to answer 3 questions correctly in a row.`
  String get challenge_answer_streak_description {
    return Intl.message(
      'To complete this challenge, you need to answer 3 questions correctly in a row.',
      name: 'challenge_answer_streak_description',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! You answered 3 questions correctly in a row!`
  String get challenge_answer_streak_success {
    return Intl.message(
      'Congratulations! You answered 3 questions correctly in a row!',
      name: 'challenge_answer_streak_success',
      desc: '',
      args: [],
    );
  }

  /// `You didn't manage to answer 3 questions correctly in a row.`
  String get challenge_answer_streak_failure {
    return Intl.message(
      'You didn\'t manage to answer 3 questions correctly in a row.',
      name: 'challenge_answer_streak_failure',
      desc: '',
      args: [],
    );
  }

  /// `Fastest Challenge`
  String get challenge_fastest_title {
    return Intl.message(
      'Fastest Challenge',
      name: 'challenge_fastest_title',
      desc: '',
      args: [],
    );
  }

  /// `To complete this challenge, your average answer time must be under 5 seconds.`
  String get challenge_fastest_description {
    return Intl.message(
      'To complete this challenge, your average answer time must be under 5 seconds.',
      name: 'challenge_fastest_description',
      desc: '',
      args: [],
    );
  }

  /// `Amazing! Your average response time was under 5 seconds!`
  String get challenge_fastest_success {
    return Intl.message(
      'Amazing! Your average response time was under 5 seconds!',
      name: 'challenge_fastest_success',
      desc: '',
      args: [],
    );
  }

  /// `Your average response time was above 5 seconds.`
  String get challenge_fastest_failure {
    return Intl.message(
      'Your average response time was above 5 seconds.',
      name: 'challenge_fastest_failure',
      desc: '',
      args: [],
    );
  }

  /// `Bonus Collector Challenge`
  String get challenge_bonus_collector_title {
    return Intl.message(
      'Bonus Collector Challenge',
      name: 'challenge_bonus_collector_title',
      desc: '',
      args: [],
    );
  }

  /// `To complete this challenge, you need to get at least half of the possible bonus in this game.`
  String get challenge_bonus_collector_description {
    return Intl.message(
      'To complete this challenge, you need to get at least half of the possible bonus in this game.',
      name: 'challenge_bonus_collector_description',
      desc: '',
      args: [],
    );
  }

  /// `Great job! You collected more than half of the possible bonuses!`
  String get challenge_bonus_collector_success {
    return Intl.message(
      'Great job! You collected more than half of the possible bonuses!',
      name: 'challenge_bonus_collector_success',
      desc: '',
      args: [],
    );
  }

  /// `You didn't collect enough bonuses to complete the challenge.`
  String get challenge_bonus_collector_failure {
    return Intl.message(
      'You didn\'t collect enough bonuses to complete the challenge.',
      name: 'challenge_bonus_collector_failure',
      desc: '',
      args: [],
    );
  }

  /// `Question Master Challenge`
  String get challenge_question_master_title {
    return Intl.message(
      'Question Master Challenge',
      name: 'challenge_question_master_title',
      desc: '',
      args: [],
    );
  }

  /// `To complete this challenge, you need to answer correctly every {questionType}.`
  String challenge_question_master_description(Object questionType) {
    return Intl.message(
      'To complete this challenge, you need to answer correctly every $questionType.',
      name: 'challenge_question_master_description',
      desc: '',
      args: [questionType],
    );
  }

  /// `Excellent! You answered all {questionType} correctly!`
  String challenge_question_master_success(Object questionType) {
    return Intl.message(
      'Excellent! You answered all $questionType correctly!',
      name: 'challenge_question_master_success',
      desc: '',
      args: [questionType],
    );
  }

  /// `You didn't answer all {questionType} correctly.`
  String challenge_question_master_failure(Object questionType) {
    return Intl.message(
      'You didn\'t answer all $questionType correctly.',
      name: 'challenge_question_master_failure',
      desc: '',
      args: [questionType],
    );
  }

  /// `Never Last Challenge`
  String get challenge_never_last_title {
    return Intl.message(
      'Never Last Challenge',
      name: 'challenge_never_last_title',
      desc: '',
      args: [],
    );
  }

  /// `To complete this challenge, you need to never be the last player to answer a question.`
  String get challenge_never_last_description {
    return Intl.message(
      'To complete this challenge, you need to never be the last player to answer a question.',
      name: 'challenge_never_last_description',
      desc: '',
      args: [],
    );
  }

  /// `Perfect! You were never the last to answer!`
  String get challenge_never_last_success {
    return Intl.message(
      'Perfect! You were never the last to answer!',
      name: 'challenge_never_last_success',
      desc: '',
      args: [],
    );
  }

  /// `You were the last to answer at least once.`
  String get challenge_never_last_failure {
    return Intl.message(
      'You were the last to answer at least once.',
      name: 'challenge_never_last_failure',
      desc: '',
      args: [],
    );
  }

  /// `Status: {status}`
  String challenge_status(Object status) {
    return Intl.message(
      'Status: $status',
      name: 'challenge_status',
      desc: '',
      args: [status],
    );
  }

  /// `Price: {price} coins`
  String challenge_price(Object price) {
    return Intl.message(
      'Price: $price coins',
      name: 'challenge_price',
      desc: '',
      args: [price],
    );
  }

  /// `Game Menu`
  String get header_game_menu {
    return Intl.message(
      'Game Menu',
      name: 'header_game_menu',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get your_stats {
    return Intl.message('Achievements', name: 'your_stats', desc: '', args: []);
  }

  /// `Your Shop`
  String get shop_title {
    return Intl.message('Your Shop', name: 'shop_title', desc: '', args: []);
  }

  /// `Price:`
  String get price {
    return Intl.message('Price:', name: 'price', desc: '', args: []);
  }

  /// `coins`
  String get coins {
    return Intl.message('coins', name: 'coins', desc: '', args: []);
  }

  /// `No items available for this category.`
  String get no_items {
    return Intl.message(
      'No items available for this category.',
      name: 'no_items',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Avatar`
  String get avatar {
    return Intl.message('Avatar', name: 'avatar', desc: '', args: []);
  }

  /// `Background`
  String get background {
    return Intl.message('Background', name: 'background', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Strawberry Background`
  String get strawberry_background {
    return Intl.message(
      'Strawberry Background',
      name: 'strawberry_background',
      desc: '',
      args: [],
    );
  }

  /// `Blueberry Background`
  String get blueberry_background {
    return Intl.message(
      'Blueberry Background',
      name: 'blueberry_background',
      desc: '',
      args: [],
    );
  }

  /// `Orange Background`
  String get orange_background {
    return Intl.message(
      'Orange Background',
      name: 'orange_background',
      desc: '',
      args: [],
    );
  }

  /// `Watermelon Background`
  String get watermelon_background {
    return Intl.message(
      'Watermelon Background',
      name: 'watermelon_background',
      desc: '',
      args: [],
    );
  }

  /// `Lemon Background`
  String get lemon_background {
    return Intl.message(
      'Lemon Background',
      name: 'lemon_background',
      desc: '',
      args: [],
    );
  }

  /// `Strawberry Theme`
  String get strawberry_theme {
    return Intl.message(
      'Strawberry Theme',
      name: 'strawberry_theme',
      desc: '',
      args: [],
    );
  }

  /// `Blueberry Theme`
  String get blueberry_theme {
    return Intl.message(
      'Blueberry Theme',
      name: 'blueberry_theme',
      desc: '',
      args: [],
    );
  }

  /// `Watermelon Theme`
  String get watermelon_theme {
    return Intl.message(
      'Watermelon Theme',
      name: 'watermelon_theme',
      desc: '',
      args: [],
    );
  }

  /// `Premium Lemon Avatar`
  String get premium_lemon_avatar {
    return Intl.message(
      'Premium Lemon Avatar',
      name: 'premium_lemon_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Premium Orange Avatar`
  String get premium_orange_avatar {
    return Intl.message(
      'Premium Orange Avatar',
      name: 'premium_orange_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Golden Blueberry Avatar`
  String get golden_blueberry_avatar {
    return Intl.message(
      'Golden Blueberry Avatar',
      name: 'golden_blueberry_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Golden Lemon Avatar`
  String get golden_lemon_avatar {
    return Intl.message(
      'Golden Lemon Avatar',
      name: 'golden_lemon_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Golden Watermelon Avatar`
  String get golden_watermelon_avatar {
    return Intl.message(
      'Golden Watermelon Avatar',
      name: 'golden_watermelon_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message('Buy', name: 'buy', desc: '', args: []);
  }

  /// `Bought`
  String get bought {
    return Intl.message('Bought', name: 'bought', desc: '', args: []);
  }

  /// `Coins`
  String get game_loot_coins {
    return Intl.message('Coins', name: 'game_loot_coins', desc: '', args: []);
  }

  /// `Coins Gained`
  String get game_loot_coins_gained {
    return Intl.message(
      'Coins Gained',
      name: 'game_loot_coins_gained',
      desc: '',
      args: [],
    );
  }

  /// `Challenge Rewards`
  String get game_loot_challenge_coins_gained {
    return Intl.message(
      'Challenge Rewards',
      name: 'game_loot_challenge_coins_gained',
      desc: '',
      args: [],
    );
  }

  /// `Entry Fee`
  String get game_loot_coins_paid {
    return Intl.message(
      'Entry Fee',
      name: 'game_loot_coins_paid',
      desc: '',
      args: [],
    );
  }

  /// `Experience`
  String get game_loot_experience {
    return Intl.message(
      'Experience',
      name: 'game_loot_experience',
      desc: '',
      args: [],
    );
  }

  /// `Experience Points`
  String get game_loot_xp_label {
    return Intl.message(
      'Experience Points',
      name: 'game_loot_xp_label',
      desc: '',
      args: [],
    );
  }

  /// `Experience Gained`
  String get game_loot_xp_gained {
    return Intl.message(
      'Experience Gained',
      name: 'game_loot_xp_gained',
      desc: '',
      args: [],
    );
  }

  /// `You leveled up!`
  String get game_loot_level_up {
    return Intl.message(
      'You leveled up!',
      name: 'game_loot_level_up',
      desc: '',
      args: [],
    );
  }

  /// `You won the game pot of {price} coins!`
  String game_loot_won_game_pot(Object price) {
    return Intl.message(
      'You won the game pot of $price coins!',
      name: 'game_loot_won_game_pot',
      desc: '',
      args: [price],
    );
  }

  /// `Your score`
  String get game_score_your_score {
    return Intl.message(
      'Your score',
      name: 'game_score_your_score',
      desc: '',
      args: [],
    );
  }

  /// `Eliminated!`
  String get elimination_modal_title {
    return Intl.message(
      'Eliminated!',
      name: 'elimination_modal_title',
      desc: 'Title shown in the elimination modal when a player is eliminated',
      args: [],
    );
  }

  /// `Previous`
  String get game_result_previous_slide_button {
    return Intl.message(
      'Previous',
      name: 'game_result_previous_slide_button',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get game_result_next_slide_button {
    return Intl.message(
      'Next',
      name: 'game_result_next_slide_button',
      desc: '',
      args: [],
    );
  }

  /// `Survival Mode`
  String get survival_best_score_title {
    return Intl.message(
      'Survival Mode',
      name: 'survival_best_score_title',
      desc: '',
      args: [],
    );
  }

  /// `Current Score`
  String get survival_best_score_current_score {
    return Intl.message(
      'Current Score',
      name: 'survival_best_score_current_score',
      desc: '',
      args: [],
    );
  }

  /// `Best Score`
  String get survival_best_score_best_score {
    return Intl.message(
      'Best Score',
      name: 'survival_best_score_best_score',
      desc: '',
      args: [],
    );
  }

  /// `Not enough balance to create this game`
  String get game_creation_not_enough_balance {
    return Intl.message(
      'Not enough balance to create this game',
      name: 'game_creation_not_enough_balance',
      desc: '',
      args: [],
    );
  }

  /// `Classic Mode`
  String get game_creation_classic_mode {
    return Intl.message(
      'Classic Mode',
      name: 'game_creation_classic_mode',
      desc: '',
      args: [],
    );
  }

  /// `Choose a quiz and compete with other players`
  String get game_creation_classic_description {
    return Intl.message(
      'Choose a quiz and compete with other players',
      name: 'game_creation_classic_description',
      desc: '',
      args: [],
    );
  }

  /// `Elimination Mode`
  String get game_creation_elimination_mode {
    return Intl.message(
      'Elimination Mode',
      name: 'game_creation_elimination_mode',
      desc: '',
      args: [],
    );
  }

  /// `Players are eliminated after each question`
  String get game_creation_elimination_description {
    return Intl.message(
      'Players are eliminated after each question',
      name: 'game_creation_elimination_description',
      desc: '',
      args: [],
    );
  }

  /// `Survival Mode`
  String get game_creation_survival_mode {
    return Intl.message(
      'Survival Mode',
      name: 'game_creation_survival_mode',
      desc: '',
      args: [],
    );
  }

  /// `Answer questions as fast as possible to survive`
  String get game_creation_survival_description {
    return Intl.message(
      'Answer questions as fast as possible to survive',
      name: 'game_creation_survival_description',
      desc: '',
      args: [],
    );
  }

  /// `Game Options`
  String get game_creation_game_options {
    return Intl.message(
      'Game Options',
      name: 'game_creation_game_options',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get quiz_detail_component_description {
    return Intl.message(
      'Description',
      name: 'quiz_detail_component_description',
      desc: '',
      args: [],
    );
  }

  /// `Time to respond:`
  String get quiz_detail_component_time_to_respond {
    return Intl.message(
      'Time to respond:',
      name: 'quiz_detail_component_time_to_respond',
      desc: '',
      args: [],
    );
  }

  /// `Number of questions:`
  String get quiz_detail_component_nb_questions {
    return Intl.message(
      'Number of questions:',
      name: 'quiz_detail_component_nb_questions',
      desc: '',
      args: [],
    );
  }

  /// `Created by:`
  String get quiz_detail_component_creator {
    return Intl.message(
      'Created by:',
      name: 'quiz_detail_component_creator',
      desc: '',
      args: [],
    );
  }

  /// `List of Questions`
  String get game_creation_question_list {
    return Intl.message(
      'List of Questions',
      name: 'game_creation_question_list',
      desc: '',
      args: [],
    );
  }

  /// `Available Questions`
  String get game_creation_available_questions {
    return Intl.message(
      'Available Questions',
      name: 'game_creation_available_questions',
      desc: '',
      args: [],
    );
  }

  /// `Number of Questions: `
  String get game_creation_question_count {
    return Intl.message(
      'Number of Questions: ',
      name: 'game_creation_question_count',
      desc: '',
      args: [],
    );
  }

  /// `Public Game`
  String get game_creation_public_game {
    return Intl.message(
      'Public Game',
      name: 'game_creation_public_game',
      desc: '',
      args: [],
    );
  }

  /// `Friends Only`
  String get game_creation_friends_only_game {
    return Intl.message(
      'Friends Only',
      name: 'game_creation_friends_only_game',
      desc: '',
      args: [],
    );
  }

  /// `You need at least 5 questions to create a game`
  String get game_creation_not_enough_questions {
    return Intl.message(
      'You need at least 5 questions to create a game',
      name: 'game_creation_not_enough_questions',
      desc: '',
      args: [],
    );
  }

  /// `You can't select more than {count} questions`
  String game_creation_max_questions(Object count) {
    return Intl.message(
      'You can\'t select more than $count questions',
      name: 'game_creation_max_questions',
      desc: '',
      args: [count],
    );
  }

  /// `Use the controls below to adjust the number of questions for your game`
  String get choose_number_header {
    return Intl.message(
      'Use the controls below to adjust the number of questions for your game',
      name: 'choose_number_header',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get notification_close_button {
    return Intl.message(
      'Close',
      name: 'notification_close_button',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to logout?`
  String get header_confirm_logout {
    return Intl.message(
      'Do you really want to logout?',
      name: 'header_confirm_logout',
      desc: '',
      args: [],
    );
  }

  /// `Player`
  String get player {
    return Intl.message('Player', name: 'player', desc: '', args: []);
  }

  /// `Item Locked`
  String get locked_item_title {
    return Intl.message(
      'Item Locked',
      name: 'locked_item_title',
      desc: '',
      args: [],
    );
  }

  /// `Visit the shop to buy items.`
  String get locked_item_message {
    return Intl.message(
      'Visit the shop to buy items.',
      name: 'locked_item_message',
      desc: '',
      args: [],
    );
  }

  /// `Go to the shop`
  String get go_to_shop {
    return Intl.message(
      'Go to the shop',
      name: 'go_to_shop',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
