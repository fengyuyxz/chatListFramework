//
//  YxzUserModel.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YxzUserModel : NSObject
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userID;

@property (nonatomic, assign) NSInteger level;
// 0：男    1：女
@property (nonatomic, assign) NSInteger gender;
@end

NS_ASSUME_NONNULL_END
