//
//  YJContentViewController.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJContentViewController.h"
#import "YJToolbar.h"
#import "MBProgressHUD+HM.h"
#import "SDImageCache.h"
#import "YJTask.h"
#import "YJAccount.h"
#import "MBProgressHUD+HM.h"
#define kTitle @"title"

@interface YJContentViewController ()<YJToolbarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txt;
@property (nonatomic,strong) YJToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) NSMutableArray *tasks;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) NSString *imgName;
@end

@implementation YJContentViewController
-(NSString *)filePath{
    if (!_filePath) {
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        _filePath=[doc stringByAppendingPathComponent:@"tasks.plist"];
    }
    
    return _filePath;
}
-(NSMutableArray *)tasks{
    if (!_tasks) {
//        if (!_filePath) {
//            _filePath=[[NSBundle mainBundle]pathForResource:@"task.plist" ofType:nil];
//        }
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
-(YJToolbar *)toolbar{
    if (!_toolbar) {
        YJToolbar *toolbar=[[YJToolbar alloc]init];
        toolbar.YJDelegate=self;
        _toolbar=toolbar;
    }
    return _toolbar;
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)publish:(UIBarButtonItem *)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    YJTask *task=[[YJTask alloc]init];
    task.title=[defaults valueForKey:kTitle];
    task.detail=self.txt.text;
    NSString *loginAct=[YJAccount shareAccount].loginAct;
    task.account=loginAct;
    //如果有图片
    if (self.imgView.image) {
        NSFileManager *fm=[NSFileManager defaultManager];
        NSData *data;
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        NSDate *curDate = [NSDate date];//获取当前日期
        [formater setDateFormat:@"yyyyMMddHHmmss"];//时间格式
        NSString * curTime = [formater stringFromDate:curDate];
        if (UIImagePNGRepresentation(self.imgView.image) == nil) {
            data = UIImageJPEGRepresentation(self.imgView.image, 1);
//            self.imgName=[NSString stringWithFormat:@"%@%@.jpg",loginAct,curTime];
        } else {
            data = UIImagePNGRepresentation(self.imgView.image);
//            self.imgName=[NSString stringWithFormat:@"%@%@.png",loginAct,curTime];
        }
        self.imgName=[loginAct stringByAppendingString:curTime];
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *imgPath=[doc stringByAppendingPathComponent:self.imgName];
        [fm createFileAtPath:imgPath contents:data attributes:nil];
    }
    task.imgName=self.imgName;
    [self.tasks addObject:task];
    //将数据存储到沙盒
    NSMutableArray *arrayM=[NSMutableArray array];
    for (YJTask *newTask in self.tasks) {
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[newTask.title,newTask.detail,newTask.imgName,newTask.account] forKeys:@[@"title",@"detail",@"imgName",@"account"]];
        [arrayM addObject:dict];
    }
    [arrayM writeToFile:self.filePath atomically:YES];
//    NSData *data=[NSData dataWithContentsOfFile:self.filePath];
//    NSLog(@"data=%@",data);
        [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(YJContentViewController:didFinishedPublish:)]) {
        [self.delegate YJContentViewController:self didFinishedPublish:nil];
    }
}

- (void)viewDidLoad {
    self.txt.inputAccessoryView=self.toolbar;
    self.imgName=@"";
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 实现toolbar自定义代理
-(void)YJToolbarDidClicked:(YJToolbar *)YJToolbar andItems:(UITabBarItem *)Item{
    switch (Item.tag) {
        
        case 1:
            //@somebody
            [MBProgressHUD showError:@"功能待完善"];
            break;
        case 2:{
            //add image
            UIImagePickerController *imagePC=[[UIImagePickerController alloc]init];
            imagePC.delegate=self;
            imagePC.allowsEditing=YES;
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:@"请选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *takePhoto=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                imagePC.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePC animated:YES completion:nil];
            }];
            UIAlertAction *chooseFromLibrary=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                imagePC.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePC animated:YES completion:nil];
            }];
            [alertC addAction:cancle];
            [alertC addAction:takePhoto];
            [alertC addAction:chooseFromLibrary];
            [self presentViewController:alertC animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img=info[UIImagePickerControllerOriginalImage];
    self.imgView.image=img;
    [self dismissViewControllerAnimated:YES completion:nil];
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
