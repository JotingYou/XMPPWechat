//
//  YJDiscoverViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJDiscoverViewController.h"
//#import "YJCreatTaskViewController.h"
//#import "XMPPvCardTemp.h"
#import "MJRefresh.h"
#import "YJTask.h"
//#import "XMPP.h"
#import "XMPPJID.h"
#import "YJXMPPTool.h"
#import "YJAccount.h"
@interface YJDiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *tasks;
@property (nonatomic,copy) NSString *filePath;

@end

@implementation YJDiscoverViewController
#pragma mark 懒加载
-(NSString *)filePath{
    if (!_filePath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _filePath=[doc stringByAppendingPathComponent:@"tasks.plist"];
    }
    NSLog(@"_filePath=%@",_filePath);
    return _filePath;
}
-(NSArray *)tasks{
    if (!_tasks) {
        NSArray *array=[NSArray arrayWithContentsOfFile:self.filePath];
        NSMutableArray *arrayM=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            YJTask *task =[YJTask taskWithDictionary:dict];
            [arrayM addObject:task];
        }
        _tasks=arrayM;
    }
    return _tasks;
}
#pragma mark 主程序
- (void)viewDidLoad {
    [super viewDidLoad];
    __unsafe_unretained UITableView *tableView=self.tableView;
    //下拉刷新
    tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此0.5秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            NSLog(@"刷新中");
            self.tasks=nil;
            [self.tableView reloadData];
            [tableView.mj_header endRefreshing];
        });
    }];
    //设置自动切换透明度
    tableView.mj_header.automaticallyChangeAlpha=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -实现tableview数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"self.tasks.count=%ld",self.tasks.count);
    return self.tasks.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"discoverCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    YJTask *task=self.tasks[indexPath.row];
    cell.textLabel.text=task.title;
    cell.detailTextLabel.text=task.detail;
    //获取数据
//    XMPPvCardTemp *myvCard=[YJXMPPTool sharedYJXMPPTool].vCard.myvCardTemp;
    //获取头像
    XMPPJID *jid=[XMPPJID jidWithUser:task.account domain:[YJAccount shareAccount].domain resource:nil];
    NSLog(@"jid=%@",jid);
    NSData *imageData=[[YJXMPPTool sharedYJXMPPTool].avatar photoDataForJID:jid];
    cell.imageView.image=[UIImage imageWithData:imageData];
    return cell;
}

#pragma mark - Navigation
//-(void)YJCreatTaskViewControllerDidFinished:(YJCreatTaskViewController *)creatVC{
//    self.tasks=nil;
//    [self.tableView reloadData];
//}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    id destVC=segue.destinationViewController;
//    
//        if ([destVC isKindOfClass:[YJCreatTaskViewController class]]) {
//            YJCreatTaskViewController *creatVC=[[YJCreatTaskViewController alloc]init];
//            creatVC=destVC;
//            creatVC.delegate=self;
//            NSLog(@"目标控制器是YJCreatTaskViewController");
//        }else{
//            NSLog(@"目标控制器bu是YJCreatTaskViewController");
//        }
//        
//    
//    
//}


@end
