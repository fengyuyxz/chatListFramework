//
//  YxzAttributeMsgFactory.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXZMessageModel.h"
#import <Foundation/Foundation.h>
#import "YXZConstant.h"
NS_ASSUME_NONNULL_BEGIN

@interface YxzAttributeMsgFactory : NSObject
typedef void(^AttributeTapBlock)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect);
+(NSMutableAttributedString *)generateAttribute:(YxzMsgType)msgType font:(UIFont *)font msgModel:(YXZMessageModel *)msgModel  tipImages:(NSArray<id> *)tipImages giftImage:(UIImage *)giftImage tapCompletion:(AttributeTapBlock)tap ;
+ (CGSize)YYTextLayoutSize:(NSMutableAttributedString *)attribText;
@end

NS_ASSUME_NONNULL_END
