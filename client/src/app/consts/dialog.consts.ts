import { Component } from '@angular/core';
import { OrganizerCorrectionComponent } from '@app/components/correction/organizer-correction/organizer-correction.component';
import { PlayerCorrectionComponent } from '@app/components/correction/player-correction/player-correction.component';

export const DIALOG_OPTIONS = {
    disableClose: true,
};

export const SNACK_BAR_DEFAULT_DURATION = 2000;

export type DialogComponent = Component | OrganizerCorrectionComponent | PlayerCorrectionComponent;
