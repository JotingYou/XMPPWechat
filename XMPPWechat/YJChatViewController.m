//
//  YJChatViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/14.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJChatViewController.h"
#import "HttpTool.h"
#import "YJXMPPTool.h"
#import "UIImageView+WebCache.h"
#import "YJAccount.h"
#import "MBProgressHUD+HM.h"
@interface YJChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSFetchedResultsController *_fetchResultsController;
}
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *txtfield;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation YJChatViewController
#pragma mark -添加附件
//选择图片
- (IBAction)addFile:(id)sender {
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //创建图片选择控制器
    UIImagePickerController *imgCTR=[[UIImagePickerController alloc]init];
    imgCTR.delegate=self;
    imgCTR.allowsEditing=YES;
    
    
    UIAlertAction *takePhoto=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        imgCTR.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgCTR animated:YES completion:nil];
        
    }];
    UIAlertAction *choosePhoto=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imgCTR.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgCTR animated:YES completion:nil];
        
    }];
    [alertController addAction:cancle];
    [alertController addAction:takePhoto];
    [alertController addAction:choosePhoto];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//图片选择完成后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img=info[UIImagePickerControllerOriginalImage];
    [self sendImg:img];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)sendImg:(UIImage*)img{
     // 1.1定义文件名 user + 年月日分秒
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateFormat=@"yyyyMMddHHmmss";
    NSString *currentTime=[dateFormat stringFromDate:[NSDate date]];
    NSString *imgName=[[YJAccount shareAccount].loginAct stringByAppendingString:currentTime];
    //1.2拼接上传路径
    NSString *putURL=[@"http://localhost:8080/imfileserver/Upload/Image/" stringByAppendingString:imgName];
    YJLog(@"currentTime=%@",putURL);
    //2.上传成功后，把文件发给openfire服务器
    HttpTool *httpTool=[[HttpTool alloc]init];
    //文件以JPG上传，只接收JPG
    [httpTool uploadData:UIImageJPEGRepresentation(img, 0.75) url:[NSURL URLWithString:putURL] progressBlock:nil completion:^(NSError *error) {
        if (!error) {
            XMPPMessage *msg=[XMPPMessage messageWithType:@"chat" to:self.friendJid];
            [msg addAttributeWithName:@"bodyType" stringValue:@"image"];
            [msg addBody:putURL];
            [[YJXMPPTool sharedYJXMPPTool].xmppStream sendElement:msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"图片发送成功"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"发送失败，请重试"];
            });
        }
    }];
}
- (IBAction)sendMsg {
    [self textFieldShouldReturn:self.txtfield];
    [self.view endEditing:YES];
}
-(void)loadChat{
    //加载数据库的聊天数据
    
    // 1.上下文
    NSManagedObjectContext *manageContext=[YJXMPPTool sharedYJXMPPTool].msgArchivingStorage.mainThreadManagedObjectContext;
    // 2.查询请求
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 过滤 （当前登录用户 并且 好友的聊天消息）
    NSString *loginJid=[YJXMPPTool sharedYJXMPPTool].xmppStream.myJID.bare;
    YJLog(@"loginJid=%@",loginJid);
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",loginJid,self.friendJid.bare];
    request.predicate=predicate;
    // 设置时间排序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors=@[sort];
    // 3.执行请求
    NSError *err=nil;
    _fetchResultsController =[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:manageContext sectionNameKeyPath:nil cacheName:nil];
    _fetchResultsController.delegate=self;
    [_fetchResultsController performFetch:&err];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self loadChat];


    // Do any additional setup after loading the view.
}
-(void)keyboardWillShow:(NSNotification*)noti{
//    self.view
    CGRect keyboardChangSize=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.inputView.transform=CGAffineTransformMakeTranslation(0,keyboardChangSize.origin.y-self.view.frame.size.height);
}
-(void)keyboardWillHide:(NSNotification*)noti{
    self.inputView.transform=CGAffineTransformMakeTranslation(0,0);

}
#pragma mark -实现tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YJLog(@"_fetchResultsController.fetchedObjects.count=%ld",_fetchResultsController.fetchedObjects.count);
    return _fetchResultsController.fetchedObjects.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *recuseID=@"myCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:recuseID ];
    //获取聊天信息
    XMPPMessageArchiving_Message_CoreDataObject *msgObj=_fetchResultsController.fetchedObjects[indexPath.row];
    //获取原始xml数据
    XMPPMessage *msg=msgObj.message;
    //获取附件类型
    NSString *bodyType=[msg attributeStringValueForName:@"bodyType"];
    //判断类型
    if ([bodyType isEqualToString:@"image"]) {
            //获取文件路径
            NSString *url=msgObj.body;
            //显示图片
    //        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"46"]];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            cell.textLabel.text=nil;
    }else{
        cell.textLabel.text=msgObj.body;
        cell.imageView.image=nil;
        
        
    }
    return cell;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark -实现UITextFiled代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"不能发送空消息"];
        return NO;
    }else{
        NSString *txt=[NSString stringWithFormat:@"%@:%@",[YJAccount shareAccount].loginAct,textField.text];
        //发送内容
        XMPPMessage *msg=[XMPPMessage messageWithType:@"chat" to:self.friendJid];
        [msg addBody:txt];
        [[YJXMPPTool sharedYJXMPPTool].xmppStream sendElement:msg];
        
        textField.text=nil;
        return YES;
    }
}

#pragma mark -数据内容改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
    //表格滚动到底部
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_fetchResultsController.fetchedObjects.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
