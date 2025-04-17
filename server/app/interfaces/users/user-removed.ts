import { Player } from "./player";

export interface UserRemoved {
    user: Player;
    reason: number;
}
