import { Component } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { ConfirmationModalComponent } from '@app/components/modal/confirmation-modal/confirmation-modal.component';
import { GameLeavingService } from '@app/services/game-services/game-leaving.service';
import { GameStateService } from '@app/services/game-services/game-state.service';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { UserGameRole } from '@common/enums/user-game-role';
import { TranslateService } from '@ngx-translate/core';
import { map } from 'rxjs';

@Component({
	selector: 'app-game-header',
	templateUrl: './game-header.component.html',
	styleUrls: ['./game-header.component.scss']
})
export class GameHeaderComponent {

	get canLeaveSafely() {
		return this.gameLeavingServce.canLeaveSafely$;
	}

	get isOrganizer() {
		return this.gameStateService.getRoleObservable().pipe(map((role) => role === UserGameRole.Organizer));
	}

	constructor(
		private userAuthService: UserAuthenticationService,
		private gameLeavingServce: GameLeavingService,
		private gameStateService: GameStateService,
		private dialog: MatDialog,
		private router: Router,
		private translate: TranslateService,
	) { }

	logout(): void {
		const message = this.translate.instant('LogoutButtonComponenent.ConfirmLogout');
		const dialogRef = this.dialog.open(ConfirmationModalComponent, { data: message, autoFocus: false });
		dialogRef.afterClosed().subscribe((result: boolean) => {
			if (result) {
				this.userAuthService.logOut();
				this.router.navigate(['/login']);
			}
		});
	}

	giveUp() {
		this.router.navigate(['/home']);
	}
}
