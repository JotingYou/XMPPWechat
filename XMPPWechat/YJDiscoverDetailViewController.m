//
//  YJDiscoverDetailViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/5/29.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJDiscoverDetailViewController.h"
#import "YJCellFrame.h"
#import "YJTask.h"
#import "YJDiscoverTableViewCell.h"
#import "MBProgressHUD+HM.h"
#import "MJRefresh.h"
@interface YJDiscoverDetailViewController()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString *plistPath;
@property (nonatomic,strong) NSArray *commends;
@property (nonatomic,strong) NSArray *cellFrames;

@end

@implementation YJDiscoverDetailViewController

- (IBAction)informAction:(id)sender {
    [MBProgressHUD showSuccess:@"举报成功，我们将及时处理该信息"];
}
-(NSString *)plistPath{
    if (!_plistPath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _plistPath=[doc stringByAppendingPathComponent:@"commends.plist"];
    }
    return _plistPath;
}
-(NSArray *)cellFrames{
    if (!_cellFrames) {
        NSMutableArray *arrayM=[NSMutableArray array];
        [arrayM addObject:self.cellFrame];
        for (YJTask *task in self.commends) {
            YJCellFrame *cellframe=[YJCellFrame cellFrameWithModel:task];
            [arrayM addObject:cellframe];
        }
        _cellFrames=arrayM;
    }
    return _cellFrames;
}
-(NSArray *)commends{
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
}- (void)viewDidLoad {
    [super viewDidLoad];
    //下拉刷新
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此0.5秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            NSLog(@"刷新中");
            self.commends=nil;
            self.cellFrames=nil;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }];
    //设置自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha=YES;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJDiscoverTableViewCell *cell=[YJDiscoverTableViewCell discoverCellWithtableView:self.tableView];
    
        
        [cell discoverCellWithcellFrame:self.cellFrames[indexPath.row]];
        cell.accessoryType=UIAccessibilityTraitNone;
    

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellFrames.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        YJCellFrame *cellFrame=self.cellFrames[indexPath.row];
        return cellFrame.rowHeight;
    
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
