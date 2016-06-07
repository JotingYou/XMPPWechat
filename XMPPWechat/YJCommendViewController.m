//
//  YJCommendViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/5/29.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJCommendViewController.h"
#import "YJTask.h"
#import "YJAccount.h"
@interface YJCommendViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txt;
@property (nonatomic,copy) NSString *plistPath;
@property (nonatomic,strong) NSMutableArray *commends;
@end

@implementation YJCommendViewController
-(NSString *)plistPath{
    if (!_plistPath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _plistPath=[doc stringByAppendingPathComponent:@"commends.plist"];
    }
    return _plistPath;
}
-(NSMutableArray *)commends{
    if (!_commends) {
        NSArray *array=[NSArray arrayWithContentsOfFile:self.plistPath];
        if (!array.count) {
            NSString *tmpPath=[[NSBundle mainBundle]pathForResource:@"commends.plist" ofType:nil];
            array=[NSArray arrayWithContentsOfFile:tmpPath];
        }
        NSMutableArray *arrayM=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            YJTask *task=[YJTask taskWithDictionary:dict];
            [arrayM addObject:task];
        }
        _commends=arrayM;
    }
    return _commends;
}
- (IBAction)cancleAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)finishAction:(id)sender {
    YJTask *task=[[YJTask alloc]init];
    
    task.detail=self.txt.text;
    NSString *loginAct=[YJAccount shareAccount].loginAct;
    task.account=loginAct;
    task.title=loginAct;
    task.imgName=@"";
    [self.commends addObject:task];
    NSMutableArray *arrayM=[NSMutableArray array];
    for (YJTask *newTask in self.commends) {
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[newTask.title,newTask.detail,newTask.imgName,newTask.account] forKeys:@[@"title",@"detail",@"imgName",@"account"]];
        [arrayM addObject:dict];
    }
    [arrayM writeToFile:self.plistPath atomically:YES];
    [self cancleAction:nil];
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
