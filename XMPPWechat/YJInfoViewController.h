//
//  YJInfoViewController.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/7.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJInfoViewController;
@protocol YJInfoViewControllerDelegate <NSObject>
@optional
-(void)YJInfoViewControllerDidChange:(YJInfoViewController*)YJInfoViewController;

@end
@interface YJInfoViewController : UITableViewController
@property (nonatomic,weak) id<YJInfoViewControllerDelegate>delegate;

@end
