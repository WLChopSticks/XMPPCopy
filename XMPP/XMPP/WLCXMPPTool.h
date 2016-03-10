//
//  WLCXMPPTool.h
//  XMPP
//
//  Created by 王 on 16/3/10.
//  Copyright © 2016年 WLChopSticks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
//log部分
#import "XMPPLogging.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
//心跳检测
#import "XMPPAutoPing.h"
//自动重连
#import "XMPPReconnect.h"

@interface WLCXMPPTool : NSObject

//属性
@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPAutoPing *xmppAutoPing;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;

//方法
//单例
+(instancetype)sharedXMPPTool;

//连接服务器并登录
-(void)logInWithAccount: (XMPPJID *)jid andPassword: (NSString *)pwd;

@end
