import { QuestionType } from '@common/enums/question-type';
import { Question } from '@common/interfaces/question';
import { AnswerToCorrect } from '@common/interfaces/answers/answer-to-correct';

export const MINIMUM_POINT = 10;
export const MAXIMUM_POINT = 100;
export const POINT_MULTIPLE = 10;

export const MINIMUM_QUESTION = 2;
export const MAXIMUM_QUESTION = 4;

export const MAXIMUM_CHARACTER_LONG_ANSWER = 200;

export const NEW_ANSWER = '';

export const VOID_QCM_QUESTION: Question = {
    id: '0',
    text: '',
    lastModification: new Date(),
    points: 10,
    type: QuestionType.QCM,
    choices: [
        { text: '', isCorrect: false },
        { text: '', isCorrect: true },
    ],
};
export const VOID_QRL_QUESTION: Question = {
    id: '0',
    text: '',
    lastModification: new Date(),
    points: 10,
    type: QuestionType.QRL,
    choices: [],
};

export const VOID_QRE_QUESTION: Question = {
    id: '0',
    text: '',
    lastModification: new Date(),
    points: 10,
    type: QuestionType.QRE,
    choices: [],
    estimations: {
        exactValue: 0,
        lowerBound: 0,
        upperBound: 0,
        toleranceMargin: 0,
    },
};

export const NO_QUESTION_FILTER = (questions: Question[]) => questions;

export const VOID_ANSWER_TO_CORRECT: AnswerToCorrect = {
    playerName: '',
    answer: '',
    score: 0,
};
