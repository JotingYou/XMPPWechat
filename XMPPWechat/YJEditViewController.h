//
//  YJEditViewController.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/8.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJEditViewController;
@protocol YJEditViewControllerDelegate <NSObject>
@optional
-(void)YJEditViewController:(YJEditViewController*)YJEditViewController didfinished:(id)sender;

@end
@interface YJEditViewController : UITableViewController
@property (nonatomic,strong) UITableViewCell *cell;

@property (nonatomic,weak) id<YJEditViewControllerDelegate>delegate;

@end
