import { DATABASE_NAME, DATABASE_URL } from '@app/consts/database.consts';
import EventEmitter = require('events');
import { MongoClient, ServerApiVersion, Db } from 'mongodb';
import { Service } from 'typedi';

@Service()
export class DataBaseAcces {
    client: MongoClient;
    database: Db;
    dbConnectionEmitter = new EventEmitter();

    constructor() {
        this.connectToServer();
    }

    async connectToServer() {
        this.client = new MongoClient(DATABASE_URL, {
            serverApi: {
                version: ServerApiVersion.v1,
                strict: true,
                deprecationErrors: true,
            },
        });

        await this.client.connect();
        this.database = this.client.db(DATABASE_NAME);
        this.dbConnectionEmitter.emit('dbConnected');
    }
}
