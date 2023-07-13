//
//  XMPPMessage+Utils.m
//  XMPPWechat
//
//  Created by Joting You on 2023/7/13.
//  Copyright © 2023 姚家庆. All rights reserved.
//

#import "XMPPMessage+Utils.h"
#import "YJXMPPTool.h"
@implementation XMPPMessage(Utils)
- (BOOL)isMyMessage{
    let from = self.from;
    let myJID = [YJXMPPTool sharedYJXMPPTool].myJID;
    if([from isEqualToJID:myJID options:XMPPJIDCompareBare]){
        return true;
    }
    return false;
}
@end
