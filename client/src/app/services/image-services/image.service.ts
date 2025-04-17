import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ImageCommunicationService } from './image-communication.service';
import { environment } from 'src/environments/environment';
import { ImageUploadResponse } from '@common/interfaces/response/image-upload-response';

@Injectable({
  providedIn: 'root'
})
export class ImageService {

  constructor(private imageCommService: ImageCommunicationService) {}

  uploadQuestionImage(file: File): Observable<ImageUploadResponse> {
    return this.imageCommService.uploadQuestionImage(file);
  }

  uploadAvatarImage(file: File): Observable<ImageUploadResponse> {
    return this.imageCommService.uploadAvatarImage(file);
  }

  deleteImage(imageId: string): Observable<{ message: string }> {
    return this.imageCommService.deleteImage(imageId);
  }

  getQuestionImageUrl(imageId: string): string {
    return `${environment.serverUrl}/image/question/${imageId}`;
  }
  getAvatarImageUrl(imageId: string): string {
    return `${environment.serverUrl}/image/avatar/${imageId}`;
  }
}
