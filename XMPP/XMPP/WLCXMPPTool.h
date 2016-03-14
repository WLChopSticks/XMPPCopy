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

//个人名片
//个人名片模块
#import "XMPPvCardTempModule.h"
//头像模块
#import "XMPPvCardAvatarModule.h"
//数据存储
#import "XMPPvCardCoreDataStorage.h"
//数据模型
#import "XMPPvCardTemp.h"

//好友列表
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

@interface WLCXMPPTool : NSObject

//属性
@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPAutoPing *xmppAutoPing;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;
@property (strong, nonatomic) XMPPvCardTempModule *xmppvCardTempModule;
@property (strong, nonatomic) XMPPRoster *xmppRoster;
@property (strong, nonatomic) XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;
@property (strong, nonatomic) XMPPvCardAvatarModule *xmppvCardAvatarModule;


//方法
//单例
+(instancetype)sharedXMPPTool;

//连接服务器并登录
-(void)logInWithAccount: (XMPPJID *)jid andPassword: (NSString *)pwd;

@end
