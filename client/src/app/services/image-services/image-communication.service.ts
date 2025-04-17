import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import {ImageUploadResponse} from '@common/interfaces/response/image-upload-response' 

@Injectable({
  providedIn: 'root'
})

export class ImageCommunicationService {

  constructor(private http: HttpClient) {}

  uploadQuestionImage(file: File): Observable<ImageUploadResponse> {
    const formData = new FormData();
    formData.append('image', file);
    return this.http.post<ImageUploadResponse>(`${environment.serverUrl}/image/question/upload`, formData);
  }

  uploadAvatarImage(file: File): Observable<ImageUploadResponse> {
    const formData = new FormData();
    formData.append('image', file);
    return this.http.post<ImageUploadResponse>(`${environment.serverUrl}/image/avatar/upload`, formData);
  }

  deleteImage(imageId: string): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`${environment.serverUrl}/image/${imageId}`);
  }
}
