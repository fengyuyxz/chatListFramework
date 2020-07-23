//
//  YXZMessageModel.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YXZMessageModel.h"

@implementation YXZMessageModel
- (void)initMsgAttribute {
    self.attributeModel = [[YxzMsgAttributeModel alloc] initWithMsgModel:self];
}

@end
