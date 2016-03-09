//
//  YJAddViewController.m
//  individual contant
//
//  Created by 姚家庆 on 15/12/10.
//  Copyright © 2015年 姚家庆. All rights reserved.
//

#import "YJAddViewController.h"
#import "YJContant.h"
@interface YJAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtOtherName;



@end

@implementation YJAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//- (IBAction)actionSave:(id)sender {
//    if ([self.delegete respondsToSelector:@selector(addViewController:didSaveContact:)]) {
//        YJContant *contact=[[YJContant alloc]init];
//        contact.name=self.txtName.text;
//        contact.tel=self.txtOtherName.text;
//        self.contact=contact;
//        [self.delegete addViewController:self didSaveContact:self.contact];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//}
- (IBAction)save:(id)sender {
    if ([self.delegete respondsToSelector:@selector(addViewController:didSaveContact:)]) {
        YJContant *contact=[[YJContant alloc]init];
        contact.name=self.txtName.text;
        contact.tel=self.txtOtherName.text;
        self.contact=contact;
        [self.delegete addViewController:self didSaveContact:self.contact];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

@end
