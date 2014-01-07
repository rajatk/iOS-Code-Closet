//
//  ViewController.m
//  ParsePushTrial
//
//  Created by Rajat on 1/6/14.
//  Copyright (c) 2014 Codetastic. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	PFObject *obj = [PFObject objectWithClassName:@"testclass"];
	[obj setObject:@"foo" forKey:@"bar"];
	[obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		NSLog(@"save success");
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
