import { Component, OnDestroy } from '@angular/core';
import { ModalService } from '@app/services/modal.service';
import { UserInfoService } from '@app/services/user-info.service';
import { PrivateProfileService } from '@app/services/private-profile.service';
import { AvatarModalComponent } from '../avatar-modal/avatar-modal.component';
import { MatDialog } from '@angular/material/dialog';
import { map } from 'rxjs';
import { getAvatarSource } from '@app/utils/avatar';

@Component({
    selector: 'app-sidebar',
    templateUrl: './sidebar-profile.component.html',
    styleUrls: ['./sidebar-profile.component.scss'],
})
export class SidebarComponent implements OnDestroy {
    get avatarUrl() {
        return this.userInfoService.userObservable
            .pipe(map(user => getAvatarSource(user.activeAvatarId)));
    }

    get currentPage() {
        return this.privateProfileService.currentPage;
    }

    constructor(
        private readonly privateProfileService: PrivateProfileService,
        private readonly modalService: ModalService,
        private readonly userInfoService: UserInfoService,
        private dialog: MatDialog,
    ) { }

    get avatarOpen() {
        return this.modalService.avatarOpen;
    }

    ngOnDestroy() {
        this.privateProfileService.setCurrentPage('information');
    }

    setActivePage(page: string) {
        this.privateProfileService.setCurrentPage(page);
    }

    openAvatarChange() {
        this.dialog.open(AvatarModalComponent, {
            data: { avatars: this.userInfoService.user.avatarIds },
        });
    }
}

