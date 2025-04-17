export enum GameAnswerSocketEvent {
    SubmitAnswer = 'submitAnswers',
    ToggleAnswerChoices = 'toggleAnswerChoice',
    UpdateAnswerResponse = 'updateAnswerResponse',
    UpdateNumericAnswer = 'updateNumericAnswer',
    BuyHint = 'buyHint',
    SendHint = 'sendHint',

    SendCorrectAnswer = 'correctAnswers',
    SendAnswerToCorrect = 'sendAnswersToCorrect',
    SendAnswersCorrected = 'sendAnswersCorrected',
    SendCorrectionMessage = 'sendCorrectionMessage',
    QrlCorrectionStarted = 'qrlCorrectionStarted',
    QrlCorrectionFinished = 'qrlCorrectionFinished',
}