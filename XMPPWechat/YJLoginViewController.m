//
//  YJLoginViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/5.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJLoginViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+HM.h"
#import "UIStoryboard+WF.h"
#import "YJXMPPTool.h"
#import "YJAccount.h"
#import "NSString+Hash.h"
#define kActKey @"act"
#define kPwdKey @"pwd"
#define kLoginKey @"login"
#define hmacKey @"YSJKODOJJEN23344JHHssds"
@interface YJLoginViewController ()<NSStreamDelegate>{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
}
@property (weak, nonatomic) IBOutlet UITextField *txtAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation YJLoginViewController
- (IBAction)connect:(UIBarButtonItem *)sender {
//    //ios里实现sokcet的连接，使用C语言
//    // 1.与服务器通过三次握手建立连接
//    NSString *host=@"127.0.0.1";
//    int port=5222;
//    
//    // 2.定义输入输出流
//    CFReadStreamRef readStream;
//    CFWriteStreamRef writeStream;
//    // 3.分配输入输出流的内存空间
//    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host,port,&readStream,&writeStream);
//    
//    // 4.把C语言的输入输出流转成OC对象
//    _inputStream =(__bridge NSInputStream *)readStream;
//    _outputStream=(__bridge NSOutputStream *)writeStream;
//    // 5.设置代理,监听数据接收的状态
//    _inputStream.delegate=self;
//    _outputStream.delegate=self;
//    // 把输入输入流添加到主运行循环(RunLoop)
//    // 主运行循环是监听网络状态
//    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    // 6.打开输入输出流
//    [_inputStream open];
//    [_outputStream open];
}
- (IBAction)login:(id)sender {
    // 1.如果账号或密码为空，则返回
    if (!self.txtAccount.text.length || !self.txtPassword.text.length) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"正在登录中_(:з」∠)_"];
    // 2.登录服务器
    // 2.1把数据缓存到沙盒
    [YJAccount shareAccount].loginAct=self.txtAccount.text;
    [YJAccount shareAccount].loginPsd=self.txtPassword.text;


    // 2.2调用AppDelegate的xmppLogin方法
    
    // ?怎么把appdelegate的登录结果告诉WCLoginViewControllers控制器
    // 》代理
    // 》block
    // 》通知
    
    // block会对self进行强引用
    __weak typeof(self) selfVc = self;
    //自己写的block ，有强引用的时候，使用弱引用,系统block,用强引用
    
    //设置标识
    [YJXMPPTool sharedYJXMPPTool].registerOperation=NO;
    [[YJXMPPTool sharedYJXMPPTool] xmppLogin:^(XMPPResultType resultType){
        [selfVc handleXMPPResult:resultType];
    }];

    
}
-(void)handleXMPPResult:(XMPPResultType)resultType{
    //回到主线程更新UI
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (resultType==XMPPResultTypeLoginSucess) {
            [MBProgressHUD showSuccess:@"登录成功"];
            [YJAccount shareAccount].login=YES;
            [[YJAccount shareAccount] saveToSandBox];
            [UIStoryboard showInitialVCWithName:@"Main"];
        }
        else{
            [MBProgressHUD showError:@"账号或密码错误"];
        }
    });
}
//-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
//    switch (eventCode) {
//        case NSStreamEventOpenCompleted:
//            YJLog(@"%@",aStream);
//            YJLog(@"连接成功 通道打开");
//            break;
//        case NSStreamEventHasBytesAvailable:
//            YJLog(@"数据可读");
//            [self readData];
//            break;
//        case NSStreamEventHasSpaceAvailable:
//            YJLog(@"可以发送数据");
//            break;
//        case NSStreamEventErrorOccurred:
//            YJLog(@"发生错误");
//            break;
//        case NSStreamEventEndEncountered:
//            YJLog(@"成功断开连接");
//            break;
//            
//        default:
//            break;
//    }
//}
#pragma mark 读取服务器返回的数据
//-(void)readData{
//     //定义缓冲区 这个缓冲区只能存储1024字节
//    uint8_t buf[1024];
//    // 读取数据
//    // len为服务器读取到的实际字节数
//    NSInteger len=[_inputStream read:buf maxLength:sizeof(buf)];
//
//     // 把缓冲区里的实现字节数转成字符串
//    NSString *receiveStr=[[NSString alloc]initWithBytes:buf length:len
// encoding:NSUTF8StringEncoding];
//    YJLog(@"%@",receiveStr);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
