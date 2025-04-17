import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';

@Component({
    selector: 'app-profile-header',
    templateUrl: './profile-header.component.html',
    styleUrls: ['./profile-header.component.scss'],
})
export class ProfileHeaderComponent {
    @Input() imageUrl: string = './assets/default-profile.png';

    constructor(private router: Router) {}

    navigateToProfile() {
        this.router.navigate(['/public-profile']);
    }
}
