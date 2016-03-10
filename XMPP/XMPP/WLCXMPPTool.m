//
//  WLCXMPPTool.m
//  XMPP
//
//  Created by 王 on 16/3/10.
//  Copyright © 2016年 WLChopSticks. All rights reserved.
//

#import "WLCXMPPTool.h"

@interface WLCXMPPTool ()<XMPPStreamDelegate, XMPPAutoPingDelegate, XMPPReconnectDelegate, XMPPvCardTempModuleDelegate>

@property (strong, nonatomic) XMPPJID *userJID;
@property (strong, nonatomic) NSString *userPassWord;

@end

static WLCXMPPTool *_INSTANCE;
@implementation WLCXMPPTool

//创建单例
+(instancetype)sharedXMPPTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _INSTANCE= [[WLCXMPPTool alloc]init];
    });
    return _INSTANCE;
}

-(void)logInWithAccount:(XMPPJID *)jid andPassword:(NSString *)pwd {
    
    XMPPStream *stream = [[XMPPStream alloc]init];
    self.xmppStream = stream;
    //保存用户账号密码
    self.userJID = jid;
    self.userPassWord = pwd;
    
    stream.hostName = @"127.0.0.1";
    stream.hostPort = 5222;
    [stream setMyJID:jid];
    
    [stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //链接
    [stream connectWithTimeout:-1 error:nil];
    
    //打开log
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    
    //开启心跳检测
    [self turnOnHeartBeat];
    
    //开启自动重连
    [self turnOnReconnect];
    
    //获取个人信息
    [self getProfileInformation];

}

//心跳检测
-(void)turnOnHeartBeat {

    XMPPAutoPing *autoPing = [[XMPPAutoPing alloc]initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.xmppAutoPing = autoPing;
    [autoPing addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    autoPing.pingInterval = 1;
    autoPing.pingTimeout = 200;
    autoPing.respondsToQueries = YES;
    
    [autoPing activate:self.xmppStream];
}
//自动重连
-(void)turnOnReconnect {
    
    //自动重连
    XMPPReconnect *reconnect = [[XMPPReconnect alloc]initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.xmppReconnect = reconnect;
    [reconnect addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //貌似不用设置此参数也可用自动重连
    reconnect.autoReconnect = YES;
    reconnect.reconnectTimerInterval = 2;
    
    [reconnect activate:self.xmppStream];
}

//获取个人信息
-(void)getProfileInformation {
    
    XMPPvCardTempModule *vCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.xmppvCardTempModule = vCardTempModule;
    [vCardTempModule addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [vCardTempModule activate:self.xmppStream];
    //获取头像
//    XMPPvCardAvatarModule *vCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:vCardTempModule dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//    self.xmppvCardAvatarModule = vCardAvatarModule;
//    [vCardAvatarModule activate:self.xmppStream];
    
    
    
}


#pragma -mark xmpp代理方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"连接成功");
    
    //输入密码做授权
    XMPPPlainAuthentication *plainAuth = [[XMPPPlainAuthentication alloc]initWithStream:self.xmppStream password:self.userPassWord];
    [self.xmppStream authenticate:plainAuth error:nil];
    
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"授权成功");
    //改变登录状态
    XMPPPresence *presence = [[XMPPPresence alloc]initWithName:@"presence"];
    [presence addAttributeWithName:@"type" stringValue:@"available"];
    
    XMPPElement *childChat = [XMPPElement elementWithName:@"show" stringValue:@"chat"];
    [presence addChild:childChat];
    XMPPElement *childStatus = [XMPPElement elementWithName:@"status" stringValue:@"来吧"];
    [presence addChild:childStatus];
    
    [self.xmppStream sendElement:presence];
    
}

-(void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence {
    NSLog(@"%@",presence);
}

#pragma -mark xmpp autoPing代理方法
-(void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender {
    NSLog(@"未连接,链接超时");
}

#pragma -mark xmppvCardTempModule代理方法
- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    NSLog(@"didReceivevCardTemp");
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    
    NSLog(@"xmppvCardTempModuleDidUpdateMyvCard");
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error
{
    NSLog(@"failedToUpdateMyvCard");
}




@end
