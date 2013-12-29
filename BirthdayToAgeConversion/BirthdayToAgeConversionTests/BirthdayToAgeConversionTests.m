//
//  BirthdayToAgeConversionTests.m
//  BirthdayToAgeConversionTests
//
//  Created by Rajat on 12/29/13.
//  Copyright (c) 2013 Codetastic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface BirthdayToAgeConversionTests : XCTestCase
@property ViewController *viewController;
@end

@implementation BirthdayToAgeConversionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	self.viewController = [ViewController new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testDateFromString
{
	NSString *testDate = @"03/31/1992";
	NSString *dateFormat = @"dd/mm/yyyy";
	
	XCTAssertNotNil([self.viewController NSDateFromString:testDate UsingFormat:dateFormat], @"NSDateFromString returned nil");
}


@end
