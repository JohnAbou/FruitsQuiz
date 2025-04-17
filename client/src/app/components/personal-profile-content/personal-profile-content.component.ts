import { Component } from '@angular/core';
import { PrivateProfileService } from '@app/services/private-profile.service';

@Component({
	selector: 'app-personal-profile-content',
	templateUrl: './personal-profile-content.component.html',
	styleUrls: ['./personal-profile-content.component.scss']
})
export class PersonalProfileContentComponent {
	get currentPage() {
		return this.privateProfileService.currentPage;
	}

	constructor(
		private readonly privateProfileService: PrivateProfileService,
	) { }
}
