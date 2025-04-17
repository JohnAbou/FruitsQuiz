import { QuestionType } from '../enums/question-type';
import { Choice } from './choice';
import { Estimations } from './question-estimations';

export interface Question {
    id: string;
    text: string;
    points: number;
    type: QuestionType;
    choices: Choice[];
    answer?: string | number;
    lastModification: Date;
    estimations?: Estimations; 
    imageId?: string; 
    author?: string;
}

export interface QuestionWithIndex extends Question {
    index: number;
}