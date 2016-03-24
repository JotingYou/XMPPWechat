//
//  YJQcodeViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJQcodeViewController.h"
#import "NSString+Helper.h"
@interface YJQcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qcodeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@end

@implementation YJQcodeViewController
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text=self.nickname;
    self.adressLabel.text=self.address;
    self.iconImgView.image=self.icon;
    self.qcodeImgView.image=[self.jid createRRcode];
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
