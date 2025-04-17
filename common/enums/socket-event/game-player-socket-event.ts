export enum GamePlayerSocketEvent {
    SendPlayerJoined = 'playerJoined',
    SendPlayerLeft = 'playerLeft',
    PlayerRemovedFromGame = 'kickedOutFromGame',
    PlayerLeftGame = 'playerLeftGame',
    Disconnect = 'disconnect',
    SendPlayerStats = 'sendPlayersStat',
    SendPlayerScore = 'updateScore',
    EliminatePlayer = 'eliminatePlayer',
    SurvivedRound = 'survivedRound',
    SurvivalResult = 'survivalResult',
    SendChallenge = 'sendChallenge',
    SendChallengeResult = 'sendChallengeResult',
}