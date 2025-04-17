import { Component, Input, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
	selector: 'app-floating-text-input',
	templateUrl: './floating-text-input.component.html',
	styleUrls: ['./floating-text-input.component.scss'],
	providers: [
		{
			provide: NG_VALUE_ACCESSOR,
			useExisting: forwardRef(() => FloatingTextInputComponent),
			multi: true
		}
	]
})
export class FloatingTextInputComponent implements ControlValueAccessor {
	@Input() label: string;

	value: string;
	disabled: boolean = false;

	onChange = (value: string) => { };
	onTouched = () => { };

	writeValue(value: string): void {
		this.value = value;
	}

	registerOnChange(fn: any): void {
		this.onChange = fn;
	}

	registerOnTouched(fn: any): void {
		this.onTouched = fn;
	}

	setDisabledState(isDisabled: boolean): void {
		this.disabled = isDisabled;
	}

	onInputChange(event: any): void {
		this.value = event.target.value;
		this.onChange(this.value);
	}
}