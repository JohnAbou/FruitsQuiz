import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-real-public-profile-page',
  templateUrl: './real-public-profile-page.component.html',
  styleUrls: ['./real-public-profile-page.component.scss'],
})
export class RealPublicProfilePageComponent implements OnInit, OnDestroy {
  userId: string = '';
  private subscription: Subscription;

  constructor(private readonly route: ActivatedRoute) { }

  ngOnInit(): void {
    this.subscription = this.route.paramMap.subscribe(params => {
      this.userId = params.get('id') ?? '';
    });
  }

  ngOnDestroy(): void {
    this.subscription?.unsubscribe();
  }
}

