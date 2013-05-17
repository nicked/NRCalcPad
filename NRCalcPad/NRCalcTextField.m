//
//  NRCalcTextField.m
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


#import "NRCalcTextField.h"

static CGFloat const kCalcButtonWidth = 80.0f;
static CGFloat const kCalcButtonHeight = 40.0f;
static int const kCalcButtonCount = 4;


@interface NRCalcTextField ()
@property (nonatomic, strong) UIView *calculatorButtonContainer;
@property (nonatomic, strong) UIView *originalInputAccessoryView;
@end


@implementation NRCalcTextField

@synthesize lastCalculatedResult = _lastCalculatedResult;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self addCalculatorControls];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self addCalculatorControls];
	}
	return self;
}


- (void)addCalculatorControls {
	//Creates a row of calculator buttons and adds them as the inputAccessoryView of the text field
	
	NSAssert([UIImage imageNamed:@"button-off"] && [UIImage imageNamed:@"button-on"], @"Button images were not included in project");

	self.keyboardType = UIKeyboardTypeDecimalPad;
	
	self.calculatorButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, kCalcButtonHeight)];

	UIButton *calcButton = nil;
	NSArray *symbols = @[@"+", @"−", @"×", @"÷"];
	for (int x = 0; x < kCalcButtonCount; x++) {
		calcButton = [[UIButton alloc] initWithFrame:CGRectMake(kCalcButtonWidth * x, 0.0f, kCalcButtonWidth, kCalcButtonHeight)];
		[calcButton setTitle:symbols[x] forState:UIControlStateNormal];
		[calcButton setBackgroundImage:[UIImage imageNamed:@"button-off"] forState:UIControlStateNormal];
		[calcButton setBackgroundImage:[UIImage imageNamed:@"button-on"] forState:UIControlStateHighlighted];
		calcButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
		calcButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
		[calcButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[calcButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[calcButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
		calcButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

		[calcButton addTarget:self action:@selector(calcButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

		[self.calculatorButtonContainer addSubview:calcButton];
	}
	self.inputAccessoryView = self.calculatorButtonContainer;
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
	//if another inputAccessoryView is added to the text field, add it above the row of calculator buttons
	
	if (inputAccessoryView != self.inputAccessoryView) {
		if (inputAccessoryView == self.calculatorButtonContainer) {
			[super setInputAccessoryView:inputAccessoryView];
		} else {
			[self.originalInputAccessoryView removeFromSuperview];
			self.calculatorButtonContainer.frame = CGRectMake(0.0f, 0.0f, 320.0f, kCalcButtonHeight + inputAccessoryView.frame.size.height);
			self.originalInputAccessoryView = inputAccessoryView;
			[self.calculatorButtonContainer addSubview:inputAccessoryView];
		}
	}
}


- (void)calcButtonTapped:(UIButton *)sender {
	//enter the text of the tapped button into the text field
	
	[self replaceRange:self.selectedTextRange withText:sender.currentTitle];
}

- (CalculatorNumberFormatter *)numberFormatter {
	if (_numberFormatter == nil) {
		_numberFormatter = [[CalculatorNumberFormatter alloc] init];
		[_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[_numberFormatter setLenient:YES];
	}
	return _numberFormatter;
}

- (void)calculateResult {
	//takes the current contents of the text field, attempts to evaluate it as a formula,
	//and writes the result back into the text field
	
	NSNumber *output;
	BOOL ok = [self.numberFormatter getObjectValue:&output forString:self.text errorDescription:nil];
	if (ok && output) {
		_lastCalculatedResult = [output doubleValue];
		self.text = [self.numberFormatter stringForObjectValue:output];
	} else {
		_lastCalculatedResult = 0.0;
		self.text = @"";
	}
}

@end
