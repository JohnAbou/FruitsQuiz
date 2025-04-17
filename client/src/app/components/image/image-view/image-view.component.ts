import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { ImageService } from '@app/services/image-services/image.service';

@Component({
  selector: 'app-image-view',
  templateUrl: './image-view.component.html',
  styleUrls: ['./image-view.component.scss'],
})
export class ImageViewComponent implements OnChanges {
  @Input() imageId?: string;
  @Input() uploadType: 'question' | 'avatar' = 'question';

  constructor(private imageService: ImageService) {}

  imageUrl = '';
  zoomed = false;

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.imageId || changes.uploadType) {
      this.updateImageUrl();
    }
  }

  private updateImageUrl(): void {
    if (!this.imageId) {
      this.imageUrl = '';
      return;
    }
    
    this.imageUrl =
      this.uploadType === 'question'
        ? this.imageService.getQuestionImageUrl(this.imageId)
        : this.imageService.getAvatarImageUrl(this.imageId);
  }

  zoomIn(): void {
    this.zoomed = true;
  }

  zoomOut(): void {
    this.zoomed = false;
  }
}
