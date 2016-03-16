//
//  YJContantTableViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/9.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJContantTableViewController.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "YJXMPPTool.h"
#import "YJAccount.h"
#import "YJChatViewController.h"
@interface YJContantTableViewController ()<NSFetchedResultsControllerDelegate,UINavigationControllerDelegate>{
    NSFetchedResultsController *_fetchedResultController;
}
//@property (nonatomic,strong) XMPPStream *xmppStream;
//@property (nonatomic,strong) XMPPRosterCoreDataStorage *rosterStorage;
//@property (nonatomic,strong) XMPPRoster *roster;


@end

@implementation YJContantTableViewController

#pragma mark -*****懒加载*****-


-(void)loadFriend{
    
        //1.添加上下文
        NSManagedObjectContext *rosterContext=[YJXMPPTool sharedYJXMPPTool].rosterStorage.mainThreadManagedObjectContext;
        //2.请求查询好友信息
        NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
        // 3.设置过滤和排序
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
        request.sortDescriptors=@[sort];
        // 过滤当前登录用户的好友
        NSPredicate *pre=[NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
        request.predicate=pre;
        //3.执行请求
        //3.1创建结果控制器
        // 数据库查询，如果数据很多，会放在子线程查询
        // 移动客户端的数据库里数据不会很多，所以很多数据库的查询操作都主线程
        _fetchedResultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:rosterContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultController.delegate=self;
        
        
        NSError *err=nil;
        [_fetchedResultController performFetch:&err];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadFriend];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -数据内容改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}
#pragma mark - Table view data source
////
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 1;
//}
////
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject *user=_fetchedResultController.fetchedObjects[indexPath.row];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [[YJXMPPTool sharedYJXMPPTool].roster removeUser:user.jid];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YJLog(@"self.friends.count=%ld",_fetchedResultController.fetchedObjects.count);
    

    return _fetchedResultController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    XMPPUserCoreDataStorageObject *friend=_fetchedResultController.fetchedObjects[indexPath.row];
    //设置头像
    if (friend.photo) {
        cell.imageView.image=friend.photo;
    }else{
//        cell.imageView.image=[UIImage imageNamed:@"46"];
        NSData *imageData=[[YJXMPPTool sharedYJXMPPTool].avatar photoDataForJID:friend.jid];
        cell.imageView.image=[UIImage imageWithData:imageData];
    }
    cell.textLabel.text=friend.displayName;
    switch ([friend.sectionNum integerValue]) {
        case 0:
            cell.detailTextLabel.text=@"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
    
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPJID *friend=[_fetchedResultController.fetchedObjects[indexPath.row] jid];
    [self performSegueWithIdentifier:@"toChatViewSegue" sender:friend];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destContro=segue.destinationViewController;
    if ([destContro isKindOfClass:[YJChatViewController class]]) {
        YJChatViewController *chatVC=destContro;
        chatVC.friendJid=sender;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
