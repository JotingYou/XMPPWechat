//
//  YJTask.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/4/6.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJTask.h"

@implementation YJTask
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+(instancetype)taskWithDictionary:(NSDictionary *)dict{
   return  [[self alloc] initWithDictionary:dict];
    
}
@end
