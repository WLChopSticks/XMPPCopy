//
//  ViewController.m
//  XMPP
//
//  Created by 王 on 16/3/10.
//  Copyright © 2016年 WLChopSticks. All rights reserved.
//

#import "ViewController.h"
#import "WLCXMPPTool.h"

@interface ViewController ()

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPAutoPing *xmppAutoPing;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XMPPJID *jid = [XMPPJID jidWithUser:@"adium" domain:@"WLChopSticks" resource:nil];
    
    [[WLCXMPPTool sharedXMPPTool]logInWithAccount:jid andPassword:@"123"];

    
}


@end
