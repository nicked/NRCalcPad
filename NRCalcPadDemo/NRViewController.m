//
//  NRViewController.m
//
//  Created by Nick Randall on 16/05/13.
//  Copyright (c) 2013 Pinion Systems.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.


#import "NRViewController.h"
#import "NRCalcTextField.h"


@interface NRViewController ()
@property (nonatomic, strong) NRCalcTextField *textField;
@end


@implementation NRViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.textField = [[NRCalcTextField alloc] initWithFrame:CGRectMake(60.0f, 80.0f, 200.0f, 30.0f)];
	self.textField.delegate = self;
	self.textField.borderStyle = UITextBorderStyleRoundedRect;
	self.textField.textAlignment = UITextAlignmentRight;
	self.textField.clearsOnBeginEditing = YES;
	
	//set the number format of the result if desired
	//this example outputs currency with cents

	[self.textField.numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[self.textField.numberFormatter setMaximumFractionDigits:2];
	

	//works with any existing inputAccessoryView on your text field
	//this example creates a toolbar with a Done button
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								   target:self
								   action:@selector(doneTapped)];
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	toolbar.items = @[
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
		doneButton,
	];
	
	//your inputAccessoryView will be displayed above the calculator buttons
	self.textField.inputAccessoryView = toolbar;
	
	
	[self.view addSubview:self.textField];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.textField becomeFirstResponder];
}


- (void)doneTapped {
	[self.textField resignFirstResponder];
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField isKindOfClass:[NRCalcTextField class]]) {
		NRCalcTextField *calcTextField = (NRCalcTextField *)textField;
	
		//call this to replace the entered formula with the formatted result
		[calcTextField calculateResult];
	
		//you can access the last result with the lastCalculatedResult property
		NSLog(@"Last calculated result = %f", calcTextField.lastCalculatedResult);
	}
}



@end
