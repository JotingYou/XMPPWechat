//
//  YJMeTableViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/7.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJMeTableViewController.h"
#import "YJXMPPTool.h"
#import "YJAccount.h"
#import "UIStoryboard+WF.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "YJInfoViewController.h"
@interface YJMeTableViewController ()<YJInfoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *cardCell;

@end

@implementation YJMeTableViewController
- (IBAction)loginout:(id)sender {
    //注销
    [[YJXMPPTool sharedYJXMPPTool]xmppLogout];
    //登录状态设为no
    [YJAccount shareAccount].login=NO;
    [[YJAccount shareAccount]saveToSandBox];
    //返回登录界面
    [UIStoryboard showInitialVCWithName:@"ConnectView"];
}
-(void)loadData{
    //通过XMPPXMPPvCardTemp获取用户数据
    //0获取名片
    XMPPvCardTemp *vCard=[YJXMPPTool sharedYJXMPPTool].vCard.myvCardTemp;
    //1.获取头像
    UIImage *img=[UIImage new];
    if (vCard.photo) {
        img=[UIImage imageWithData:vCard.photo];
        
    }else{
        img=[UIImage imageNamed:@"46"];
    }
    self.cardCell.imageView.image=[self scaleFromImage:img toSize:CGSizeMake(700, 600)];
    //2.获取昵称
    if(vCard.nickname){
        self.cardCell.textLabel.text=vCard.nickname;
    }else{
        self.cardCell.textLabel.text=@"无名氏";
    }
    //3.微信号
    self.cardCell.detailTextLabel.text=[NSString stringWithFormat:@"账号:%@",[YJAccount shareAccount].loginAct];

    
}
/*
 调整图片大小
 **/
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -实现YJInfoViewController代理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVC=segue.destinationViewController;
    if ([destVC isKindOfClass:[YJInfoViewController class]]) {
        YJInfoViewController *infoVC=destVC;
        infoVC.delegate=self;
    }
}
-(void)YJInfoViewControllerDidChange:(YJInfoViewController *)YJInfoViewController{
    [self loadData];
    
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
