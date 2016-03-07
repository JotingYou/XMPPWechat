//
//  YJAccount.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/7.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJAccount : NSObject
//登录名
@property (nonatomic,copy) NSString *loginAct;
//登录密码
@property (nonatomic,copy) NSString *loginPsd;
//登录状态
@property (nonatomic,assign,getter=islogin) BOOL login;
//注册名
@property (nonatomic,copy) NSString *regisAct;
//注册密码
@property (nonatomic,copy) NSString *reginsPsd;
//注册状态
@property (nonatomic,assign,getter=isreginstered) BOOL reginstered;
+(instancetype)shareAccount;
//存储用户数据到沙盒
-(void)saveToSandBox;
//服务器域名
@property (nonatomic,copy,readonly) NSString *domain;
//服务器IP
@property (nonatomic,copy,readonly) NSString *host;
@property (nonatomic,assign,readonly) int port;

@end
