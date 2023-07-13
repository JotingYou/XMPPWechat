//
//  YJXMPPTool.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/5.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJXMPPTool.h"
#import "YJAccount.h"
#import "MBProgressHUD+HM.h"
/* 用户登录流程
 1.初始化XMPPStream
 
 2.连接服务器(传一个jid)
 
 3.连接成功，接着发送密码
 
 // 默认登录成功是不在线的
 4.发送一个 "在线消息" 给服务器 ->可以通知其它用户你上线
 */
@interface YJXMPPTool ()<XMPPStreamDelegate,XMPPIncomingFileTransferDelegate,XMPPOutgoingFileTransferDelegate>{
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
    
    // 接收文件
    _inFileTransfer = [[XMPPIncomingFileTransfer alloc]initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    [_inFileTransfer activate:_xmppStream];
    [_inFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //自动接收文件
    [_inFileTransfer setAutoAcceptFileTransfers:true];
    
    // 发送文件
    _outFileTransfer = [[XMPPOutgoingFileTransfer alloc]initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    [_outFileTransfer activate:_xmppStream];
    [_outFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
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
//    YJLog(@"self.isRegisterOperation==%d",self.isRegisterOperation);
    if (self.isRegisterOperation) {//注册
        NSString *registerUser = account.regisAct;
//        YJLog(@"#####################account=%@,password=%@",account.regisAct,account.reginsPsd);
        
        myJid = [XMPPJID jidWithUser:registerUser domain:account.domain resource:@"phone"];
    }else{//登录操作
        NSString *loginUser = [YJAccount shareAccount].loginAct;
        myJid = [XMPPJID jidWithUser:loginUser domain:account.domain resource:@"phone"];
    }
    
    _xmppStream.myJID = myJid;
    YJLog(@"myJid=%@",myJid);
    
    // 2.设置主机地址
    _xmppStream.hostName = account.host;
    
    // 3.设置主机端口号 (默认就是5222，可以不用设置)
    _xmppStream.hostPort = account.port;
    
    // 4.发起连接
    NSError *error = nil;
    // 缺少必要的参数时就会发起连接失败 ? 没有设置jid
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        YJLog(@"%@",error);
    }else{
        YJLog(@"发起连接成功");
    }
    
}


-(void)sendPwdToHost{
    NSError *error = nil;
    NSString *pwd = [YJAccount shareAccount].loginPsd;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        YJLog(@"%@",error);
    }
}


-(void)sendOnline{
    //XMPP框架，已经把所有的指令封闭成对象
    XMPPPresence *presence = [XMPPPresence presence];
//    YJLog(@"%@",presence);
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
    YJLog(@"连接建立成功");
    if (self.isRegisterOperation) {//注册
        NSError *error = nil;
        NSString *reigsterPsd = [YJAccount shareAccount].reginsPsd;
        [_xmppStream registerWithPassword:reigsterPsd error:&error];
        if (error) {
            YJLog(@"%@",error);
        }
    }else{//登录
        [self sendPwdToHost];
    }
    
}

#pragma mark 与服务器断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
    YJLog(@"与服务器断开连接%@",error);
}
#pragma mark 登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //WCLog(@"%s",__func__);
    YJLog(@"登录成功");
    [self sendOnline];
    
    //回调resultBlock
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSucess);
        
        _resultBlock = nil;
    }
}

#pragma mark 登录失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    YJLog(@"登录失败%@",error);
    //回调resultBlock
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    YJLog(@"注册成功");

    
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSucess);
    }
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    YJLog(@"注册失败 %@",error);
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

-(BOOL)sendFile:(NSData *)data name:(NSString *)name to:(XMPPJID *)jid{
    NSError *err = nil;
    if (jid.resource == nil) {
        jid = [XMPPJID jidWithUser:jid.user domain:jid.domain resource:@"phone"];
    }
    [self.outFileTransfer sendData:data named:name toRecipient:jid description:nil error:&err];
    if(err){
        YJLog(@"%@",err);
        return false;
    }
    
    return true;
}

-(XMPPJID *)myJID{
    return self.xmppStream.myJID;
}
@end

@implementation YJXMPPTool(XMPPIncomingFileTransferDelegate)

-(void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didReceiveSIOffer:(XMPPIQ *)offer{
    YJLog(@"%s",__func__);
    [self.inFileTransfer acceptSIOffer:offer];
}
-(void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didSucceedWithData:(NSData *)data named:(NSString *)name{
    YJLog(@"%s",__func__);
    //在这个方法里面，我们通过带外来传输的文件

    //因此我们的消息同步器，不会帮我们自动生成Message,因此我们需要手动存储message

    //根据文件后缀名，判断文件我们是否能够处理，如果不能处理则直接显示。

    //图片 音频 （.wav,.mp3,.mp4)

    NSString *extension = [name pathExtension];
    if (![@"jpeg" isEqualToString:extension]) {
        return;
    }
        
    //创建一个XMPPMessage对象,message必须要有from
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:sender.xmppStream.myJID];
    
    [message addAttributeWithName:@"from" stringValue:sender.senderJID.bare];
    
    [message addSubject:@"image"];
    
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:[XMPPStream generateUUID]];
    
    path = [path stringByAppendingPathExtension:@"jpeg"];
    
    [data writeToFile:path atomically:YES];
    
    [message addBody:path.lastPathComponent];
    YJLog(@"%@",path);
    [self.msgArchivingStorage archiveMessage:message outgoing:NO xmppStream:self.xmppStream];
}
-(void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didFailWithError:(NSError *)error{
    YJLog(@"%s",__func__);
}
@end
@implementation YJXMPPTool(XMPPOutgoingFileTransferDelegate)
- (void)xmppOutgoingFileTransferDidSucceed:(XMPPOutgoingFileTransfer *)sender{
    
    YJLog(@"%s",__func__);
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:sender.xmppStream.remoteJID];
    
    //将这个文件的发送者添加到message的from
    
    [message addAttributeWithName:@"from" stringValue:sender.xmppStream.myJID.bare];
    
    [message addSubject:@"image"];
    
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:sender.outgoingFileName];
    
    [message addBody:path.lastPathComponent];
    
    [self.msgArchivingStorage archiveMessage:message outgoing:NO xmppStream:self.xmppStream];
    [MBProgressHUD showSuccess:@"发送成功"];
}

-(void)xmppOutgoingFileTransfer:(XMPPOutgoingFileTransfer *)sender didFailWithError:(NSError *)error{
    YJLog(@"%s",__func__);
    if(error){
        YJLog(@"%@",error);
    }
    [MBProgressHUD showError:@"发送失败，请重试"];
}

@end
