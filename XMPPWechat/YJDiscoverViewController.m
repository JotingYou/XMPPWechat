//
//  YJDiscoverViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJDiscoverViewController.h"
#import "YJCellFrame.h"
#import "YJDiscoverTableViewCell.h"
#import "MJRefresh.h"
#import "YJTask.h"
//#import "XMPPJID.h"
//#import "YJXMPPTool.h"
//#import "YJAccount.h"
@interface YJDiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *tasks;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,strong) NSArray *cellFrames;

@end

@implementation YJDiscoverViewController
#pragma mark 懒加载
-(NSArray *)cellFrames{
    if (!_cellFrames) {
        NSMutableArray *arrayM=[NSMutableArray array];
        for (YJTask *task in self.tasks) {
            YJCellFrame *cellframe=[YJCellFrame cellFrameWithModel:task];
            [arrayM addObject:cellframe];
        }
        _cellFrames=arrayM;
    }
    return _cellFrames;
}
-(NSString *)filePath{
    if (!_filePath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _filePath=[doc stringByAppendingPathComponent:@"tasks.plist"];
    }
    return _filePath;
}
-(NSArray *)tasks{
    if (!_tasks) {
        NSArray *array=[NSArray arrayWithContentsOfFile:self.filePath];
        if (!array.count) {
            NSString *tmpPath=[[NSBundle mainBundle]pathForResource:@"tasks.plist" ofType:nil];
            array=[NSArray arrayWithContentsOfFile:tmpPath];
            NSLog(@"tmpPath=%@",tmpPath);
        }else{
            NSLog(@"self.filePath=%@",self.filePath);
        }
        
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
            self.cellFrames=nil;
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
    return self.tasks.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YJDiscoverTableViewCell *cell=[YJDiscoverTableViewCell discoverCellWithtableView:tableView];
    [cell discoverCellWithcellFrame:self.cellFrames[indexPath.row]];
    return cell;
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJCellFrame *cellFrame=self.cellFrames[indexPath.row];
    return cellFrame.rowHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toDetailSegue" sender:nil];
}

@end
