//
//  YJRegisterViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/5.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJRegisterViewController.h"
#import "MBProgressHUD+HM.h"
#import "YJAccount.h"
#import "YJXMPPTool.h"
@interface YJRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation YJRegisterViewController
- (IBAction)register:(id)sender {
    if(!self.txtPassword.text.length || !self.txtAccount.text.length){
        [MBProgressHUD showError:@"请输入账号和密码"];
        return;
        
    }
    //读取输入内容
    [YJAccount shareAccount].regisAct=self.txtAccount.text;
    [YJAccount shareAccount].reginsPsd=self.txtPassword.text;
    
//    [[YJAccount shareAccount] saveToSandBox];
    [MBProgressHUD showMessage:@"正在注册中"];
    //调用注册方法
    __weak typeof(self) selfVC=self;
    [YJXMPPTool sharedYJXMPPTool].registerOperation=YES;
    [[YJXMPPTool sharedYJXMPPTool] xmppRegister:^(XMPPResultType resultType) {
        [selfVC handleXMPPResult:resultType];
    }];

}
#pragma mark 处理XMPP注册结果
/**
处理XMPP注册结果
*/
-(void)handleXMPPResult:(XMPPResultType)resultType{
    //在主线程工作
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if (resultType == XMPPResultTypeRegisterSucess) {
            [MBProgressHUD showSuccess:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [MBProgressHUD showError:@"用户名重复"];
        }
    });
    
}
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
