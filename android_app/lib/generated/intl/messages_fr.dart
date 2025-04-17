// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(price) => "Prix : ${price} pièces";

  static String m1(questionType) =>
      "Pour compléter ce défi, vous devez répondre correctement à chaque ${questionType}.";

  static String m2(questionType) =>
      "Vous n\'avez pas répondu correctement à toutes les ${questionType}.";

  static String m3(questionType) =>
      "Excellent ! Vous avez répondu correctement à toutes les ${questionType} !";

  static String m4(status) => "Statut : ${status}";

  static String m5(username) => "Ce canal est réservé aux amis de ${username}";

  static String m6(chatName) =>
      "Voulez-vous vraiment supprimer le canal ${chatName} ?";

  static String m7(chatName) =>
      "Voulez-vous vraiment quitter le canal ${chatName} ?";

  static String m8(count) => "${count} nouvelles demandes d\'ami";

  static String m9(username) => "Nouvelle demande d\'ami de ${username}";

  static String m10(username) => "${username} a accepté votre demande d\'ami";

  static String m11(count) =>
      "Vous ne pouvez pas sélectionner plus de ${count} questions";

  static String m12(amount) =>
      "Vous devez payer ${amount} pièces pour rejoindre cette partie";

  static String m13(price) =>
      "Vous avez gagné le pot de jeu de ${price} pièces !";

  static String m14(score) => "Vous avez obtenu ${score} points grâce au bonus";

  static String m15(percent, points) =>
      "Vous avez obtenu ${percent}% soit ${points} points";

  static String m16(score) => "Vous avez obtenu ${score} points";

  static String m17(price) => "Acheter un indice : ${price} pièces";

  static String m18(value) => "La bonne réponse est: ${value}";

  static String m19(value, tolerance) =>
      "La bonne réponse est: ${value} ± ${tolerance}";

  static String m20(value) => "${value}";

  static String m21(value) => "${value}";

  static String m22(count) => "Contient ${count} questions";

  static String m23(description) => "Description: ${description}";

  static String m24(duration) => "Temps pour répondre: ${duration}s";

  static String m25(date) => "Dernière modification: ${date}";

  static String m26(owner) => "Créateur: ${owner}";

  static String m27(count) => "Nombre de questions: ${count}";

  static String m28(title) => "Titre: ${title}";

  static String m29(count) => "Vous avez sélectionné ${count} questions";

  static String m30(totalQuestions) =>
      "Contient de 5 à ${totalQuestions} questions";

  static String m31(questionSurvived, questionCount) =>
      "Vous avez survécu aux ${questionSurvived} premières questions sur ${questionCount}";

  static String m32(username) => "${username} a rejoint";

  static String m33(username) => "${username} a quitté";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AccountValidation_alreadyLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Ce compte est déjà connecté",
    ),
    "AccountValidation_avatarRequired": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner un avatar",
    ),
    "AccountValidation_emailInvalid": MessageLookupByLibrary.simpleMessage(
      "L\'email doit respecter la forme exemple@domaine.com",
    ),
    "AccountValidation_emailRequired": MessageLookupByLibrary.simpleMessage(
      "L\'email est requis",
    ),
    "AccountValidation_emailTaken": MessageLookupByLibrary.simpleMessage(
      "Cette adresse courriel est déjà utilisée",
    ),
    "AccountValidation_incorrectCredentials":
        MessageLookupByLibrary.simpleMessage(
          "Nom d\'utilisateur ou mot de passe incorrect",
        ),
    "AccountValidation_missingFields": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur et le mot de passe sont requis",
    ),
    "AccountValidation_passwordInvalid": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe ne peut contenir que des lettres, des chiffres et des caractères spéciaux",
    ),
    "AccountValidation_passwordLength": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe doit comporter au moins 5 caractères",
    ),
    "AccountValidation_passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "Les mots de passe ne correspondent pas",
    ),
    "AccountValidation_passwordRequired": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe est requis",
    ),
    "AccountValidation_termsRequired": MessageLookupByLibrary.simpleMessage(
      "Veuillez accepter les termes et conditions",
    ),
    "AccountValidation_unknownError": MessageLookupByLibrary.simpleMessage(
      "Une erreur inconnue s\'est produite",
    ),
    "AccountValidation_updateError": MessageLookupByLibrary.simpleMessage(
      "Échec de la mise à jour du nom d\'utilisateur",
    ),
    "AccountValidation_usernameExists": MessageLookupByLibrary.simpleMessage(
      "Ce nom d\'utilisateur est déjà pris",
    ),
    "AccountValidation_usernameInvalid": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur est invalide. Il ne peut contenir que des lettres, des chiffres et des underscores",
    ),
    "AccountValidation_usernameLength": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur doit comporter entre 4 et 12 caractères",
    ),
    "AccountValidation_usernameRequired": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur est requis",
    ),
    "AccountValidation_usernameSystem": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur ne peut pas contenir de mots réservés par le système",
    ),
    "AccountValidation_usernameTaken": MessageLookupByLibrary.simpleMessage(
      "Ce nom d\'utilisateur est déjà pris",
    ),
    "Camera": MessageLookupByLibrary.simpleMessage("Caméra"),
    "HomeCarousel_BestSurvivalScore": MessageLookupByLibrary.simpleMessage(
      "Meilleur score de survie",
    ),
    "HomeCarousel_BestWinStreak": MessageLookupByLibrary.simpleMessage(
      "Meilleure série de victoires",
    ),
    "HomeCarousel_HighestCurrentWinStreak":
        MessageLookupByLibrary.simpleMessage(
          "Plus grande série de victoires actuelle",
        ),
    "HomeCarousel_LongestGameTime": MessageLookupByLibrary.simpleMessage(
      "Temps de jeu le plus long",
    ),
    "HomeCarousel_MostCoinsSpent": MessageLookupByLibrary.simpleMessage(
      "Plus de pièces dépensées",
    ),
    "HomeCarousel_MostPoints": MessageLookupByLibrary.simpleMessage(
      "Plus de points",
    ),
    "HomeCarousel_MostWins": MessageLookupByLibrary.simpleMessage(
      "Plus de victoires",
    ),
    "HomeCarousel_NoDataAvailable": MessageLookupByLibrary.simpleMessage(
      "Aucune donnée disponible",
    ),
    "Or": MessageLookupByLibrary.simpleMessage("OU"),
    "Upload": MessageLookupByLibrary.simpleMessage("Téléverser"),
    "XP": MessageLookupByLibrary.simpleMessage("EXP"),
    "achievements": MessageLookupByLibrary.simpleMessage("Accomplissements"),
    "add_bot": MessageLookupByLibrary.simpleMessage("Ajouter un bot"),
    "all": MessageLookupByLibrary.simpleMessage("Tout"),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Vous avez déjà un compte ?",
    ),
    "avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
    "background": MessageLookupByLibrary.simpleMessage("Fond"),
    "best_streak": MessageLookupByLibrary.simpleMessage(
      "Meilleure séquence VIC",
    ),
    "blueberry_background": MessageLookupByLibrary.simpleMessage("Fond Bleuet"),
    "blueberry_theme": MessageLookupByLibrary.simpleMessage("Thème Bleuet"),
    "bot_difficulty_beginner": MessageLookupByLibrary.simpleMessage("Débutant"),
    "bot_difficulty_expert": MessageLookupByLibrary.simpleMessage("Expert"),
    "bot_difficulty_intermediate": MessageLookupByLibrary.simpleMessage(
      "Intermédiaire",
    ),
    "bought": MessageLookupByLibrary.simpleMessage("Acheté"),
    "buy": MessageLookupByLibrary.simpleMessage("Acheter"),
    "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "challenge_answer_streak_description": MessageLookupByLibrary.simpleMessage(
      "Pour compléter ce défi, vous devez répondre correctement à 3 questions consécutives.",
    ),
    "challenge_answer_streak_failure": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas réussi à répondre correctement à 3 questions consécutives.",
    ),
    "challenge_answer_streak_success": MessageLookupByLibrary.simpleMessage(
      "Félicitations ! Vous avez répondu correctement à 3 questions consécutives !",
    ),
    "challenge_answer_streak_title": MessageLookupByLibrary.simpleMessage(
      "Défi de Série de Réponses",
    ),
    "challenge_bonus_collector_description": MessageLookupByLibrary.simpleMessage(
      "Pour compléter ce défi, vous devez obtenir au moins la moitié des bonus possibles dans cette partie.",
    ),
    "challenge_bonus_collector_failure": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas collecté assez de bonus pour compléter le défi.",
    ),
    "challenge_bonus_collector_success": MessageLookupByLibrary.simpleMessage(
      "Bravo ! Vous avez collecté plus de la moitié des bonus possibles !",
    ),
    "challenge_bonus_collector_title": MessageLookupByLibrary.simpleMessage(
      "Défi de Collectionneur de Bonus",
    ),
    "challenge_fastest_description": MessageLookupByLibrary.simpleMessage(
      "Pour compléter ce défi, votre temps de réponse moyen doit être inférieur à 5 secondes.",
    ),
    "challenge_fastest_failure": MessageLookupByLibrary.simpleMessage(
      "Votre temps de réponse moyen était supérieur à 5 secondes.",
    ),
    "challenge_fastest_success": MessageLookupByLibrary.simpleMessage(
      "Impressionnant ! Votre temps de réponse moyen était inférieur à 5 secondes !",
    ),
    "challenge_fastest_title": MessageLookupByLibrary.simpleMessage(
      "Défi de Rapidité",
    ),
    "challenge_never_last_description": MessageLookupByLibrary.simpleMessage(
      "Pour compléter ce défi, vous ne devez jamais être le dernier joueur à répondre à une question.",
    ),
    "challenge_never_last_failure": MessageLookupByLibrary.simpleMessage(
      "Vous avez été le dernier à répondre au moins une fois.",
    ),
    "challenge_never_last_success": MessageLookupByLibrary.simpleMessage(
      "Parfait ! Vous n\'avez jamais été le dernier à répondre !",
    ),
    "challenge_never_last_title": MessageLookupByLibrary.simpleMessage(
      "Défi de Jamais Dernier",
    ),
    "challenge_price": m0,
    "challenge_question_master_description": m1,
    "challenge_question_master_failure": m2,
    "challenge_question_master_success": m3,
    "challenge_question_master_title": MessageLookupByLibrary.simpleMessage(
      "Défi de Maître des Questions",
    ),
    "challenge_status": m4,
    "change_avatar": MessageLookupByLibrary.simpleMessage(
      "Changer votre avatar",
    ),
    "chat_banned_service_added": MessageLookupByLibrary.simpleMessage("alloué"),
    "chat_banned_service_chat_right": MessageLookupByLibrary.simpleMessage(
      "votre droit d\'utiliser le chat de la partie.",
    ),
    "chat_banned_service_organizer": MessageLookupByLibrary.simpleMessage(
      "L\'organisateur a",
    ),
    "chat_banned_service_removed": MessageLookupByLibrary.simpleMessage(
      "retiré",
    ),
    "chat_friend_only_response": m5,
    "chat_name_empty_error": MessageLookupByLibrary.simpleMessage(
      "Le nom du canal ne peut pas être vide.",
    ),
    "chat_name_placeholder": MessageLookupByLibrary.simpleMessage(
      "Nom du canal",
    ),
    "chat_name_restricted_error": MessageLookupByLibrary.simpleMessage(
      "Le nom du canal est réservé.",
    ),
    "chat_name_taken_error": MessageLookupByLibrary.simpleMessage(
      "Le nom du canal est déjà pris.",
    ),
    "chatrooms": MessageLookupByLibrary.simpleMessage("canaux"),
    "choose_avatar": MessageLookupByLibrary.simpleMessage(
      "Choississez un avatar",
    ),
    "choose_number_header": MessageLookupByLibrary.simpleMessage(
      "Utilisez les controles ci-dessous pour ajuster le nombre de questions pour votre jeu",
    ),
    "coins": MessageLookupByLibrary.simpleMessage("pièces"),
    "coins_spent": MessageLookupByLibrary.simpleMessage("Pièces dépensées"),
    "confirm_delete_chat": m6,
    "confirm_leave_chat": m7,
    "confirm_password_label": MessageLookupByLibrary.simpleMessage(
      "Confirmer le mot de passe",
    ),
    "continue_game": MessageLookupByLibrary.simpleMessage("Suivant"),
    "create": MessageLookupByLibrary.simpleMessage("Créer"),
    "create_account": MessageLookupByLibrary.simpleMessage("Créez-en un"),
    "create_chatroom": MessageLookupByLibrary.simpleMessage("Créer un canal"),
    "current_level": MessageLookupByLibrary.simpleMessage("Niveau"),
    "current_streak": MessageLookupByLibrary.simpleMessage(
      "Séquence VIC courants",
    ),
    "delete_chat_title": MessageLookupByLibrary.simpleMessage(
      "Supprimer un Canal",
    ),
    "elimination_modal": MessageLookupByLibrary.simpleMessage("Éliminé"),
    "elimination_modal_title": MessageLookupByLibrary.simpleMessage("Éliminé!"),
    "email": MessageLookupByLibrary.simpleMessage("Adresse courriel"),
    "email_label": MessageLookupByLibrary.simpleMessage("Courriel"),
    "enter_answer": MessageLookupByLibrary.simpleMessage(
      "Entrez votre réponse",
    ),
    "enter_game_code": MessageLookupByLibrary.simpleMessage(
      "Entrez le code de la partie: ",
    ),
    "error_avatar": MessageLookupByLibrary.simpleMessage(
      "Vous devez choisir un avatar pour poursuivre.",
    ),
    "error_email_invalid": MessageLookupByLibrary.simpleMessage(
      "L\'email doit respecter la forme exemple@domaine.com",
    ),
    "error_email_required": MessageLookupByLibrary.simpleMessage(
      "L\'email est requis",
    ),
    "error_icon_label": MessageLookupByLibrary.simpleMessage("Erreur"),
    "error_joining_game": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la tentative de rejoindre la partie",
    ),
    "error_password_invalid": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe ne peut contenir que des lettres, des chiffres et des caractères spéciaux",
    ),
    "error_password_length": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe doit comporter au moins 5 caractères",
    ),
    "error_password_required": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe est requis",
    ),
    "error_username_invalid": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur est invalide. Il ne peut contenir que des lettres, des chiffres et des underscores",
    ),
    "error_username_length": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur doit comporter entre 4 et 12 caractères",
    ),
    "error_username_required": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur est requis",
    ),
    "error_username_system": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur ne peut pas contenir de mots réservés par le système",
    ),
    "experience": MessageLookupByLibrary.simpleMessage("EXP"),
    "filter_placeholder": MessageLookupByLibrary.simpleMessage("Filtrer"),
    "friend_page": MessageLookupByLibrary.simpleMessage("Amis"),
    "friend_request_control_accept": MessageLookupByLibrary.simpleMessage(
      "Accepter",
    ),
    "friend_request_control_add_friend": MessageLookupByLibrary.simpleMessage(
      "Ajouter un ami",
    ),
    "friend_request_control_add_yourself_error":
        MessageLookupByLibrary.simpleMessage(
          "Vous ne pouvez pas vous ajouter en ami",
        ),
    "friend_request_control_delete_friend":
        MessageLookupByLibrary.simpleMessage("Supprimer l\'ami"),
    "friend_request_control_delete_request":
        MessageLookupByLibrary.simpleMessage("Supprimer la demande"),
    "friend_request_control_friend": MessageLookupByLibrary.simpleMessage(
      "Ami",
    ),
    "friend_request_control_receive_request":
        MessageLookupByLibrary.simpleMessage("Demande reçue"),
    "friend_request_control_refuse": MessageLookupByLibrary.simpleMessage(
      "Refuser",
    ),
    "friend_request_control_send_request": MessageLookupByLibrary.simpleMessage(
      "Demande envoyée",
    ),
    "friend_request_tooltips_accept_request":
        MessageLookupByLibrary.simpleMessage("Accepter la demande"),
    "friend_request_tooltips_decline_request":
        MessageLookupByLibrary.simpleMessage("Refuser la demande"),
    "friend_request_tooltips_revoke_request":
        MessageLookupByLibrary.simpleMessage("Révoquer la demande"),
    "friend_request_tooltips_send_request":
        MessageLookupByLibrary.simpleMessage("Envoyer une demande d\'ami"),
    "friend_requests_add_friend": MessageLookupByLibrary.simpleMessage(
      "Ajouter un ami",
    ),
    "friend_requests_answer_request": MessageLookupByLibrary.simpleMessage(
      "Répondre à la demande",
    ),
    "friend_requests_multiple_requests": m8,
    "friend_requests_new_request_from": m9,
    "friend_requests_no_received_requests":
        MessageLookupByLibrary.simpleMessage(
          "Vous n\'avez pas de demandes d\'ami en attente.",
        ),
    "friend_requests_no_sent_requests": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas encore envoyé de demandes d\'ami.",
    ),
    "friend_requests_received_requests": MessageLookupByLibrary.simpleMessage(
      "Demandes reçues",
    ),
    "friend_requests_request_accepted": m10,
    "friend_requests_revoke_sent_request": MessageLookupByLibrary.simpleMessage(
      "Révoquer la demande",
    ),
    "friend_requests_sent_requests": MessageLookupByLibrary.simpleMessage(
      "Demandes envoyées",
    ),
    "friend_requests_title": MessageLookupByLibrary.simpleMessage(
      "Demandes d\'ami",
    ),
    "friends": MessageLookupByLibrary.simpleMessage("Amis"),
    "friends_list_find_new_friends": MessageLookupByLibrary.simpleMessage(
      "Trouver de nouveaux amis",
    ),
    "friends_list_no_friends": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas encore d\'amis. Commencez à vous connecter !",
    ),
    "friends_list_title": MessageLookupByLibrary.simpleMessage("Amis"),
    "friends_only": MessageLookupByLibrary.simpleMessage("Amis seulement"),
    "game_chat_name": MessageLookupByLibrary.simpleMessage("Partie"),
    "game_creation_available_questions": MessageLookupByLibrary.simpleMessage(
      "Questions disponibles",
    ),
    "game_creation_classic_description": MessageLookupByLibrary.simpleMessage(
      "Jouez à un quiz spécifique et accumulez des points",
    ),
    "game_creation_classic_mode": MessageLookupByLibrary.simpleMessage(
      "Mode Classique",
    ),
    "game_creation_create_game": MessageLookupByLibrary.simpleMessage(
      "Créer la partie",
    ),
    "game_creation_elimination_description":
        MessageLookupByLibrary.simpleMessage(
          "Affrontez d\'autres joueurs dans une série de questions",
        ),
    "game_creation_elimination_mode": MessageLookupByLibrary.simpleMessage(
      "Mode Élimination",
    ),
    "game_creation_entry_price": MessageLookupByLibrary.simpleMessage(
      "Prix d\'entrée",
    ),
    "game_creation_friends_only": MessageLookupByLibrary.simpleMessage(
      "Jeu réservé aux amis",
    ),
    "game_creation_friends_only_game": MessageLookupByLibrary.simpleMessage(
      "Entre amis",
    ),
    "game_creation_game_options": MessageLookupByLibrary.simpleMessage(
      "Options de jeu",
    ),
    "game_creation_max_questions": m11,
    "game_creation_not_enough_balance": MessageLookupByLibrary.simpleMessage(
      "Solde insuffisant pour créer cette partie",
    ),
    "game_creation_not_enough_questions": MessageLookupByLibrary.simpleMessage(
      "Il faut au moins 5 questions pour créer une partie",
    ),
    "game_creation_public": MessageLookupByLibrary.simpleMessage("Jeu public"),
    "game_creation_public_game": MessageLookupByLibrary.simpleMessage(
      "Partie publique",
    ),
    "game_creation_question_count": MessageLookupByLibrary.simpleMessage(
      "Nombre de questions: ",
    ),
    "game_creation_question_list": MessageLookupByLibrary.simpleMessage(
      "Liste de Questions",
    ),
    "game_creation_select_game": MessageLookupByLibrary.simpleMessage(
      "Mode Classique",
    ),
    "game_creation_survival_description": MessageLookupByLibrary.simpleMessage(
      "Testez votre endurance avec des questions aléatoires",
    ),
    "game_creation_survival_mode": MessageLookupByLibrary.simpleMessage(
      "Mode Survie",
    ),
    "game_creation_unavailable_quiz": MessageLookupByLibrary.simpleMessage(
      "Le quiz sélectionné n\'est plus disponible",
    ),
    "game_elimination_service_last_answer":
        MessageLookupByLibrary.simpleMessage(
          "Vous étiez le dernier à répondre",
        ),
    "game_elimination_service_no_answer": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas répondu à temps",
    ),
    "game_elimination_service_wrong_answer":
        MessageLookupByLibrary.simpleMessage("Vous avez répondu faux"),
    "game_header_random_quiz_title": MessageLookupByLibrary.simpleMessage(
      "Quiz Aléatoire",
    ),
    "game_joining_banned_user": MessageLookupByLibrary.simpleMessage(
      "Vous êtes banni de la partie",
    ),
    "game_joining_create_one": MessageLookupByLibrary.simpleMessage(
      "Créez-en une!",
    ),
    "game_joining_friends_only": MessageLookupByLibrary.simpleMessage(
      "Cette salle de jeu est réservée aux amis",
    ),
    "game_joining_game_already_started": MessageLookupByLibrary.simpleMessage(
      "La partie est en cours",
    ),
    "game_joining_game_id": MessageLookupByLibrary.simpleMessage(
      "ID de partie",
    ),
    "game_joining_header_random_quiz_title":
        MessageLookupByLibrary.simpleMessage("Quiz Aléatoire"),
    "game_joining_invalid_game_id": MessageLookupByLibrary.simpleMessage(
      "L\'identifiant doit être un nombre à 4 chiffres",
    ),
    "game_joining_lobby_locked": MessageLookupByLibrary.simpleMessage(
      "Cette salle de jeu est verrouillée",
    ),
    "game_joining_no_game_currently": MessageLookupByLibrary.simpleMessage(
      "Il n\'y a pas de partie active pour le moment",
    ),
    "game_joining_no_game_found": MessageLookupByLibrary.simpleMessage(
      "La partie n\'existe pas",
    ),
    "game_joining_not_enough_coins": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas assez de pièces pour rejoindre cette partie",
    ),
    "game_joining_pay_to_join": m12,
    "game_joining_players": MessageLookupByLibrary.simpleMessage("Joueurs"),
    "game_joining_rating": MessageLookupByLibrary.simpleMessage("Note du quiz"),
    "game_joining_status": MessageLookupByLibrary.simpleMessage("Statut"),
    "game_joining_title": MessageLookupByLibrary.simpleMessage("Titre"),
    "game_joining_type": MessageLookupByLibrary.simpleMessage("Mode"),
    "game_leaderboard_fun": MessageLookupByLibrary.simpleMessage("Amusement"),
    "game_leaderboard_fun_stats": MessageLookupByLibrary.simpleMessage(
      "Statistiques amusantes",
    ),
    "game_leaderboard_quiz": MessageLookupByLibrary.simpleMessage("Quiz"),
    "game_leaderboard_stats": MessageLookupByLibrary.simpleMessage(
      "Statistiques",
    ),
    "game_leaderboard_title": MessageLookupByLibrary.simpleMessage(
      "Classement",
    ),
    "game_leaderboard_user": MessageLookupByLibrary.simpleMessage(
      "Utilisateur",
    ),
    "game_lobby_lock_game": MessageLookupByLibrary.simpleMessage(
      "Déverrouillé",
    ),
    "game_lobby_start_game": MessageLookupByLibrary.simpleMessage(
      "Commencer la partie",
    ),
    "game_lobby_unlock_game": MessageLookupByLibrary.simpleMessage(
      "Verrouillé",
    ),
    "game_loot_challenge_coins_gained": MessageLookupByLibrary.simpleMessage(
      "Récompenses de Défi",
    ),
    "game_loot_coins": MessageLookupByLibrary.simpleMessage("Pièces"),
    "game_loot_coins_gained": MessageLookupByLibrary.simpleMessage(
      "Pièces Gagnées",
    ),
    "game_loot_coins_paid": MessageLookupByLibrary.simpleMessage(
      "Prix d\'entrée",
    ),
    "game_loot_experience": MessageLookupByLibrary.simpleMessage("Expérience"),
    "game_loot_level_up": MessageLookupByLibrary.simpleMessage(
      "Vous avez monté de niveau !",
    ),
    "game_loot_won_game_pot": m13,
    "game_loot_xp_gained": MessageLookupByLibrary.simpleMessage(
      "Expérience Gagnée",
    ),
    "game_loot_xp_label": MessageLookupByLibrary.simpleMessage(
      "Points d\'Expérience",
    ),
    "game_message_answers_sent": MessageLookupByLibrary.simpleMessage(
      "Réponses envoyées",
    ),
    "game_message_correction_with_bonus": m14,
    "game_message_correction_with_percentage": m15,
    "game_message_correction_without_bonus": m16,
    "game_metrics_game_time_added": MessageLookupByLibrary.simpleMessage(
      "Temps de jeu",
    ),
    "game_metrics_game_won": MessageLookupByLibrary.simpleMessage(
      "Parties gagnées",
    ),
    "game_metrics_no_improvements": MessageLookupByLibrary.simpleMessage(
      "Aucune Amélioration",
    ),
    "game_metrics_points_gained": MessageLookupByLibrary.simpleMessage(
      "Points Gagnés",
    ),
    "game_metrics_questions_survived": MessageLookupByLibrary.simpleMessage(
      "Questions Survécues",
    ),
    "game_metrics_title": MessageLookupByLibrary.simpleMessage(
      "Améliorations des Stats de Jeu",
    ),
    "game_mode_classical": MessageLookupByLibrary.simpleMessage("Classique"),
    "game_mode_elimination": MessageLookupByLibrary.simpleMessage(
      "Élimination",
    ),
    "game_mode_survival": MessageLookupByLibrary.simpleMessage("Survie"),
    "game_organizer_correcting_answers": MessageLookupByLibrary.simpleMessage(
      "Évaluez la réponse",
    ),
    "game_organizer_waiting_answers": MessageLookupByLibrary.simpleMessage(
      "Les joueurs sont en train de répondre",
    ),
    "game_play_top_bar_title": MessageLookupByLibrary.simpleMessage(
      "Vue de jeu",
    ),
    "game_player_waiting_correction_title":
        MessageLookupByLibrary.simpleMessage("Correction des Réponses"),
    "game_result_next_slide_button": MessageLookupByLibrary.simpleMessage(
      "Suivant",
    ),
    "game_result_previous_slide_button": MessageLookupByLibrary.simpleMessage(
      "Précédent",
    ),
    "game_score_alive": MessageLookupByLibrary.simpleMessage("Vivant"),
    "game_score_eliminated": MessageLookupByLibrary.simpleMessage("Éliminé"),
    "game_score_your_score": MessageLookupByLibrary.simpleMessage(
      "Votre pointage",
    ),
    "game_time": MessageLookupByLibrary.simpleMessage("Temps de jeu"),
    "game_top_bar_leave": MessageLookupByLibrary.simpleMessage("Abandonner"),
    "game_top_bar_logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "game_top_bar_quit": MessageLookupByLibrary.simpleMessage("Quitter"),
    "game_top_bar_terminate": MessageLookupByLibrary.simpleMessage("Terminer"),
    "game_win_streak_streak_best": MessageLookupByLibrary.simpleMessage(
      "Vous avez atteint votre meilleure série de victoire!",
    ),
    "game_win_streak_streak_improved": MessageLookupByLibrary.simpleMessage(
      "Votre série de victoire s\'est améliorée!",
    ),
    "game_win_streak_streak_lost": MessageLookupByLibrary.simpleMessage(
      "Vous avez perdu votre série de victoire!",
    ),
    "games_won": MessageLookupByLibrary.simpleMessage("Jeux gagnés"),
    "go_to_shop": MessageLookupByLibrary.simpleMessage("Visiter la boutique"),
    "golden_blueberry_avatar": MessageLookupByLibrary.simpleMessage(
      "Avatar Bleuet Doré",
    ),
    "golden_lemon_avatar": MessageLookupByLibrary.simpleMessage(
      "Avatar Citron Doré",
    ),
    "golden_watermelon_avatar": MessageLookupByLibrary.simpleMessage(
      "Avatar Pastèque Doré",
    ),
    "header_avatar_button": MessageLookupByLibrary.simpleMessage("Avatar"),
    "header_confirm_logout": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment vous déconnecter ?",
    ),
    "header_create_game_button": MessageLookupByLibrary.simpleMessage(
      "Créer une partie",
    ),
    "header_game_history": MessageLookupByLibrary.simpleMessage(
      "Historique de jeu",
    ),
    "header_game_history_button": MessageLookupByLibrary.simpleMessage(
      "Historique",
    ),
    "header_game_menu": MessageLookupByLibrary.simpleMessage("Menu de jeu"),
    "header_history_button": MessageLookupByLibrary.simpleMessage("Historique"),
    "header_join_game_button": MessageLookupByLibrary.simpleMessage(
      "Rejoindre une partie",
    ),
    "header_leaderboard_button": MessageLookupByLibrary.simpleMessage(
      "Classement",
    ),
    "header_library_button": MessageLookupByLibrary.simpleMessage(
      "Bibliothèque",
    ),
    "header_logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "header_logout_button": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "header_profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "header_profile_button": MessageLookupByLibrary.simpleMessage("Profile"),
    "header_shop_button": MessageLookupByLibrary.simpleMessage("Boutique"),
    "header_users_button": MessageLookupByLibrary.simpleMessage("Utilisateurs"),
    "header_widget_avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
    "header_widget_create_game": MessageLookupByLibrary.simpleMessage(
      "Créer une partie",
    ),
    "header_widget_join_game": MessageLookupByLibrary.simpleMessage(
      "Rejoindre une partie",
    ),
    "header_widget_leaderboard": MessageLookupByLibrary.simpleMessage(
      "Classement",
    ),
    "header_widget_library": MessageLookupByLibrary.simpleMessage("Librairie"),
    "header_widget_shop": MessageLookupByLibrary.simpleMessage("Boutique"),
    "header_widget_users_button": MessageLookupByLibrary.simpleMessage(
      "Liste des utilisateurs",
    ),
    "hint_widget_buy_hint": m17,
    "home_page_create_game": MessageLookupByLibrary.simpleMessage(
      "Créer une partie",
    ),
    "home_page_join_game": MessageLookupByLibrary.simpleMessage(
      "Rejoindre une partie",
    ),
    "home_page_no_choice_text": MessageLookupByLibrary.simpleMessage(
      "Aucun texte de choix",
    ),
    "home_page_no_description": MessageLookupByLibrary.simpleMessage(
      "Aucune Description",
    ),
    "home_page_no_question_text": MessageLookupByLibrary.simpleMessage(
      "Aucun texte de question",
    ),
    "home_page_no_title": MessageLookupByLibrary.simpleMessage("Aucun Titre"),
    "home_page_team": MessageLookupByLibrary.simpleMessage("Équipe 101"),
    "home_page_team_members": MessageLookupByLibrary.simpleMessage(
      "Lyne Dahan, Jérôme Fréchette, Skander Hellal, Philippe Martin, John Abou Nakoul, Yacine Barka",
    ),
    "image_load_failed": MessageLookupByLibrary.simpleMessage(
      "Échec du chargement de l\'image",
    ),
    "image_not_available": MessageLookupByLibrary.simpleMessage(
      "Image non disponible",
    ),
    "image_zoom": MessageLookupByLibrary.simpleMessage("Zoomer"),
    "information": MessageLookupByLibrary.simpleMessage("Information"),
    "information_header": MessageLookupByLibrary.simpleMessage("Informations"),
    "information_modal_understood": MessageLookupByLibrary.simpleMessage(
      "Compris",
    ),
    "information_profile_blueberry_theme": MessageLookupByLibrary.simpleMessage(
      "Bleuet",
    ),
    "information_profile_lemon_theme": MessageLookupByLibrary.simpleMessage(
      "Citron",
    ),
    "information_profile_orange_theme": MessageLookupByLibrary.simpleMessage(
      "Orange",
    ),
    "information_profile_select_background":
        MessageLookupByLibrary.simpleMessage("Choisir un Fond"),
    "information_profile_select_theme": MessageLookupByLibrary.simpleMessage(
      "Choisir un Thème",
    ),
    "information_profile_strawberry_theme":
        MessageLookupByLibrary.simpleMessage("Fraise"),
    "information_profile_username": MessageLookupByLibrary.simpleMessage(
      "Utilisateur",
    ),
    "information_profile_watermelon_theme":
        MessageLookupByLibrary.simpleMessage("Pastèque"),
    "join": MessageLookupByLibrary.simpleMessage("Rejoindre"),
    "join_chatroom": MessageLookupByLibrary.simpleMessage("Rejoindre un canal"),
    "join_game": MessageLookupByLibrary.simpleMessage("Rejoindre une partie"),
    "kicked_out_message_banned": MessageLookupByLibrary.simpleMessage(
      "Vous avez été banni",
    ),
    "kicked_out_message_no_players_left": MessageLookupByLibrary.simpleMessage(
      "Il n\'y a plus de joueur participant",
    ),
    "kicked_out_message_organizer_left": MessageLookupByLibrary.simpleMessage(
      "L\'organisateur a terminé la partie",
    ),
    "leaderboardPage_BestStreak": MessageLookupByLibrary.simpleMessage(
      "Meilleure série de victoire",
    ),
    "leaderboardPage_CoinsGained": MessageLookupByLibrary.simpleMessage(
      "Pièces gagnées",
    ),
    "leaderboardPage_CoinsSpent": MessageLookupByLibrary.simpleMessage(
      "Pièces dépensées",
    ),
    "leaderboardPage_CurrentStreak": MessageLookupByLibrary.simpleMessage(
      "Série de victoire actuelle",
    ),
    "leaderboardPage_GameTime": MessageLookupByLibrary.simpleMessage(
      "Temps de partie",
    ),
    "leaderboardPage_GamesWon": MessageLookupByLibrary.simpleMessage(
      "Parties gagnées",
    ),
    "leaderboardPage_Leaderboard": MessageLookupByLibrary.simpleMessage(
      "Classement",
    ),
    "leaderboardPage_Points": MessageLookupByLibrary.simpleMessage(
      "Points accumulés",
    ),
    "leaderboardPage_Questions": MessageLookupByLibrary.simpleMessage(
      "Questions",
    ),
    "leaderboardPage_Rank": MessageLookupByLibrary.simpleMessage("Rang"),
    "leaderboardPage_User": MessageLookupByLibrary.simpleMessage("Utilisateur"),
    "leave_chat_title": MessageLookupByLibrary.simpleMessage(
      "Quitter un Canal",
    ),
    "lemon_background": MessageLookupByLibrary.simpleMessage("Fond Citron"),
    "level_XP": MessageLookupByLibrary.simpleMessage("Niveau EXP:"),
    "locked_item_message": MessageLookupByLibrary.simpleMessage(
      "Visiter la boutique pour acheter des objets.",
    ),
    "locked_item_title": MessageLookupByLibrary.simpleMessage(
      "Objet verrouillé",
    ),
    "log_history_android": MessageLookupByLibrary.simpleMessage("Mobile"),
    "log_history_auth_logs": MessageLookupByLibrary.simpleMessage(
      "Historique de connexion",
    ),
    "log_history_back": MessageLookupByLibrary.simpleMessage(
      "Retour à l\'accueil",
    ),
    "log_history_desktop": MessageLookupByLibrary.simpleMessage("Ordinateur"),
    "log_history_device_type": MessageLookupByLibrary.simpleMessage("Appareil"),
    "log_history_game_logs": MessageLookupByLibrary.simpleMessage(
      "Sessions de jeu",
    ),
    "log_history_has_abandon": MessageLookupByLibrary.simpleMessage(
      "Abandonné",
    ),
    "log_history_has_won": MessageLookupByLibrary.simpleMessage("Victoire"),
    "log_history_login_time": MessageLookupByLibrary.simpleMessage(
      "Connecté à",
    ),
    "log_history_logout_time": MessageLookupByLibrary.simpleMessage(
      "Déconnecté à",
    ),
    "log_history_no_records": MessageLookupByLibrary.simpleMessage(
      "Aucun historique disponible",
    ),
    "log_history_start_date": MessageLookupByLibrary.simpleMessage(
      "Début de la partie",
    ),
    "log_history_title": MessageLookupByLibrary.simpleMessage("Mon historique"),
    "login_button": MessageLookupByLibrary.simpleMessage("CONNEXION"),
    "login_here": MessageLookupByLibrary.simpleMessage("Connectez-vous"),
    "login_title": MessageLookupByLibrary.simpleMessage("Connectez-vous"),
    "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "new_message": MessageLookupByLibrary.simpleMessage("Nouveau message"),
    "no": MessageLookupByLibrary.simpleMessage("Non"),
    "no_account": MessageLookupByLibrary.simpleMessage("Pas de compte ?"),
    "no_chats": MessageLookupByLibrary.simpleMessage("Aucun canal trouvé..."),
    "no_empty_name": MessageLookupByLibrary.simpleMessage(
      "Le nom du canal ne peut pas être vide.",
    ),
    "no_items": MessageLookupByLibrary.simpleMessage(
      "Aucun article disponible pour cette catégorie.",
    ),
    "notification_close_button": MessageLookupByLibrary.simpleMessage("Fermer"),
    "orange_background": MessageLookupByLibrary.simpleMessage("Fond Orange"),
    "organizer_correcting": MessageLookupByLibrary.simpleMessage(
      "L\'organisateur corrige les réponses",
    ),
    "other": MessageLookupByLibrary.simpleMessage("Autres"),
    "password_label": MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "password_mismatch": MessageLookupByLibrary.simpleMessage(
      "Les mots de passe ne correspondent pas",
    ),
    "personal_info_error_title": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la sauvegarde",
    ),
    "personal_info_header": MessageLookupByLibrary.simpleMessage(
      "Informations",
    ),
    "personal_info_success_title": MessageLookupByLibrary.simpleMessage(
      "Succès",
    ),
    "personal_profile_challenge_completed":
        MessageLookupByLibrary.simpleMessage("Défis complétés"),
    "personal_profile_correct_answers": MessageLookupByLibrary.simpleMessage(
      "Moyenne de bonnes réponses",
    ),
    "personal_profile_email": MessageLookupByLibrary.simpleMessage("Courriel:"),
    "personal_profile_game_played": MessageLookupByLibrary.simpleMessage(
      "Parties jouées",
    ),
    "personal_profile_game_time": MessageLookupByLibrary.simpleMessage(
      "Temps moyen par partie",
    ),
    "personal_profile_game_won": MessageLookupByLibrary.simpleMessage(
      "Parties gagnées",
    ),
    "personal_profile_info": MessageLookupByLibrary.simpleMessage(
      "Information personelle:",
    ),
    "personal_profile_language_choice": MessageLookupByLibrary.simpleMessage(
      "Choisir un language :",
    ),
    "personal_profile_language_english": MessageLookupByLibrary.simpleMessage(
      "Anglais",
    ),
    "personal_profile_language_french": MessageLookupByLibrary.simpleMessage(
      "Français",
    ),
    "personal_profile_level": MessageLookupByLibrary.simpleMessage("Niveau"),
    "personal_profile_statistics": MessageLookupByLibrary.simpleMessage(
      "Statistiques",
    ),
    "personal_profile_username": MessageLookupByLibrary.simpleMessage(
      "Nom utilisateur:",
    ),
    "player": MessageLookupByLibrary.simpleMessage("Joueur"),
    "player_list_round_survived": MessageLookupByLibrary.simpleMessage(
      "Manches survécues",
    ),
    "player_list_score": MessageLookupByLibrary.simpleMessage("Pointage"),
    "player_list_title": MessageLookupByLibrary.simpleMessage(
      "Liste des joueurs",
    ),
    "premium_avatar": MessageLookupByLibrary.simpleMessage("Avatars premium"),
    "premium_lemon_avatar": MessageLookupByLibrary.simpleMessage(
      "Avatar Premium Citron",
    ),
    "premium_orange_avatar": MessageLookupByLibrary.simpleMessage(
      "Avatar Premium Orange",
    ),
    "prepare_yourself": MessageLookupByLibrary.simpleMessage("Préparez-vous"),
    "price": MessageLookupByLibrary.simpleMessage("Prix:"),
    "profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "public_profile_user_unfound": MessageLookupByLibrary.simpleMessage(
      "Utilisateur non trouvé",
    ),
    "qre_answer_player_correct": MessageLookupByLibrary.simpleMessage(
      "Réponse correcte:",
    ),
    "qre_answer_player_hint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre réponse",
    ),
    "qre_correct_answer_is": m18,
    "qre_correct_answer_with_tolerance": m19,
    "qre_enter_answer_hint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre réponse",
    ),
    "qre_slider_max_value": m20,
    "qre_slider_min_value": m21,
    "qrl_correction_finished": MessageLookupByLibrary.simpleMessage(
      "Correction terminée",
    ),
    "question_header_zoom": MessageLookupByLibrary.simpleMessage("Agrandir"),
    "question_type_qcm": MessageLookupByLibrary.simpleMessage("Choix Multiple"),
    "question_type_qre": MessageLookupByLibrary.simpleMessage(
      "Réponse Estimée",
    ),
    "question_type_qrl": MessageLookupByLibrary.simpleMessage("Réponse Longue"),
    "question_type_unknown": MessageLookupByLibrary.simpleMessage("Inconnu"),
    "questions_survived": MessageLookupByLibrary.simpleMessage(
      "Questions survécues",
    ),
    "quick_join_button": MessageLookupByLibrary.simpleMessage("Rejoindre"),
    "quick_join_label": MessageLookupByLibrary.simpleMessage(
      "Code de la partie",
    ),
    "quit_button": MessageLookupByLibrary.simpleMessage("Quitter"),
    "quiz_contains_questions": m22,
    "quiz_description": m23,
    "quiz_detail_component_creator": MessageLookupByLibrary.simpleMessage(
      "Créé par :",
    ),
    "quiz_detail_component_description": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "quiz_detail_component_nb_questions": MessageLookupByLibrary.simpleMessage(
      "Nombre de questions :",
    ),
    "quiz_detail_component_time_to_respond":
        MessageLookupByLibrary.simpleMessage("Temps de réponse :"),
    "quiz_duration": m24,
    "quiz_last_modified": m25,
    "quiz_owner": m26,
    "quiz_question_count": m27,
    "quiz_questions": MessageLookupByLibrary.simpleMessage("questions"),
    "quiz_send_rating_rate_quiz": MessageLookupByLibrary.simpleMessage(
      "Évaluer le quiz",
    ),
    "quiz_send_rating_update_rating": MessageLookupByLibrary.simpleMessage(
      "Reévaluer le quiz",
    ),
    "quiz_title": m28,
    "quiz_view_rating_quiz_rating": MessageLookupByLibrary.simpleMessage(
      "Évaluation",
    ),
    "quiz_view_rating_reviews": MessageLookupByLibrary.simpleMessage("avis"),
    "quiz_view_rating_unrateable": MessageLookupByLibrary.simpleMessage(
      "Non évaluable",
    ),
    "random_quiz_description": MessageLookupByLibrary.simpleMessage(
      "Les questions sont sélectionnées aléatoirement depuis la banque de quiz",
    ),
    "random_quiz_header_title": MessageLookupByLibrary.simpleMessage(
      "Quiz Élimination",
    ),
    "random_quiz_time_limit": MessageLookupByLibrary.simpleMessage(
      "Temps pour répondre: 20s",
    ),
    "random_quiz_title": MessageLookupByLibrary.simpleMessage(
      "Quiz en mode élimination",
    ),
    "register_title": MessageLookupByLibrary.simpleMessage("Créer un compte"),
    "result_view_achivements": MessageLookupByLibrary.simpleMessage(
      "Accomplissements",
    ),
    "result_view_cant_rate_system_quiz": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'évaluer un questionnaire système",
    ),
    "result_view_challenges": MessageLookupByLibrary.simpleMessage(
      "Défis de partie",
    ),
    "result_view_created_by": MessageLookupByLibrary.simpleMessage(
      "Créé par: ",
    ),
    "result_view_game_loot": MessageLookupByLibrary.simpleMessage(
      "Récompenses de partie",
    ),
    "result_view_leaderboard": MessageLookupByLibrary.simpleMessage(
      "Classement",
    ),
    "result_view_quiz_stats": MessageLookupByLibrary.simpleMessage(
      "Questionnaire & Retour",
    ),
    "result_view_title": MessageLookupByLibrary.simpleMessage(
      "Résultats de la partie",
    ),
    "result_winner_answered_faster": MessageLookupByLibrary.simpleMessage(
      "a répondu plus vite",
    ),
    "result_winner_tie_breaker": MessageLookupByLibrary.simpleMessage(
      "Tiebreaker : ",
    ),
    "result_winner_winner": MessageLookupByLibrary.simpleMessage("Gagnant : "),
    "results_stats_quiz_cannot_rate": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'évaluer un quiz du système",
    ),
    "results_stats_quiz_created": MessageLookupByLibrary.simpleMessage(
      "Créé par:",
    ),
    "results_stats_quiz_fun_stats": MessageLookupByLibrary.simpleMessage(
      "Statistiques amusantes",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Sauvegarder votre avatar"),
    "select_chatroom": MessageLookupByLibrary.simpleMessage("Ouvrir un canal"),
    "select_game": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez un jeu pour le tester ou lancer une partie!",
    ),
    "select_quiz_details": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez un quiz pour voir les détails",
    ),
    "shop_title": MessageLookupByLibrary.simpleMessage("Votre Boutique"),
    "side_bar_accomplishements": MessageLookupByLibrary.simpleMessage(
      "Accomplissements",
    ),
    "side_bar_friends": MessageLookupByLibrary.simpleMessage("Amis"),
    "side_bar_preferences": MessageLookupByLibrary.simpleMessage("Préférences"),
    "side_bar_themes": MessageLookupByLibrary.simpleMessage("Thèmes"),
    "sidebar_widget_accomplishments": MessageLookupByLibrary.simpleMessage(
      "Accomplissements",
    ),
    "sidebar_widget_friends": MessageLookupByLibrary.simpleMessage("Amis"),
    "sidebar_widget_info": MessageLookupByLibrary.simpleMessage("Information"),
    "signup_button": MessageLookupByLibrary.simpleMessage("S\'INSCRIRE"),
    "special_quiz_activate_condition": MessageLookupByLibrary.simpleMessage(
      "Il faut au moins 5 QCM ou QRE pour activer ce quiz",
    ),
    "special_quiz_cant_change": MessageLookupByLibrary.simpleMessage(
      "Créez des nouveaux QCM ou QRE si vous voulez plus de 5 questions",
    ),
    "special_quiz_count_selected": m29,
    "special_quiz_nb_question_details": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez un nombre de questions: ",
    ),
    "special_quiz_nb_question_header": m30,
    "strawberry_background": MessageLookupByLibrary.simpleMessage(
      "Fond Fraise",
    ),
    "strawberry_theme": MessageLookupByLibrary.simpleMessage("Thème Fraise"),
    "submit": MessageLookupByLibrary.simpleMessage("Soumettre"),
    "survival_best_score_best_score": MessageLookupByLibrary.simpleMessage(
      "Meilleur Score",
    ),
    "survival_best_score_current_score": MessageLookupByLibrary.simpleMessage(
      "Score Actuel",
    ),
    "survival_best_score_title": MessageLookupByLibrary.simpleMessage(
      "Mode Survie",
    ),
    "survival_mode_progression_title": MessageLookupByLibrary.simpleMessage(
      "Mode Survie",
    ),
    "survival_quiz_description": MessageLookupByLibrary.simpleMessage(
      "Les questions sont sélectionnées aléatoirement depuis la banque de quiz",
    ),
    "survival_quiz_header_title": MessageLookupByLibrary.simpleMessage(
      "Quiz Survie",
    ),
    "survival_quiz_time_limit": MessageLookupByLibrary.simpleMessage(
      "Temps pour répondre: 20s",
    ),
    "survival_quiz_title": MessageLookupByLibrary.simpleMessage(
      "Quiz en mode survie",
    ),
    "survival_result_lost_title": MessageLookupByLibrary.simpleMessage(
      "Défaite, vous n\'avez pas pu survivre",
    ),
    "survival_result_mode": MessageLookupByLibrary.simpleMessage(
      "Questions Survécues",
    ),
    "survival_result_questions_correct": m31,
    "survival_result_won_title": MessageLookupByLibrary.simpleMessage(
      "Victoire, vous avez survécu jusqu\'à la fin",
    ),
    "system": MessageLookupByLibrary.simpleMessage("Système"),
    "the_chatroom": MessageLookupByLibrary.simpleMessage("le canal."),
    "the_game": MessageLookupByLibrary.simpleMessage("la partie."),
    "theme": MessageLookupByLibrary.simpleMessage("Thème"),
    "total_points": MessageLookupByLibrary.simpleMessage("Pointage"),
    "user_joined": m32,
    "user_left": m33,
    "username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
    "username_empty": MessageLookupByLibrary.simpleMessage(
      "You can not leave the username empty.",
    ),
    "username_empty_error": MessageLookupByLibrary.simpleMessage(
      "Le nom d\'utilisateur ne peut pas être vide.",
    ),
    "username_label": MessageLookupByLibrary.simpleMessage(
      "Nom d\'utilisateur",
    ),
    "username_taken": MessageLookupByLibrary.simpleMessage(
      "Ce nom d\'utilisateur est déjà pris par un autre utilisateur",
    ),
    "username_updated": MessageLookupByLibrary.simpleMessage(
      " Votre nom d\'utilisateur a été changé",
    ),
    "users_list_filter_label": MessageLookupByLibrary.simpleMessage(
      "Filtrer par nom d\'utilisateur",
    ),
    "users_list_no_result": MessageLookupByLibrary.simpleMessage(
      "Aucun utilisateur ne correspond à votre recherche",
    ),
    "users_list_title": MessageLookupByLibrary.simpleMessage(
      "Découvrez de nouvelles personnes",
    ),
    "users_list_visit_account": MessageLookupByLibrary.simpleMessage(
      "Voir le profil utilisateur",
    ),
    "waiting_for_players": MessageLookupByLibrary.simpleMessage(
      "En attente des joueurs...",
    ),
    "waiting_room": MessageLookupByLibrary.simpleMessage("Salle d\'attente"),
    "watermelon_background": MessageLookupByLibrary.simpleMessage(
      "Fond Pastèque",
    ),
    "watermelon_theme": MessageLookupByLibrary.simpleMessage("Thème Pastèque"),
    "yes": MessageLookupByLibrary.simpleMessage("Oui"),
    "your_stats": MessageLookupByLibrary.simpleMessage("Accomplissements"),
  };
}
