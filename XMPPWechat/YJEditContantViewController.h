//
//  YJEditContantViewController.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/9.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJEditContantViewController,YJContant;
@protocol YJEditContantViewControllerDelegate <NSObject>
@optional
-(void)YJEditContantViewController:(YJEditContantViewController*)edvc didEditContact:(YJContant*)contact;

@end
@interface YJEditContantViewController : UIViewController
@property (nonatomic,weak) id<YJEditContantViewControllerDelegate>delegate;
@property (nonatomic,strong) YJContant *contact;
@end
