//
//  YJAddContantViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/9.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJAddContantViewController.h"
#import "YJAccount.h"
#import "YJXMPPTool.h"
#import "MBProgressHUD+HM.h"
@interface YJAddContantViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtAdd;

@end

@implementation YJAddContantViewController
- (IBAction)addContact:(id)sender {
    //获取输入内容
    NSString *user=self.txtAdd.text;
    //不能添加自己
    if ([user isEqualToString:[YJAccount shareAccount].loginAct]) {
        [MBProgressHUD showError:@"不能添加自己"];
        return;
    }else{
        //将NSString转化为JID
        XMPPJID *jid=[XMPPJID jidWithUser:user domain:[YJAccount shareAccount].domain resource:nil];
        //判断好友是否存在
        BOOL isexisted=[[YJXMPPTool sharedYJXMPPTool].rosterStorage userExistsWithJID:jid xmppStream:[YJXMPPTool sharedYJXMPPTool].xmppStream];
        if (isexisted) {
            [MBProgressHUD showError:@"好友已存在"];
            return;
        }else{
        //添加好友
            [[YJXMPPTool sharedYJXMPPTool].roster subscribePresenceToUser:jid];
            
            [MBProgressHUD showSuccess:@"请求已经发送"];
        [self.navigationController popViewControllerAnimated:YES];
        }

    }
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
