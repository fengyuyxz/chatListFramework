//
//  YXZMessageModel.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXZConstant.h"
#import "YxzUserModel.h"
#import "YxzGiftModel.h"
#import "YxzMsgAttributeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXZMessageModel : NSObject
@property(nonatomic,assign)YxzMsgType msgType;
@property (nonatomic, strong) YxzUserModel *user;
@property(nonatomic,copy)NSString *content;// 消息内容


@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *msgID;

/// 被@的用户
@property (nonatomic, strong) YxzUserModel *atUser;

@property (nonatomic, strong) YxzGiftModel *giftModel;

@property (nonatomic, strong) YxzMsgAttributeModel *attributeModel;//富文本消息

- (void)initMsgAttribute;
@end

NS_ASSUME_NONNULL_END
