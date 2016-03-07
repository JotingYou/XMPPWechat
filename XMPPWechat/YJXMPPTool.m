//
//  YJXMPPTool.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/5.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJXMPPTool.h"
#import "YJAccount.h"

/* 用户登录流程
 1.初始化XMPPStream
 
 2.连接服务器(传一个jid)
 
 3.连接成功，接着发送密码
 
 // 默认登录成功是不在线的
 4.发送一个 "在线消息" 给服务器 ->可以通知其它用户你上线
 */
@interface YJXMPPTool ()<XMPPStreamDelegate>{
    XMPPReconnect *_reconnect;//自动连接模块,由于网络问题，与服务器断开时，它会自己连接服务器
    
    XMPPResultBlock _resultBlock;//结果回调Block
}
/**
 *  1.初始化XMPPStream
 */
-(void)setupStream;

/**
 *  释放资源
 */
-(void)teardownStream;

/**
 *  2.连接服务器(传一个jid)
 */
-(void)connectToHost;

/**
 *  3.连接成功，接着发送密码
 */
-(void)sendPwdToHost;

/**
 *  4.发送一个 "在线消息" 给服务器
 */
-(void)sendOnline;

/**
 *  发送 “离线” 消息
 */
-(void)sendOffline;

/**
 *  与服务器断开连接
 */
-(void)disconncetFromHost;
@end



@implementation YJXMPPTool

singleton_implementation(YJXMPPTool)

#pragma mark -私有方法
-(void)setupStream{
    // 创建XMPPStream对象
    _xmppStream = [[XMPPStream alloc] init];
    
    
    // 添加XMPP模块
    // 1.添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    // 激活
    [_vCard activate:_xmppStream];
    
    // 电子名片模块还会配置 "头像模块" 一起使用
    // 2.添加 头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    
    // 3.添加 "花名册" 模块
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    
    // 4.添加 "消息" 模块
    _msgArchivingStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgArchivingStorage];
    [_msgArchiving activate:_xmppStream];
    
    // 5.添加 “自动连接” 模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    // 设置代理 -
    //#warnning 所有的代理方法都将在子线程被调用
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)teardownStream{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //取消模块
    [_avatar deactivate];
    [_vCard deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    [_reconnect deactivate];
    
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _reconnect = nil;
    _msgArchiving = nil;
    _msgArchivingStorage = nil;
    _roster = nil;
    _rosterStorage = nil;
    _vCardStorage = nil;
    _vCard = nil;
    _avatar = nil;
    _xmppStream = nil;
    
}

-(void)connectToHost{
    
    if (!_xmppStream) {
        [self setupStream];
    }
    // 1.设置登录用户的jid
    XMPPJID *myJid=nil;
    // resource 用户登录客户端设备登录的类型
    
    /*
     if(注册请求){
     //设置注册的JID
     }else{
     //设置登录JID
     }*/
    YJAccount *account = [YJAccount shareAccount];
//    NSLog(@"self.isRegisterOperation==%d",self.isRegisterOperation);
    if (self.isRegisterOperation) {//注册
        NSString *registerUser = account.regisAct;
//        NSLog(@"#####################account=%@,password=%@",account.regisAct,account.reginsPsd);
        
        myJid = [XMPPJID jidWithUser:registerUser domain:account.domain resource:nil];
    }else{//登录操作
        NSString *loginUser = [YJAccount shareAccount].loginAct;
        myJid = [XMPPJID jidWithUser:loginUser domain:account.domain resource:nil];
    }
    
    _xmppStream.myJID = myJid;
    
    // 2.设置主机地址
    _xmppStream.hostName = account.host;
    
    // 3.设置主机端口号 (默认就是5222，可以不用设置)
    _xmppStream.hostPort = account.port;
    
    // 4.发起连接
    NSError *error = nil;
    // 缺少必要的参数时就会发起连接失败 ? 没有设置jid
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"发起连接成功");
    }
    
}


-(void)sendPwdToHost{
    NSError *error = nil;
    NSString *pwd = [YJAccount shareAccount].loginPsd;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}


-(void)sendOnline{
    //XMPP框架，已经把所有的指令封闭成对象
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}


-(void)sendOffline{
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
}

-(void)disconncetFromHost{
    [_xmppStream disconnect];
}
#pragma mark -XMPPStream的代理
#pragma mark 连接建立成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接建立成功");
    if (self.isRegisterOperation) {//注册
        NSError *error = nil;
        NSString *reigsterPwd = [YJAccount shareAccount].reginsPsd;
        [_xmppStream registerWithPassword:reigsterPwd error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }else{//登录
        [self sendPwdToHost];
    }
    
}

#pragma mark 与服务器断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    NSLog(@"与服务器断开连接%@",error);
}
#pragma mark 登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //WCLog(@"%s",__func__);
    NSLog(@"登录成功");
    [self sendOnline];
    
    //回调resultBlock
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSucess);
        
        _resultBlock = nil;
    }
}

#pragma mark 登录失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登录失败%@",error);
    //回调resultBlock
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    //CZLog
    //    WCLog(@"abc");
    
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSucess);
    }
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败 %@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
    
}

#pragma mark -公共方法
#pragma mark 用户登录
-(void)xmppLogin:(XMPPResultBlock)resultBlock{
    // 不管什么情况，把以前的连接断开
    [_xmppStream disconnect];
    
    // 保存resultBlock
    _resultBlock = resultBlock;
    
    
    // 连接服务器开始登录的操作
    [self connectToHost];
    
}


#pragma mark 用户注册
-(void)xmppRegister:(XMPPResultBlock)resultBlock{
    /* 注册步骤
     1.发送 "注册jid" 给服务器，请求一个长连接
     2.连接成功，发送注册密码
     */
    //保存block
    _resultBlock = resultBlock;
    
    // 去除以前的连接
    [_xmppStream disconnect];
    
    [self connectToHost];
    
    
}

#pragma mark 用户注销
-(void)xmppLogout{
    // 1.发送 "离线消息" 给服务器
    [self sendOffline];
    // 2.断开与服务器的连接
    [self disconncetFromHost];
    // [_xmppStream disconnect];
    //XMPPStream
}



-(void)dealloc{
    [self teardownStream];
}

@end

