//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "MsgViewController.h"


@implementation MsgViewController
NSInteger recepientID = 761567;
//user1: 761567
//user2: 761568

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.title = @"Messages";
	[QBChat instance].delegate = self;
    
    self.messageInputView.textView.placeHolder = @"New Message";
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.messages = [[NSMutableArray alloc] init];
    
    self.timestamps = [[NSMutableArray alloc] init];
    self.senderOfMsg = [[NSMutableArray alloc] init];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
//                                                                                           target:self
//                                                                                           action:@selector(buttonPressed:)];
}

- (void)buttonPressed:(UIButton *)sender
{
    // Testing pushing/popping messages view
    MsgViewController *vc = [[MsgViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate: REQUIRED


- (void)chatDidReceiveMessage:(QBChatMessage *)message{
	 NSLog(@"New msg message: %@", [message text]);
	
//    NSLog(@"New message: ", message);
	[self displayReceivedText:[message text]];
}

-(void)displayReceivedText:(NSString *)text{
	[self.messages addObject:text];
	[self.timestamps addObject:[NSDate date]];
    [self.senderOfMsg addObject:@"other"];
    
	[JSMessageSoundEffect playMessageReceivedSound];
	
    
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)didSendText:(NSString *)text
{
    [self.messages addObject:text];
	[self.senderOfMsg addObject:@"self"];
	
	QBChatMessage *message = [QBChatMessage message];
	message.recipientID = recepientID; // opponent's id
	message.text = text;
	//[message setCustomParameters:@{@"playSound": @YES}];
	[[QBChat instance] sendMessage:message];
	
    [self.timestamps addObject:[NSDate date]];
    
	[JSMessageSoundEffect playMessageSentSound];

    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([[self.senderOfMsg objectAtIndex:indexPath.row] isEqualToString:@"other"])
		return JSBubbleMessageTypeIncoming;
	
	return JSBubbleMessageTypeOutgoing;
	
//    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if([[self.senderOfMsg objectAtIndex:indexPath.row] isEqualToString:@"other"])
		return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
	
	return [JSBubbleImageViewFactory bubbleImageViewForType:type
															 color:[UIColor js_bubbleBlueColor]];;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyNone;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    
        if([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:UITextAttributeTextColor];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if(cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if(cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
}

//  *** Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
//  - (UIButton *)sendButtonForInputView
//

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *subtitle = [self.subtitles objectAtIndex:indexPath.row];
    UIImage *image = [self.avatars objectForKey:subtitle];
    return [[UIImageView alloc] initWithImage:image];
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.subtitles objectAtIndex:indexPath.row];
}

@end
