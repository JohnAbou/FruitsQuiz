import { OptionalUnlessRequiredId } from 'mongodb';
import { Service } from 'typedi';
import { randomUUID } from 'crypto';
import { DataBaseAcces } from './database-acces.service';
import { HasId } from '@app/interfaces/has-id';
import { EMPTY_ID } from '@app/consts/database.consts';

@Service({ transient: true })
export class DataManagerService<T extends HasId> {
    private collectionName: string;

    constructor(private dbAcces: DataBaseAcces) {}

    setCollection(collectionName: string) {
        this.collectionName = collectionName;
    }

    async addElement(element: T): Promise<boolean> {
        if (!element.id || element.id === EMPTY_ID || !(await this.getElementById(element.id))) return await this.addElementNoCheck(element);

        return await this.replaceElement(element);
    }

    async deleteElement(id: string): Promise<boolean> {
        const collection = this.getCollection();
        const result = await collection.deleteOne({ id });

        return result.acknowledged;
    }

    async deleteAllElements(): Promise<boolean> {
        const collection = this.getCollection();
        const result = await collection.deleteMany({});

        return result.acknowledged;
    }

    async getElements(): Promise<T[]> {
        const collection = this.getCollection();
        const elements = await collection.find({}, { projection: { _id: 0 } }).toArray();

        return elements as unknown as T[];
    }

    async getElementsByFilter(filter: Partial<T>): Promise<T[]> {
        const collection = this.getCollection();
        const elements = await collection.find(filter, { projection: { _id: 0 } }).toArray();

        return elements as unknown as T[];
    }

    async getElementById(id: string): Promise<T | null> {
        const collection = this.getCollection();
        const element = await collection.findOne({ id }, { projection: { _id: 0 } });

        if (!element) return null;
        return element as unknown as T;
    }

    async getElementByUsername(username: string): Promise<T | null> {
        const collection = this.getCollection();
        const user = await collection.findOne({ username }, { projection: { _id: 0 } });
        return user ? (user as unknown as T) : null;
    }

    async replaceElement(replacement: T): Promise<boolean> {
        const collection = this.getCollection();
        const idToReplace = replacement.id;

        const result = await collection.replaceOne({ id: idToReplace }, replacement);

        return result.acknowledged;
    }

    async updateElement(filter: Partial<T>, updateData: Partial<T>): Promise<boolean> {
        const collection = this.getCollection();
        const result = await collection.updateOne(filter, { $set: updateData });

        return result.modifiedCount > 0;
    }

    async updateElements(filter: Partial<T>, updateData: Partial<T>): Promise<boolean> {
        const collection = this.getCollection();
        const result = await collection.updateMany(filter, { $set: updateData });

        return result.modifiedCount > 0;
    }

    protected async addElementNoCheck(element: T): Promise<boolean> {
        if (!element.id || element.id == EMPTY_ID) element.id = randomUUID();

        const collection = this.getCollection();
        const result = await collection.insertOne(element as OptionalUnlessRequiredId<T>);
        return result.acknowledged;
    }

    async findElements(query: object): Promise<T[]> {
        const collection = this.getCollection();
        const elements = await collection.find(query, { projection: { _id: 0 } }).toArray();
        return elements as unknown as T[];
    }

    protected getCollection(collectionName?: string) {
        return this.dbAcces.database.collection(collectionName ?? this.collectionName);
    }
}
