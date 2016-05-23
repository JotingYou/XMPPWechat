//
//  YJTask.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/4/6.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YJTask : NSObject
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *account;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
+(instancetype)taskWithDictionary:(NSDictionary*)dict;
@end
