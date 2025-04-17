import { INVALID_ANSWER } from '@app/consts/game.const';
import { Question } from '@common/interfaces/question';

export const getValidAnswers = (question: Question) => {
    return question
        ? question.choices.map((choice, index) => (choice.isCorrect ? index : INVALID_ANSWER)).filter((index) => index !== INVALID_ANSWER)
        : [];
};

export const getInvaliAnswers = (question: Question) => {
    return question
        ? question.choices.map((choice, index) => (!choice.isCorrect ? index : INVALID_ANSWER)).filter((index) => index !== INVALID_ANSWER)
        : [];
}

export const getExactValue = (question : Question) => {
    return question ?  question.estimations.exactValue : null;
};


