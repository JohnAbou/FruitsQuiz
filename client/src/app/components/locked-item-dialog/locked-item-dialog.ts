import { Component } from '@angular/core';

@Component({
  selector: 'app-locked-item-dialog',
  template: `
    <h2 mat-dialog-title align = "center">{{ 'PreferencesComponent.ItemLocked' | translate }}</h2>
    <div mat-dialog-content align ="center">
      <p>{{ 'PreferencesComponent.VisitShop' | translate }}</p>
    </div>
    <div mat-dialog-actions align="center">
      <button mat-raised-button color="primary" [mat-dialog-close]="true">
        {{ 'PreferencesComponent.GoShop' | translate }}
      </button>
      <button mat-button [mat-dialog-close]="false">
        {{ 'PreferencesComponent.Cancel' | translate }}
      </button>
    </div>
  `
})
export class LockedItemDialogComponent {}
