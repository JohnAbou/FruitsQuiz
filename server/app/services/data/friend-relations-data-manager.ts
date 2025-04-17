import { Service } from 'typedi';
import { DataBaseAcces } from './database-acces.service';
import { FRIEND_RELATION_COLLECTION } from '@app/consts/database.consts';
import { FriendRelation } from '@app/interfaces/friends/friend-relation';
import { UsernameModifiedEvent } from '@app/interfaces/users/username-modified-event';

@Service({ transient: true })
export class FriendRelationsDataManager {

    private get collection() {
        return this.dbAcces.database.collection(FRIEND_RELATION_COLLECTION);
    }

    constructor(private readonly dbAcces: DataBaseAcces) { }

    async addFriendRelation(relation: FriendRelation): Promise<boolean> {
        const result = await this.collection.insertOne(relation);
        return result.acknowledged;
    }

    async delateFriendRelation(username1: string, username2: string): Promise<boolean> {
        const relation = { $or: [{ username1, username2 }, { username1: username2, username2: username1 }] };

        const result = await this.collection.deleteOne(relation);
        return result.acknowledged;
    }

    async renameUser(event: UsernameModifiedEvent) {
        const result = await this.collection.updateMany(
            {
                $or: [
                    { username1: event.oldUsername },
                    { username2: event.oldUsername }
                ]
            },
            [
                {
                    $set: {
                        username1: {
                            $cond: [
                                { $eq: ["$username1", event.oldUsername] },
                                event.newUsername,
                                "$username1"
                            ]
                        },
                        username2: {
                            $cond: [
                                { $eq: ["$username2", event.oldUsername] },
                                event.newUsername,
                                "$username2"
                            ]
                        }
                    }
                }
            ]
        );

        return !!result;
    }

    async getUserFriends(username: string): Promise<string[]> {
        const friends = await this.collection.find({
            $or: [{ username1: username }, { username2: username }]
        }).toArray();

        return friends.map(friend => friend.username1 === username ? friend.username2 : friend.username1);
    }
}
