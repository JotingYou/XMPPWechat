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
#define kDetail @"detail"
#define kPictures @"pictures"

@interface YJContentViewController ()<YJToolbarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txt;
@property (nonatomic,strong) YJToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation YJContentViewController
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(YJToolbar *)toolbar{
    if (!_toolbar) {
        YJToolbar *toolbar=[[YJToolbar alloc]init];
        toolbar.YJDelegate=self;
        _toolbar=toolbar;
    }
    return _toolbar;
}
- (IBAction)publish:(UIBarButtonItem *)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.txt.text forKey:kDetail];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(YJContentViewController:didFinishedPublish:)]) {
        [self.delegate YJContentViewController:self didFinishedPublish:nil];
    }
}

- (void)viewDidLoad {
    self.txt.inputAccessoryView=self.toolbar;
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
    SDImageCache *cache=[[SDImageCache alloc]init];
    [cache storeImage:img forKey:kPictures];
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
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
