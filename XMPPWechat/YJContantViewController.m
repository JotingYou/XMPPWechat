//
//  YJTableViewController.m
//  individual contant
//
//  Created by 姚家庆 on 15/12/7.
//  Copyright © 2015年 姚家庆. All rights reserved.
//

#import "YJContantViewController.h"
#import "YJContant.h"
#import "YJAddViewController.h"
#import "YJEditContantViewController.h"
@interface YJContantViewController ()<UITableViewDataSource,UITableViewDelegate,addViewControllerDelegate,YJEditContantViewControllerDelegate>
@property (nonatomic,strong) NSMutableArray *contacts;
@property (nonatomic,strong) NSString *contactPath;//联系人存放地址

@end

@implementation YJContantViewController
//返回按键事件
//- (IBAction)actionReturn:(id)sender {
//    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"警告" message:@"是否注销?" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *done=[UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }];
//    [alertController addAction:actionCancle];
//    [alertController addAction:done];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
#pragma mark - *********懒加载contacts存放地址******** -
-(NSString *)contactPath{
    if (!_contactPath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        _contactPath=[doc stringByAppendingPathComponent:@"contacts.archiver"];
    }
    return _contactPath;
}
#pragma mark - *********懒加载contacts******** -
-(NSMutableArray *)contacts{
    if (!_contacts) {
        //先从沙盒中取数据
        _contacts=[NSKeyedUnarchiver unarchiveObjectWithFile:self.contactPath];
        if (!_contacts) {
            _contacts=[NSMutableArray array];
        }
    }
    return _contacts;
}
#pragma mark - *********实现addViewController代理方法******** -
-(void)addViewController:(YJAddViewController *)addvc didSaveContact:(YJContant *)contact{
    //将数据加入数组
    [self.contacts addObject:contact];
    //局部刷新数据
    NSIndexPath *lastPath=[NSIndexPath indexPathForRow:self.contacts.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[lastPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //将数据存储到沙盒
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:self.contactPath];
}
#pragma mark - *********实现editViewController代理方法******** -
-(void)YJEditContantViewController:(YJEditContantViewController *)edvc didEditContact:(YJContant *)contact{
        //获取更新对象的行数
    NSInteger row=[self.contacts indexOfObject:contact];
    self.contacts[row]=contact;
    NSIndexPath *refreshPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[refreshPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //将数据存储到沙盒
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:self.contactPath];
}
//获取目标控制器,设置代理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destvc=segue.destinationViewController;
    if ([destvc isKindOfClass:[YJAddViewController class]]) {
        YJAddViewController *AddViewController=destvc;
        AddViewController.delegete=self;
    } else if([destvc isKindOfClass:[YJEditContantViewController class]]){
        YJEditContantViewController *editViewController=destvc;
        editViewController.delegate=self;
        NSInteger selectedRow=self.tableView.indexPathForSelectedRow.row;
        editViewController.contact=self.contacts[selectedRow];
    }
}
#pragma mark - *********主程序******** -
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=[NSString stringWithFormat:@"%@的通讯录",self.name];
    UIBarButtonItem *deleteItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete)];
    self.navigationItem.rightBarButtonItems=@[deleteItem,self.navigationItem.rightBarButtonItem];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)delete{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}
//设置tableView返回状态
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        return UITableViewCellEditingStyleInsert;
    }
    else return UITableViewCellEditingStyleDelete;
}
//设置删除事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleInsert) {
        YJContant *contact=[[YJContant alloc]init];
        contact.name=@"隔壁老王";
        contact.tel=nil;
        [self.contacts insertObject:contact atIndex:indexPath.row+1];
        NSIndexPath *insertIndex=[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[insertIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (editingStyle==UITableViewCellEditingStyleDelete){
        
        [self.contacts removeObjectAtIndex:indexPath.row];
        NSIndexPath *deleteIndex=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:self.contactPath];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reID=@"ContactCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reID];
    YJContant *contact=self.contacts[indexPath.row];
    cell.textLabel.text=contact.name;
    cell.detailTextLabel.text=contact.tel;
    return cell;
}
@end
