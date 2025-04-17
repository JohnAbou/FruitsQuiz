import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

@Injectable({
    providedIn: 'root',
})
export class PrivateProfileService {

    currentPage: string = 'information';

    constructor(private readonly router: Router) {}

    setCurrentPage(currentPage: string) {
        this.currentPage = currentPage;
    }

    goToPage(currentPage: string) {
        this.setCurrentPage(currentPage);
        this.router.navigate(['/public-profile']); // TODO: add the real route
    }
}
