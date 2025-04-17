import { environment } from "src/environments/environment"

export const getAvatarSource = (avatarId: string) => {
    return `${environment.serverUrl}/image/avatar/${avatarId}`;
}