import { Service, Inject } from 'typedi';
import { randomUUID } from 'crypto';
import * as sharp from 'sharp';
import { GridFSBucket, ObjectId } from 'mongodb';
import { DataBaseAcces } from '../data/database-acces.service';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { Question } from '@common/interfaces/question';
import { Quiz } from '@common/interfaces/quiz';
import { ImageMetadata } from '@common/interfaces/image';
import { QUESTION_COLLECTION, QUIZ_COLLECTION } from '@app/consts/database.consts';
import { IMAGE } from '@app/consts/image.consts';

@Service()
export class ImageService {
  private gridFSBucket: GridFSBucket | undefined;
  private questionDataManager: DataManagerService<Question>;
  private quizDataManager: DataManagerService<Quiz>;

  constructor(
    @Inject(() => DataBaseAcces) private databaseAccess: DataBaseAcces,
    questionDataManager: DataManagerService<Question>,
    quizDataManager: DataManagerService<Quiz>
  ) {
    this.questionDataManager = questionDataManager;
    this.questionDataManager.setCollection(QUESTION_COLLECTION);
    
    this.quizDataManager = quizDataManager;
    this.quizDataManager.setCollection(QUIZ_COLLECTION);
  }

  private ensureBucketInitialized(): void {
    if (!this.databaseAccess.database) {
      throw new Error(IMAGE.ERROR.DATABASE_NOT_INITIALIZED);
    }
    if (!this.gridFSBucket) {
      this.gridFSBucket = new GridFSBucket(this.databaseAccess.database, {
        bucketName: IMAGE.SETTINGS.BUCKET_NAME,
      });
    }
  }

  private async processAndUploadImage(
    buffer: Buffer,
    fileName: string,
    resizeOptions: sharp.ResizeOptions | { width: number; height: number },
    metadata: { type: 'question' | 'avatar'; createdAt: Date }
  ): Promise<string> {
    try {
      const processedBuffer = await sharp(buffer)
        .resize(resizeOptions)
        .jpeg({ quality: IMAGE.SETTINGS.QUALITY })
        .toBuffer();

      this.ensureBucketInitialized();

      const uploadStream = this.gridFSBucket!.openUploadStream(fileName, { metadata });
      uploadStream.end(processedBuffer);

      return await new Promise<string>((resolve, reject) => {
        uploadStream.on('finish', () => resolve(uploadStream.id.toString()));
        uploadStream.on('error', (err) => reject(new Error(`${IMAGE.ERROR.UPLOAD_ERROR}: ${err.message}`)));
      });
    } catch (error: any) {
      throw new Error(`${IMAGE.ERROR.PROCESSING_ERROR}: ${error.message}`);
    }
  }

  async processQuestionImage(buffer: Buffer): Promise<string> {
    if (!buffer) {
      throw new Error(IMAGE.ERROR.NO_FILE_PROVIDED);
    }
    
    const fileName = `${randomUUID()}.${IMAGE.SETTINGS.FORMAT}`;
    const metadata: ImageMetadata = { type: IMAGE.TYPE.QUESTION as 'question', createdAt: new Date() };
    const resizeOptions: sharp.ResizeOptions = { 
      width: IMAGE.SETTINGS.QUESTION_WIDTH, 
      withoutEnlargement: true 
    };
    return this.processAndUploadImage(buffer, fileName, resizeOptions, metadata);
  }

  async processAvatarImage(buffer: Buffer): Promise<string> {
    if (!buffer) {
      throw new Error(IMAGE.ERROR.NO_FILE_PROVIDED);
    }
    
    const fileName = `${randomUUID()}.${IMAGE.SETTINGS.FORMAT}`;
    const metadata: ImageMetadata = { type: IMAGE.TYPE.AVATAR as 'avatar', createdAt: new Date() };
    const resizeOptions = { 
      width: IMAGE.SETTINGS.AVATAR_WIDTH, 
      height: IMAGE.SETTINGS.AVATAR_HEIGHT 
    };
    return this.processAndUploadImage(buffer, fileName, resizeOptions, metadata);
  }
  getImageStream(id: string) {
    this.ensureBucketInitialized();
    try {
      const fileId = new ObjectId(id);
      return this.gridFSBucket.openDownloadStream(fileId);
    } catch (error: any) {
      throw new Error(IMAGE.ERROR.NOT_FOUND);
    }
  }

  async findQuestionsWithSameImageId(imageId: string): Promise<Question[]> {
    const standaloneQuestions = await this.questionDataManager.findElements({ imageId });
    
    const quizzes = await this.quizDataManager.getElements();
    const questionsInQuizzes: Question[] = [];
    
    for (const quiz of quizzes) {
      if (quiz.questions) {
        const matchingQuestions = quiz.questions.filter(question => question.imageId === imageId);
        questionsInQuizzes.push(...matchingQuestions);
      }
    }
    
    return [...standaloneQuestions, ...questionsInQuizzes];
  }

  async deleteImage(id: string): Promise<void> {
    this.ensureBucketInitialized();
    try {
      const referencingQuestions = await this.findQuestionsWithSameImageId(id);
      if (referencingQuestions.length > 0) {
        throw new Error(`${IMAGE.ERROR.STILL_REFERENCED} ${referencingQuestions.length} questions`);
      }
      
      await this.gridFSBucket.delete(new ObjectId(id));
    } catch (error: any) {
      throw new Error(`${IMAGE.ERROR.DELETION_ERROR}: ${error.message}`);
    }
  }

  async safeDeleteImage(id: string): Promise<boolean> {
    try {
      const referencingQuestions = await this.findQuestionsWithSameImageId(id);
      if (referencingQuestions.length > 0) {
        return false;
      }
      
      await this.gridFSBucket.delete(new ObjectId(id));
      return true;
    } catch (error) {
      return false;
    }
  }
}