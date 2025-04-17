import { Quiz } from '@common/interfaces/quiz';

export const MINIMUM_QUESTION_TIME = 10;
export const MAXIMUM_QUESTION_TIME = 60;

export const VOID_QUIZ: Quiz = {
    id: '0',
    title: '',
    description: '',
    questions: [],
    duration: 30,
    lastModification: new Date(),
    isPublic: true,
    owner: '',
};
