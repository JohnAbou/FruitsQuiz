export interface UserExperience {
    id: string;
    username: string;
    experience: number;
    level: number;
}

export interface UserExperienceInfo extends UserExperience {
    expToNextLevel: number;
}