//
//  YJChatViewController.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/14.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPJID;
@interface YJChatViewController : UIViewController
@property (nonatomic,strong) XMPPJID *friendJid;
@end
