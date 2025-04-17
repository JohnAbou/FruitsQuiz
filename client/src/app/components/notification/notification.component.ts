import { Component, Inject } from '@angular/core';
import { MAT_SNACK_BAR_DATA, MatSnackBarRef } from '@angular/material/snack-bar';

@Component({
	selector: 'app-notification',
	templateUrl: './notification.component.html',
	styleUrls: ['./notification.component.scss']
})
export class NotificationComponent {

	constructor(
		@Inject(MAT_SNACK_BAR_DATA) public data: {
			message: string,
			icon: string
			arrowCallback?: () => void;
		},
		public snackBarRef: MatSnackBarRef<NotificationComponent>
	) { }

	callback() {
		this.data.arrowCallback?.();
		this.snackBarRef.dismiss();
	}
}
