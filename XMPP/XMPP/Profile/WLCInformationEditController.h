//
//  WLCInformationEditController.h
//  XMPP
//
//  Created by 王 on 16/3/10.
//  Copyright © 2016年 WLChopSticks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLCInformationEditController : UITableViewController


@property (assign, nonatomic) BOOL isNickname;
@property (copy, nonatomic) void(^myBlock)();

@end
