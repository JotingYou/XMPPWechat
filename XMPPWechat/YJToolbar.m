//
//  YJToolbar.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/3/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJToolbar.h"
@interface YJToolbar()<UIImagePickerControllerDelegate>
@end
@implementation YJToolbar
-(instancetype)init{
    if (self=[super init]) {
        self=[[[NSBundle mainBundle]loadNibNamed:@"YJToolbar" owner:nil options:nil ]firstObject];
    }
    
    return self;
}
-(IBAction)itemDidClicked:(id)sender{
    if ([self.YJDelegate respondsToSelector:@selector(YJToolbarDidClicked:andItems:)]) {
        [self.YJDelegate YJToolbarDidClicked:self andItems:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
