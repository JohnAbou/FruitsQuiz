import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { MatDialog } from '@angular/material/dialog';
import { AvatarModalComponent } from '@app/components/avatar-modal/avatar-modal.component';

@Injectable({
    providedIn: 'root',
})
export class ModalService {
    avatarOpen: boolean = false;

    private avatarOpenSubject = new BehaviorSubject<boolean>(false);
    private avatarUpdatedSubject = new BehaviorSubject<string | null>(null);

    avatarOpen$ = this.avatarOpenSubject.asObservable();
    avatarUpdated$ = this.avatarUpdatedSubject.asObservable();

    constructor(private dialog: MatDialog) {}

    toggleAvatarModal() {
        this.avatarOpen = !this.avatarOpen;
    }

    openAvatarModal(): void {
        this.dialog.open(AvatarModalComponent);
    }
}
