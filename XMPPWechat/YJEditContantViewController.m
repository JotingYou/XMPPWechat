//
//  YJEditContantViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/9.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJEditContantViewController.h"
#import "YJContant.h"
@interface YJEditContantViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtOtherName;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@end

@implementation YJEditContantViewController
- (IBAction)actionSave {
    if ([self.delegate respondsToSelector:@selector(YJEditContantViewController:didEditContact:)]) {
        self.contact.name=self.txtName.text;
        self.contact.tel=self.txtOtherName.text;
        
        [self.delegate YJEditContantViewController:self didEditContact:self.contact];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (IBAction)actionEdit:(id)sender {
    if (self.btnSave.enabled) {
        self.btnEdit.title=@"编辑";
        self.btnSave.enabled=NO;
        self.txtName.enabled=NO;
        self.txtOtherName.enabled=NO;
    }else{
        self.btnEdit.title=@"取消";
        self.btnSave.enabled=YES;
        self.txtName.enabled=YES;
        self.txtOtherName.enabled=YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtOtherName.text=self.contact.tel;
    self.txtName.text=self.contact.name;
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
