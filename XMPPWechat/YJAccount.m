//
//  YJAccount.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/7.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJAccount.h"
#define kActKey @"act"
#define kPwdKey @"pwd"
#define kLoginKey @"login"
static NSString *domain=@"teacher.local";
static NSString *host=@"127.0.0.1";
static int port=5222;
@implementation YJAccount
+(instancetype)shareAccount{
    return [[self alloc]init];
}
#pragma mark 分配内存存储对象
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static YJAccount *acc;
    //为了线程安全 三个线程同时调用该方法
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        acc=[super allocWithZone:zone];
        //从沙盒获取缓存数据
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        acc.loginAct=[defaults objectForKey:kActKey];
        acc.loginPsd=[defaults objectForKey:kPwdKey];
        acc.login=[defaults objectForKey:kLoginKey];
    });
    return acc;
    
}
-(void)saveToSandBox{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginAct forKey:kActKey];
    [defaults setObject:self.loginPsd forKey:kPwdKey];
    [defaults setBool:self.islogin forKey:kLoginKey];
    [defaults synchronize];
    
}
-(NSString *)domain{
    return domain;
}
-(NSString *)host{
    return host;
}
-(int)port{
    return port;
}
@end
