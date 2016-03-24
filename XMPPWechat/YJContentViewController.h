//
//  YJContentViewController.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJContentViewController;
@protocol YJContentViewControllerDelegate <NSObject>
@optional
-(void)YJContentViewController:(YJContentViewController*)ContentViewController didFinishedPublish:(id)sender;

@end
@interface YJContentViewController : UIViewController
@property (nonatomic,weak) id<YJContentViewControllerDelegate>delegate;

@end
