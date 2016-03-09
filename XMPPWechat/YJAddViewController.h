//
//  YJAddViewController.h
//  individual contant
//
//  Created by 姚家庆 on 15/12/10.
//  Copyright © 2015年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJAddViewController,YJContant;
@protocol addViewControllerDelegate <NSObject>
@optional
-(void)addViewController:(YJAddViewController*)addvc didSaveContact:(YJContant *)contact;

@end
@interface YJAddViewController : UIViewController
@property (nonatomic,weak) id<addViewControllerDelegate>delegete;
@property (nonatomic,strong) YJContant *contact;

@end
