import * as fs from 'fs';
import * as path from 'path';
import { promisify } from 'util';
import { Db, GridFSBucket, MongoClient, ServerApiVersion } from 'mongodb';
import * as sharp from 'sharp';

const DATABASE_URL = 'mongodb+srv://default:i888xMq7vC49sMjA@cluster0.n8xzzlq.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';
const DATABASE_NAME = 'Project2990';

interface ImageMetadata {
    type: 'question' | 'avatar';
    createdAt: Date;
}

interface ImageUploadResult {
    filename: string;
    objectId: string;
}

const readFile = promisify(fs.readFile);
const readdir = promisify(fs.readdir);
const stat = promisify(fs.stat);

class DataBaseAcces {
    client: MongoClient;
    database: Db;

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
    }
}

class ImageService {
    private gridFSBucket: GridFSBucket | undefined;

    constructor(private databaseAccess: DataBaseAcces) { }

    private ensureBucketInitialized(): void {
        if (!this.databaseAccess.database) {
            throw new Error('Database is not initialized');
        }
        if (!this.gridFSBucket) {
            this.gridFSBucket = new GridFSBucket(this.databaseAccess.database, {
                bucketName: 'images', // Make sure this matches how you uploaded the images
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
                .jpeg({ quality: 80 })
                .toBuffer();

            this.ensureBucketInitialized();

            const uploadStream = this.gridFSBucket!.openUploadStream(fileName, { metadata });
            uploadStream.end(processedBuffer);

            return await new Promise<string>((resolve, reject) => {
                uploadStream.on('finish', () => resolve(uploadStream.id.toString()));
                uploadStream.on('error', (err) => reject(new Error(`Upload error: ${err.message}`)));
            });
        } catch (error: any) {
            throw new Error(`Error processing image: ${error.message}`);
        }
    }

    /**
     * Process and compress an image for a user avatar.
     * Resizes the image to fixed dimensions of 200x200px.
     * @param buffer The received image buffer.
     * @returns The ID of the processed avatar image.
     */
    async processAvatarImage(buffer: Buffer, id?: string): Promise<string> {
        const fileName = id + '.jpeg';
        const metadata: ImageMetadata = { type: 'avatar', createdAt: new Date() };
        const resizeOptions = { width: 200, height: 200 };
        return this.processAndUploadImage(buffer, fileName, resizeOptions, metadata);
    }
}

/**
 * Checks if the file has a valid image extension
 */
function isImageFile(filename: string): boolean {
    const validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    const ext = path.extname(filename).toLowerCase();
    return validExtensions.includes(ext);
}

/**
 * Script to save multiple images from a folder to GridFS using ImageService
 * 
 * Usage: 
 * - Run with: node save-images.js <folderPath>
 */
async function saveImagesFromFolder() {
    try {
        const args = process.argv.slice(2);

        if (args.length < 1) {
            console.error('Usage: node save-images.js <folderPath>');
            process.exit(1);
        }

        const folderPath = args[0];
        
        // Verify the folder exists
        const folderStat = await stat(folderPath);
        if (!folderStat.isDirectory()) {
            console.error(`Error: ${folderPath} is not a directory`);
            process.exit(1);
        }

        console.log(`Processing images from folder: ${folderPath}`);

        // Connect to database
        const dbAcces = new DataBaseAcces();
        await dbAcces.connectToServer();
        const imageService = new ImageService(dbAcces);

        // Read all files in the directory
        const files = await readdir(folderPath);
        const imageFiles = files.filter(isImageFile);

        if (imageFiles.length === 0) {
            console.log('No image files found in the specified folder.');
            process.exit(0);
        }

        console.log(`Found ${imageFiles.length} image files. Processing...`);

        // Process all images
        const results: ImageUploadResult[] = [];
        
        for (const file of imageFiles) {
            const filePath = path.join(folderPath, file);
            const fileBaseName = path.basename(file, path.extname(file));
            
            console.log(`Processing: ${file}`);
            
            try {
                const imageBuffer = await readFile(filePath);
                const objectId = await imageService.processAvatarImage(imageBuffer, fileBaseName);
                
                results.push({
                    filename: fileBaseName,
                    objectId: objectId
                });
                
                console.log(`✓ Processed ${file} - ID: ${objectId}`);
            } catch (error) {
                console.error(`× Failed to process ${file}:`, error);
            }
        }

        // Log the results
        console.log('\n=== Upload Results ===');
        console.log('Total files processed:', results.length);
        
        // Create a Map of filename to ObjectId
        const avatarIdsMap = new Map<string, string>();
        
        console.log('\nFilename to ObjectId mapping:');
        results.forEach(result => {
            avatarIdsMap.set(result.filename, result.objectId);
            console.log(`${result.filename}: ${result.objectId}`);
        });
        
        // Output JavaScript code for the Map
        console.log('\nJavaScript Map declaration:');
        console.log(`const AvatarIds = new Map([`);
        results.forEach((result, index) => {
            const comma = index < results.length - 1 ? ',' : '';
            console.log(`  ['${result.filename}', '${result.objectId}']${comma}`);
        });
        console.log(`]);`);
        
        await dbAcces.client.close();
        console.log('\nDatabase connection closed.');
        process.exit(0);

    } catch (error) {
        console.error('Error processing images:', error);
        process.exit(1);
    }
}

// Run the script
saveImagesFromFolder();