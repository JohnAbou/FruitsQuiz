import { Player } from "@common/interfaces/player";

export interface GameResult {
    winner? : Player;
    wasTie: boolean;
}