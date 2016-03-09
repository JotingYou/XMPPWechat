//
//  YJInfoViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/7.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJInfoViewController.h"
#import "XMPPvCardTemp.h"
#import "YJXMPPTool.h"
#import "YJAccount.h"
#import "YJEditViewController.h"
@interface YJInfoViewController ()<UINavigationControllerDelegate,YJEditViewControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UITableViewCell *nicknameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *wechatNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *adressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *introduceCell;

@end

@implementation YJInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取数据
    XMPPvCardTemp *myvCard=[YJXMPPTool sharedYJXMPPTool].vCard.myvCardTemp;
    //获取头像
    if (myvCard.photo) {
        self.iconImg.image=[UIImage imageWithData:myvCard.photo];
    }
    else{
        self.iconImg.image=[UIImage imageNamed:@"46"];
    }
    //获取昵称
    if(myvCard.nickname){
        self.nicknameCell.detailTextLabel.text=myvCard.nickname;
    }else{
        self.nicknameCell.detailTextLabel.text=@"请设置昵称";
    }
    //获取微信号
    self.wechatNumCell.detailTextLabel.text=[YJAccount shareAccount].loginAct;
    //获取地址
    if(myvCard.middleName){
        self.adressCell.detailTextLabel.text=myvCard.middleName;
    }else{
        self.adressCell.detailTextLabel.text=@"请输入地址";
    }
    //获取性别
    if(myvCard.prefix){
        self.sexCell.detailTextLabel.text=myvCard.prefix;
    }else{
        self.sexCell.detailTextLabel.text=@"请输入性别";
    }
    //获取地区
    if(myvCard.suffix){
        self.locationCell.detailTextLabel.text=myvCard.suffix;
    }else{
        self.locationCell.detailTextLabel.text=@"请输入地区";
    }
    //获取介绍
    if(myvCard.note){
        self.introduceCell.detailTextLabel.text=myvCard.note;
    }else{
        self.introduceCell.detailTextLabel.text=@"这个人很懒 什么也没写";
    }


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取cell
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath ];
    switch (cell.tag) {
        case 0:
            //更换头像
            [self changeImg];
            break;
        case 1:
            //进入编辑界面
            [self performSegueWithIdentifier:@"segueToEditView" sender:cell];
            break;
        case 2:
            //do nothing
            break;
    }
}
-(void)changeImg{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //图片选择控制器
    UIImagePickerController *imgPC=[[UIImagePickerController alloc]init];
    //设置代理
    imgPC.delegate=self;
    //允许编辑图片
    imgPC.allowsEditing=YES;
    
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionChoose=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        //允许编辑图片
//        imgPC.allowsEditing=YES;
        //从相册选择
        imgPC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//        //显示控制器
        [self presentViewController:imgPC animated:YES completion:nil];
        
    }];
    UIAlertAction *actionTakePhoto=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        //图片选择控制器
//        UIImagePickerController *imgPC=[[UIImagePickerController alloc]init];
//        //设置代理
//        imgPC.delegate=self;
//        //允许编辑图片
//        imgPC.allowsEditing=YES;
        //拍照
        imgPC.sourceType=UIImagePickerControllerSourceTypeCamera;
        //显示控制器
        [self presentViewController:imgPC animated:YES completion:nil];
        
    }];
    [alertController addAction:actionCancle];
    [alertController addAction:actionChoose];
    [alertController addAction:actionTakePhoto];
    [self presentViewController:alertController animated:YES completion:nil];
//    [self presentViewController:imgPC animated:YES completion:nil];
}
#pragma mark 实现imagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    YJLog(@"##########info=%@##########",info);
    //获取修改后的图片
    UIImage *editImg=info[UIImagePickerControllerEditedImage];
    self.iconImg.image=editImg;
    //移除图片控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    //上传新图片
    [self YJEditViewController:nil didfinished:nil];
    
}
#pragma mark 实现YJEditViewController代理方法
-(void)YJEditViewController:(YJEditViewController *)YJEditViewController didfinished:(id)sender{
    //获取电子卡片
    XMPPvCardTemp *vCard=[YJXMPPTool sharedYJXMPPTool].vCard.myvCardTemp;
    //存储修改信息
    vCard.photo=UIImageJPEGRepresentation(self.iconImg.image, 0.75);
    vCard.nickname=self.nicknameCell.detailTextLabel.text;
    YJLog(@"nickname=%@",vCard.nickname);
//    NSMutableArray *temp=[NSMutableArray array];
    vCard.middleName=self.adressCell.detailTextLabel.text;
    vCard.prefix=self.sexCell.detailTextLabel.text;
    vCard.suffix=self.locationCell.detailTextLabel.text;
    vCard.note=self.introduceCell.detailTextLabel.text;
    //上传修改信息
    
    [[YJXMPPTool sharedYJXMPPTool].vCard updateMyvCardTemp:vCard];
}
#pragma mark 设置代理并把数据给下一个控制器
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVC=segue.destinationViewController;
    if ([destVC isKindOfClass:[YJEditViewController class]]) {
        YJEditViewController *editVC=destVC;
        editVC.cell=sender;
        editVC.delegate=self;
    }
}


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
