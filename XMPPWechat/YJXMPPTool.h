//
//  YJXMPPTool.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/5.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <XMPPFramework/XMPPFramework.h>

typedef enum {
    XMPPResultTypeLoginSucess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeRegisterSucess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

/**
 *  与服务器交互的结果
 */
typedef void (^XMPPResultBlock)(XMPPResultType);


@interface YJXMPPTool : NSObject
singleton_interface(YJXMPPTool)

@property(strong,nonatomic,readonly)XMPPStream *xmppStream;//与服务器交互的核心类

@property(strong,nonatomic,readonly)XMPPvCardTempModule *vCard;//电子名片模块
@property(strong,nonatomic,readonly)XMPPvCardCoreDataStorage *vCardStorage;//电子名片数据存储

@property(strong,nonatomic,readonly)XMPPvCardAvatarModule *avatar;//电子名片的头像模块

@property(strong,nonatomic,readonly)XMPPRoster *roster;//花名册
@property(strong,nonatomic,readonly)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储



@property(strong,nonatomic,readonly)XMPPMessageArchiving *msgArchiving;
@property(strong,nonatomic,readonly)XMPPMessageArchivingCoreDataStorage *msgArchivingStorage;


/**
 *  标识 连接服务器 到底是 "登录连接"还是 “注册连接”
 *  NO 代表登录操作
 *  YES 代表注册操作
 */
@property(assign,nonatomic,getter=isRegisterOperation)BOOL registerOperation;

@property(strong,nonatomic,readonly)XMPPIncomingFileTransfer *inFileTransfer;

@property(strong,nonatomic,readonly)XMPPOutgoingFileTransfer  *outFileTransfer;
/**
 *  XMPP用户登录
 */
-(void)xmppLogin:(XMPPResultBlock)resultBlock;

/**
 *  用户注册
 *
 */
-(void)xmppRegister:(XMPPResultBlock)resultBlock;
/**
 *  用户注销
 */
-(void)xmppLogout;

-(void)sendFile:(NSData *)data name:(NSString *)name to:(XMPPJID *)jid;
@end
