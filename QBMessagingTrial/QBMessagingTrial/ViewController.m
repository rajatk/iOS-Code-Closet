//
//  ViewController.m
//  QBMessagingTrial
//
//  Created by Rajat on 1/6/14.
//  Copyright (c) 2014 Codetastic. All rights reserved.
//

#import "ViewController.h"
#import "MsgViewController.h"

@interface ViewController () <QBActionStatusDelegate, QBChatDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (retain) NSTimer *presenceTimer;
@property (strong, nonatomic) NSString *userNameText, *passwordText;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	[QBSettings setLogLevel: QBLogLevelNothing];
	// Do any additional setup after loading the view, typically from a nib.
	
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [QBAuth createSessionWithDelegate:self];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTapped:(id)sender {
	self.userNameText = [self.usernameField text];
	self.userNameText = [self.passwordField text];
	[self loginToQuickblox];
}


-(void)loginToQuickblox{
	// Create session with user
	QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
	extendedAuthRequest.userLogin = self.userNameText;
	extendedAuthRequest.userPassword = self.passwordText;
	[QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

- (void)completedWithResult:(Result *)result{
	
    // Create session result
    if(result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class]){
		// You have successfully created the session
		QBAAuthSessionCreationResult *res = (QBAAuthSessionCreationResult *)result;
		
		// Sign In to QuickBlox Chat
		QBUUser *currentUser = [QBUUser user];
		currentUser.ID = res.session.userID; // your current user's ID
		
		currentUser.password = @"password"; // your current user's password
		
		// set Chat delegate
		[QBChat instance].delegate = self;
		
		// login to Chat
		[[QBChat instance] loginWithUser:currentUser];
		
    }
	else{
		NSString *errorMessage = [[result.errors description] stringByReplacingOccurrencesOfString:@"(" withString:@""];
		errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles: nil];
		[alert show];
		
//		[self.activityIndicatorView stopAnimating];
	}
}

// Chat delegate
-(void) chatDidLogin{
	NSLog(@"chat did login");
	
	[self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:30
														  target:[QBChat instance] selector:@selector(sendPresence)
														userInfo:nil repeats:YES];
	
    // You have successfully signed in to QuickBlox Chat
	MsgViewController *mvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MsgViewController"];
	mvc.view.frame = CGRectMake(0, 0, scrW, scrH);
	mvc.username = self.userNameText;
	[self presentViewController:mvc animated:YES completion:nil];
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    NSLog(@"New message: %@", [message text]);
	//[self didSendText:[message text]];
}
- (IBAction)loginAsUser1:(id)sender {
	self.userNameText = @"user1";
	self.passwordText = @"password";
	[self loginToQuickblox];
}
- (IBAction)loginAsUser2:(id)sender {
	self.userNameText = @"user2";
	self.passwordText = @"password";
	[self loginToQuickblox];
}

@end
