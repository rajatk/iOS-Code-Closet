//
//  ViewController.h
//  BirthdayToAgeConversion
//
//  Created by Rajat on 12/29/13.
//  Copyright (c) 2013 Codetastic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
- (IBAction)tappedConvertToAge:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

-(NSDate*)NSDateFromString:(NSString*)givenDate UsingFormat:(NSString*)dateFormat;

@end
