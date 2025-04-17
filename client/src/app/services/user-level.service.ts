import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { UserAuthenticationService } from './user-authentication.service';
import { UserExperienceInfo } from '@common/interfaces/user-experience';

@Injectable({
    providedIn: 'root',
})
export class UserLevelService {
    constructor(
        private readonly httpClient: HttpClient,
        private readonly authService: UserAuthenticationService,
    ) {}

    getUserExpInfo() {
        return this.httpClient.get<UserExperienceInfo>(`${environment.serverUrl}/accounts/me/exp-info`, {
          headers: this.authService.getSessionIdHeaders(),
          observe: 'body',
          responseType: 'json',
        });
      }
      
      getUserExpInfoById(id: string) {
        return this.httpClient.get<UserExperienceInfo>(`${environment.serverUrl}/accounts/id/${id}/exp-info`, {
            headers: this.authService.getSessionIdHeaders(),
            observe: 'body',
            responseType: 'json',
        });
    }
    
      
}
