//
//  YJCreatTaskViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJCreatTaskViewController.h"
#import "MBProgressHUD+HM.h"
#import "YJContentViewController.h"
#define kTitle @"title"
@interface YJCreatTaskViewController ()<UITextFieldDelegate,YJContentViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
//@property (nonatomic,copy) NSString *tempPath;
@end

@implementation YJCreatTaskViewController
//-(NSString *)tempPath{
//    if (!_tempPath) {
//        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//        _tempPath=[doc stringByAppendingPathComponent:@"temp.plist"];
//    }
//    
//    return _tempPath;
//}
- (IBAction)Next:(id)sender {
    if (self.titleTxt.text.length==0) {
        [MBProgressHUD showError:@"请输入标题"];
    }else {
        if(self.titleTxt.text.length>30){
            [MBProgressHUD showError:@"标题文字不能超过30个字"];
        }else {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:self.titleTxt.text forKey:kTitle];
            [defaults synchronize];
            [self performSegueWithIdentifier:@"toContentViewSegue" sender:nil];
        }
    }
}
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 实现代理
-(void)YJContentViewController:(YJContentViewController *)ContentViewController didFinishedPublish:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:^{
////        if ([self.delegate respondsToSelector:@selector(YJCreatTaskViewControllerDidFinished:)]) {
////            [self.delegate YJCreatTaskViewControllerDidFinished:self];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVC=segue.destinationViewController;
    if ([destVC isKindOfClass:[YJContentViewController class]]) {
        YJContentViewController *contVC=[[YJContentViewController alloc]init];
        contVC=destVC;
        contVC.delegate=self;
        
    }
}
#pragma mark 主程序
- (void)viewDidLoad {
    self.titleTxt.delegate=self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self Next:nil];
    return YES;
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
