//
//  YJContant.m
//  individual contant
//
//  Created by 姚家庆 on 15/12/10.
//  Copyright © 2015年 姚家庆. All rights reserved.
//

#import "YJContant.h"

@implementation YJContant
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        //一定要赋值
        self.name =  [aDecoder decodeObjectForKey:@"name"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
    }
    
    return self;
}

@end
