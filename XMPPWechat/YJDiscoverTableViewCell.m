//
//  YJDiscoverTableViewCell.m
//  XMPPWechat
//
//  Created by 姚家庆 on 16/5/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import "YJDiscoverTableViewCell.h"
#import "YJCellFrame.h"
#import "YJTask.h"
#import <XMPPFramework/XMPPFramework.h>
#import "YJXMPPTool.h"
#import "YJAccount.h"
@interface YJDiscoverTableViewCell()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *titleView;
@property (nonatomic, weak) UILabel *detailView;
@property (nonatomic, weak) UIImageView *imgView;
@end


@implementation YJDiscoverTableViewCell
-(instancetype)discoverCellWithcellFrame:(YJCellFrame*)cellFrame{
    [self setDataWithModelFrame:cellFrame];
    return self;
}
+(instancetype)discoverCellWithtableView:(UITableView*)tableView{
    NSString *reuseID=@"discoverCell";
    YJDiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[YJDiscoverTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
-(void)setDataWithModelFrame:(YJCellFrame*)cellFrame{
    YJTask *model=cellFrame.task;
    //设置内容
    XMPPJID *jid=[XMPPJID jidWithUser:model.account domain:[YJAccount shareAccount].domain resource:@"phone"];
    NSLog(@"jid=%@",jid);
    NSData *imageData=[[YJXMPPTool sharedYJXMPPTool].avatar photoDataForJID:jid];
    self.iconView.image=[UIImage imageWithData:imageData];

    self.titleView.text=model.title;
    self.detailView.text=model.detail;
    //设置图像
    if (model.imgName.length) {
            self.imgView.image=[UIImage imageNamed:model.imgName];
        if (!self.imgView.image) {
            NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *imgPath=[doc stringByAppendingPathComponent:model.imgName];
            if (imgPath) {
                self.imgView.image=[UIImage imageWithContentsOfFile:imgPath];
            }
        }
        
        
        
    }
   
    
    
    //设置Frame
    self.iconView.frame=cellFrame.iconFrame;
    self.titleView.frame=cellFrame.titleFrame;
    self.detailView.frame=cellFrame.detailFrame;
    self.imgView.frame=cellFrame.imgFrame;
    
 
}
//重写构造方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        //头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        //标题
        UILabel *titleView = [[UILabel alloc] init];
        [self.contentView addSubview:titleView];
        self.titleView = titleView;
        //
        titleView.font = [UIFont systemFontOfSize:YJTitleFont];
        //内容
        UILabel *detailView = [[UILabel alloc] init];
        [self.contentView addSubview:detailView];
        self.detailView = detailView;
        detailView.font = [UIFont systemFontOfSize:YJDetailFont];
        detailView.numberOfLines = 0;
        //图片
        UIImageView *pictureView = [[UIImageView alloc] init];
        [self.contentView addSubview:pictureView];
        self.imgView = pictureView;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
