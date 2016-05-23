//
//  YJDiscoverTableViewCell.h
//  XMPPWechat
//
//  Created by 姚家庆 on 16/5/23.
//  Copyright © 2016年 姚家庆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJCellFrame;
@interface YJDiscoverTableViewCell : UITableViewCell
-(instancetype)discoverCellWithcellFrame:(YJCellFrame*)cellFrame;
+(instancetype)discoverCellWithtableView:(UITableView*)tableView;
@end
