import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ConfirmationModalComponent } from '../confirmation-modal/confirmation-modal.component';

@Component({
  selector: 'app-elimination-modal',
  templateUrl: './elimination-modal.component.html',
  styleUrls: ['./elimination-modal.component.scss']
})
export class EliminationModalComponent implements OnInit {
  message: string

  constructor(
    public dialogRef: MatDialogRef<ConfirmationModalComponent>,
    @Inject(MAT_DIALOG_DATA) message: string,
  ) {
    this.message = message;
  }

  ngOnInit(): void {
    setTimeout(() => {
      const modal = document.querySelector('.modal-container');
      if (modal) {
        modal.classList.add('exit-animation');
        setTimeout(() => this.closeModal(), 500);
      } else {
        this.closeModal();
      }
    }, 3000);
  }
  

  closeModal(): void {
    this.dialogRef.close();
  }
}
