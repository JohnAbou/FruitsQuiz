import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { UserAuthenticationService } from '@app/services/user-authentication.service';

@Injectable({
    providedIn: 'root',
})
export class AuthenticationAuthGardService {
    constructor(
        private readonly userAuthService: UserAuthenticationService,
        private readonly router: Router,
    ) {}

    canActivate() {
        const isAuthenticated = this.userAuthService.isUserAuthenticated();
        if (!isAuthenticated) this.router.navigate(['/login']);
        return isAuthenticated;
    }
}
