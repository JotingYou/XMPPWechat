//
//  YJCellFrame.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/5/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJCellFrame.h"
#import "YJTask.h"
@implementation YJCellFrame
-(instancetype)initWithModel:(YJTask *)task{
    if (self=[super init]) {
        self.task=task;
        [self setCellFrame:task];
    }
    return self;
}
+(instancetype)cellFrameWithModel:(YJTask *)task{
    return [[self alloc]initWithModel:task];
}
-(void)setCellFrame:(YJTask *)task{
    //设置空隙
    CGFloat margin = 10;
    //设置头像大小
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    CGFloat iconX = margin;
    CGFloat iconY = margin;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    //设置昵称大小
    CGSize nameSize = [self sizeWithText:self.task.title maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:YJTitleFont];
    CGFloat nameX = CGRectGetMaxX(_iconFrame) + margin;
    CGFloat nameY = iconY + (iconH - nameSize.height)/2;
    _titleFrame = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
//    //设置VIP大小
//    CGFloat vipW = 14;
//    CGFloat vipH = 14;
//    CGFloat vipY = nameY;
//    CGFloat vipX = CGRectGetMaxX(_nameFrame) + margin;
//    _vipFrame = CGRectMake(vipX, vipY, vipW, vipH);
    //设置内容大小
    CGSize textSize = [self sizeWithText:self.task.detail maxSize:CGSizeMake(355, MAXFLOAT) fontSize:YJDetailFont];
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(_iconFrame) + margin;
    _detailFrame = (CGRect){{textX,textY},textSize};
    //设置图片大小
    if (self.task.imgName.length) {
        CGFloat pictureW = 75;
        CGFloat pictureH = 100;
        CGFloat pictureX = iconX;
        CGFloat pictureY = CGRectGetMaxY(_detailFrame) + margin;
        _imgFrame = (CGRect){{pictureX,pictureY},{pictureW,pictureH}};
        
        _rowHeight = CGRectGetMaxY(_imgFrame) + margin;
    }else{
        _rowHeight = CGRectGetMaxY(_detailFrame) + margin;
    }
    
}
//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

@end
