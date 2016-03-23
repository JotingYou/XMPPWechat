//
//  YJToolbar.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJToolbar;
@protocol YJToolbarDelegate <NSObject>
@optional
-(void)YJToolbarDidClicked:(YJToolbar*)YJToolbar andItems:(UITabBarItem *)Item;

@end
@interface YJToolbar : UIToolbar
@property (nonatomic,weak) id<YJToolbarDelegate>YJDelegate;

@end
