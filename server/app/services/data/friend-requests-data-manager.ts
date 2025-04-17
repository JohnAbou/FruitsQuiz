import { Service } from 'typedi';
import { DataManagerService } from './data-manager.service';
import { DataBaseAcces } from './database-acces.service';
import { FRIEND_REQUEST_COLLECTION } from '@app/consts/database.consts';
import { FriendRequest } from '@app/interfaces/friends/friend-request';
import { UsernameModifiedEvent } from '@app/interfaces/users/username-modified-event';

@Service({ transient: true })
export class FriendRequestsDataManager extends DataManagerService<FriendRequest> {
    constructor(dbAcces: DataBaseAcces) {
        super(dbAcces);
        this.setCollection(FRIEND_REQUEST_COLLECTION);
    }

    async addFriendRequest(request: FriendRequest): Promise<boolean> {
        const existingRequest = await this.getCollection().findOne({ senderUsername: request.senderUsername, receiverUsername: request.receiverUsername });
        if (existingRequest) return false;

        return await this.addElementNoCheck(request);
    }

    async getUserSentRequest(username: string): Promise<FriendRequest[]> {
        const reviews = await this.getCollection().find({ senderUsername: username }).toArray();
        return (reviews ?? []) as unknown as FriendRequest[];
    }

    async getUserReceivedRequest(username: string): Promise<FriendRequest[]> {
        const reviews = await this.getCollection().find({ receiverUsername: username }).toArray();
        return (reviews ?? []) as unknown as FriendRequest[];
    }

    async deleteFriendRequest(senderUsername: string, receiverUsername: string) {
        let result = await this.getCollection().deleteOne({ senderUsername, receiverUsername });
        return !!result.deletedCount;
    }

    async deleteFriendRequestedById(friendRequestId: string): Promise<FriendRequest> {
        const review = this.getCollection().findOneAndDelete({id: friendRequestId});
        return review as unknown as FriendRequest;
    }

    async updateFriendRequestSeen(requestId: string) {
        const result = await this.getCollection().updateOne({ id: requestId }, { $set: { seen: true } });
        return !!result.modifiedCount;
    }

    async renameFriendRequest(event: UsernameModifiedEvent) {
        const result = await this.getCollection().updateMany(
            {
                $or: [
                    { senderUsername: event.oldUsername },
                    { receiverUsername: event.oldUsername }
                ]
            },
            [
                {
                    $set: {
                        senderUsername: {
                            $cond: [
                                { $eq: ["$senderUsername", event.oldUsername] },
                                event.newUsername,
                                "$senderUsername"
                            ]
                        },
                        receiverUsername: {
                            $cond: [
                                { $eq: ["$receiverUsername", event.oldUsername] },
                                event.newUsername,
                                "$receiverUsername"
                            ]
                        }
                    }
                }
            ]
        );

        return !!result;
    }
}
