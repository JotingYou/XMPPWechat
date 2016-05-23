//
//  YJCellFrame.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/5/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define YJTitleFont 14
#define YJDetailFont 12
@class YJTask;
@interface YJCellFrame : NSObject
@property (nonatomic,strong) YJTask *task;
@property (nonatomic,assign,readonly)CGRect iconFrame;
@property (nonatomic,assign,readonly)CGRect titleFrame;
@property (nonatomic,assign,readonly)CGRect detailFrame;
@property (nonatomic,assign,readonly)CGRect imgFrame;
@property (nonatomic,assign,readonly)CGFloat rowHeight;
-(instancetype)initWithModel:(YJTask *)task;
+(instancetype)cellFrameWithModel:(YJTask *)task;

@end
