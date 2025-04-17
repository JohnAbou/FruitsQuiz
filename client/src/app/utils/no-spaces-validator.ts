import { AbstractControl, ValidationErrors } from '@angular/forms';

export const noSpacesValidator = (control: AbstractControl): ValidationErrors | null => {
    const value = control.value?.trim();
    if (!value || value.length === 0) {
        return { required: true };
    }
    return null;
};
