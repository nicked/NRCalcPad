//
//  CalculatorNumberFormatter.m
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


#import "CalculatorNumberFormatter.h"

@implementation CalculatorNumberFormatter

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error {
	if ([string length]) {
		NSCharacterSet *symbolChars = [NSCharacterSet characterSetWithCharactersInString:@"+−×÷-*/"];
			//include standard versions of each symbol in case a keyboard is being used

		NSScanner *scanner = [NSScanner scannerWithString:string];

		double total = 0.0;
		[scanner scanDouble:&total];
			//don't fail if we can't read a leading number
			//formula could start with a + or -, in which case assume leading number is 0

		NSString *symbolStr;
		double val;
		
		while ([scanner isAtEnd] == NO) {
			//attempt to read an operator then a number
			if ([scanner scanCharactersFromSet:symbolChars intoString:&symbolStr] == NO
				|| [scanner scanDouble:&val] == NO) {
				return NO;		//TODO: fill errorDescription
			}
			
			unichar symbol = [symbolStr characterAtIndex:0];
			if (symbol == '+') {
				total += val;
			} else if (symbol == L'−' || symbol == '-') {
				total -= val;
			} else if (symbol == L'×' || symbol == '*') {
				total *= val;
			} else if (symbol == L'÷' || symbol == '/') {
				if (!val) return NO;		//div by zero fails
				total /= val;
			}
		}
		if (obj) {
			*obj = @(total);
		}
		return YES;
	}
	return NO;
}

@end
