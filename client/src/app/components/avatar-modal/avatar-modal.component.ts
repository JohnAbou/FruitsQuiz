import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { UserInfoService } from '@app/services/user-info.service';
import { getAvatarSource } from '@app/utils/avatar';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { LockedItemDialogComponent } from '../locked-item-dialog/locked-item-dialog';
import { Router } from '@angular/router';

interface AvatarOption {
  id: string;
  image: string;
  locked: boolean;
}

@Component({
  selector: 'app-avatar-modal',
  templateUrl: './avatar-modal.component.html',
  styleUrls: ['./avatar-modal.component.scss'],
})
export class AvatarModalComponent {
  basicAvatars: string[];
  premiumAvatars: AvatarOption[] = [];
  selectedAvatar: string | null = null;
  uploadedFile: File | null = null;
  uploadedPreview: string | null = null;
  private apiBaseUrl = environment.serverUrl;

  constructor(
    public dialogRef: MatDialogRef<AvatarModalComponent>,
    private userInfoService: UserInfoService,
    private http: HttpClient,
    private dialog: MatDialog, 
    private router: Router,  
    @Inject(MAT_DIALOG_DATA) public data: any
  ) {
    this.basicAvatars = data.avatars;
    this.loadPremiumAvatars();
  }

  loadPremiumAvatars(): void {
    const userId = this.userInfoService.user?.id;
    if (!userId) return;

    this.http.get<any>(`${this.apiBaseUrl}/shop/${userId}`).subscribe({
      next: (shop) => {
        if (shop?.items) {
          this.premiumAvatars = [
            { id: 'premium_lemon_avatar', image: 'assets/avatars/premium_lemon_avatar.png', locked: !this.isPurchased(shop.items, 'Premium Lemon Avatar') },
            { id: 'premium_orange_avatar', image: 'assets/avatars/premium_orange_avatar.png', locked: !this.isPurchased(shop.items, 'Premium Orange Avatar') },
            { id: 'golden_blueberry_avatar', image: 'assets/avatars/golden_blueberry_avatar.png', locked: !this.isPurchased(shop.items, 'Golden Blueberry Avatar') },
            { id: 'golden_lemon_avatar', image: 'assets/avatars/golden_lemon_avatar.png', locked: !this.isPurchased(shop.items, 'Golden Lemon Avatar') },
            { id: 'golden_watermelon_avatar', image: 'assets/avatars/golden_watermelon_avatar.png', locked: !this.isPurchased(shop.items, 'Golden Watermelon Avatar') }
          ];
        }
      },
      error: (err) => {
        console.error('Error loading shop items:', err);
      }
    });
  }

  private isPurchased(items: any[], name: string): boolean {
    return items.some(item => item.name === name && item.state === 1);
  }

  getSource(avatarId: string) {
    return getAvatarSource(avatarId);
  }

  selectAvatar(avatar: string) {
    this.selectedAvatar = avatar;
    this.uploadedFile = null;
    this.uploadedPreview = null;
  }

  selectPremiumAvatar(avatar: AvatarOption) {
    if (!avatar.locked) {
      this.selectedAvatar = avatar.id;
      this.uploadedFile = null;
      this.uploadedPreview = null;
    } else {
      this.openLockedItemDialog();
    }
  }

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      this.uploadedFile = input.files[0];
      const reader = new FileReader();
      reader.onload = () => this.uploadedPreview = reader.result as string;
      reader.readAsDataURL(this.uploadedFile);

      this.selectedAvatar = null;
    }
  }

  saveAvatar() {
    if (this.selectedAvatar) {
      this.userInfoService.setPredefinedAvatar(this.selectedAvatar).subscribe(() => {
        this.dialogRef.close(this.selectedAvatar);
      });
    } else if (this.uploadedFile) {
      this.userInfoService.updateUserAvatar(this.uploadedFile).subscribe(response => {
        this.dialogRef.close(response.avatarId);
      });
    }
  }

  closeModal() {
    this.dialogRef.close();
  }

  openLockedItemDialog(): void {
    const dialogRef = this.dialog.open(LockedItemDialogComponent, {
      width: '350px',
      panelClass: 'locked-item-dialog'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dialogRef.close();
        this.router.navigate(['/shop']);
      }
    });
  }
}
