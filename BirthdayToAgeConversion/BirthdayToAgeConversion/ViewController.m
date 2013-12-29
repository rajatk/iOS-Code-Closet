//
//  ViewController.m
//  BirthdayToAgeConversion
//
//  Created by Rajat on 12/29/13.
//  Copyright (c) 2013 Codetastic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (NSInteger)age:(NSDate *)dateOfBirth {
	
	//credits: http://hamishrickerby.com/2010/01/07/calculate-age-in-objective-c/
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
	NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
	
	if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
		(([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
		return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
	} else {
		return [dateComponentsNow year] - [dateComponentsBirth year];
	}
}


-(NSDate*)NSDateFromString:(NSString*)givenDate UsingFormat:(NSString*)dateFormat{
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:dateFormat];
	NSDate *outputDate = [df dateFromString:givenDate];
	
	return outputDate;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedConvertToAge:(id)sender {

	NSDate *inputBirthday = [self NSDateFromString:[self.birthdayTextField text] UsingFormat:@"mm/dd/yyyy"];;
	
	NSString* ageResult = [NSString stringWithFormat:@"%i Years", [self age:inputBirthday]];
	[self.resultLabel setText:ageResult];
}
@end
