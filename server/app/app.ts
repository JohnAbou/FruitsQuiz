import { HttpException } from '@app/classes/http.exception';
import * as cookieParser from 'cookie-parser';
import * as cors from 'cors';
import * as express from 'express';
import { StatusCodes } from 'http-status-codes';
import * as swaggerJSDoc from 'swagger-jsdoc';
import * as swaggerUi from 'swagger-ui-express';
import { Service } from 'typedi';
import { QuizController } from './controllers/quiz.controller';
import { QuestionController } from './controllers/question.controller';
import { AccountController } from './controllers/account-controller';
import { ImageController } from './controllers/image-controller';
import { ThemesController } from './controllers/themes.controller';
import { BackgroundController } from './controllers/background.controller';

import * as i18next from 'i18next';
import * as Backend from 'i18next-fs-backend';
import * as middleware from 'i18next-http-middleware';
import { UserAuthenticationService } from './services/users/user-authentication.service';
import { LanguageController } from './controllers/language-controller';
import { CurrencyController } from './controllers/currency.controller';
import { ShopController } from './controllers/shop-controller';

declare global {
    namespace Express {
        interface Request {
            t: i18next.TFunction;
            language: string;
        }
    }
}

@Service()
export class Application {
    app: express.Application;
    private readonly internalError: number = StatusCodes.INTERNAL_SERVER_ERROR;
    private readonly swaggerOptions: swaggerJSDoc.Options;
    private i18n: i18next.i18n;

    constructor(
        private readonly quizController: QuizController,
        private readonly questionController: QuestionController,
        private readonly accountController: AccountController,
        private readonly userAuthService: UserAuthenticationService,
        private readonly imageController: ImageController,
        private readonly themesController: ThemesController,
        private readonly backgroundController: BackgroundController,
        private readonly languageController: LanguageController,
        private readonly currencyController: CurrencyController,
        private readonly shopController: ShopController

    ) {
        this.app = express();
        
        this.swaggerOptions = {
            swaggerDefinition: {
                openapi: '3.0.0',
                info: {
                    title: 'Cadriciel Serveur',
                    version: '1.0.0',
                },
            },
            apis: ['**/*.ts'],
        };

        this.configureI18n();
        this.userAuthService.setI18nInstance(this.i18n);
        this.config();
        this.bindRoutes();
    }

    private configureI18n(): void {
        this.i18n = i18next.createInstance();
        
        this.i18n
            .use(Backend as any)
            .use(middleware.LanguageDetector)
            .init({
                preload: ['en', 'fr'],
                backend: {
                    loadPath: './localization/{{lng}}.json',
                },
                detection: {
                    order: ['header'],
                    caches: false,
                },
                fallbackLng:  ['en', 'fr'],
            });

        this.app.use(middleware.handle(this.i18n));
    }

    bindRoutes(): void {
        this.app.use((req, res, next) => {
            req.i18n.changeLanguage(req.language);
            next();
        });
        this.app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(swaggerJSDoc(this.swaggerOptions)));
        this.app.use('/api/accounts', this.accountController.router);
        this.app.use('/api/quiz', this.quizController.router);
        this.app.use('/api/question', this.questionController.router);
        this.app.use('/api/image', this.imageController.router);
        this.app.use('/api/themes', this.themesController.router);
        this.app.use('/api/background', this.backgroundController.router);
        this.app.use('/api/language', this.languageController.router);
        this.app.use('/api/currency', this.currencyController.router);
        this.app.use('/api/shop', this.shopController.router);

        this.app.use('/', (req, res) => {
            res.redirect('/api/docs');
        });

        this.errorHandling();
    }

    private config(): void {
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));
        this.app.use(cookieParser());
        this.app.use(cors());
    }

    private errorHandling(): void {
        this.app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
            const err: HttpException = new HttpException(req.t('error.not_found') || 'Not Found');
            next(err);
        });

        this.app.use((err: HttpException, req: express.Request, res: express.Response, next: express.NextFunction) => {
            const status = err.status || this.internalError;
            const errorDetails = this.app.get('env') === 'development' ? err : {};
            
            res.status(status).json({
                message: req.t(err.message) || err.message,
                error: errorDetails,
            });
        });
    }
}
