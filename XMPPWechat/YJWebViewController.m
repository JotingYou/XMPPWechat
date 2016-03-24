//
//  YJWebViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/22.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJWebViewController.h"

@interface YJWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url=@"https://m.baidu.com";
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
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
