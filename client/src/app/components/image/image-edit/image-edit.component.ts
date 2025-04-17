import { Component, EventEmitter, Input, Output, OnInit } from '@angular/core';
import { ImageService } from '@app/services/image-services/image.service';
import { Question } from '@common/interfaces/question';

@Component({
  selector: 'app-image-edit',
  templateUrl: './image-edit.component.html',
  styleUrls: ['./image-edit.component.scss'],
})
export class ImageEditComponent implements OnInit {
  @Input() uploadType: 'question' | 'avatar' = 'question';

  @Input() question: Question
  
  @Output() uploaded: EventEmitter<string> = new EventEmitter<string>();
  @Output() deleted: EventEmitter<void> = new EventEmitter<void>();


  constructor(private imageService: ImageService) {}

  ngOnInit(): void {
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (!input.files || !input.files.length) return;

    const file = input.files[0];
    if (!file.type.startsWith('image/')) {
      console.error('Invalid file type');
      return;
    }
    this.handleImageUpload(file);
  }

  private handleImageUpload(file: File): void {
    const uploadMethod = (() => {
      switch (this.uploadType) {
        case 'question':
          return this.imageService.uploadQuestionImage(file);
        case 'avatar':
          return this.imageService.uploadAvatarImage(file);
      }
    })();
    uploadMethod.subscribe({
      next: (response) => {
        this.uploaded.emit(response.imageId);
      },
      error: (error) =>
        console.error(`${this.uploadType} image upload failed:`, error),
    });
  }

  onDeleteImage(): void {
    if (!this.question.imageId) return;
    this.imageService.deleteImage(this.question.imageId).subscribe({
      next: () => {
        this.deleted.emit();
      },
      error: (error) => console.error('Image deletion failed:', error),
    });
  }
}
