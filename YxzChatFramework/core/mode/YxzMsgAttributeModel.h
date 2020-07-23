//
//  YxzMsgAttributeModel.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXZConstant.h"




@class YXZMessageModel;
@class YxzMsgAttributeModel;
@protocol YxzMsgAttributeModelDelegate <NSObject>
/** 属性文字刷新后调用 */
- (void)attributeUpdated:(YxzMsgAttributeModel *)model;
@optional
// 富文本点击
- (void)msgAttributeTapAction;

@end

@interface YxzMsgAttributeModel : NSObject
@property (nonatomic, weak) YXZMessageModel *msgModel;
@property (nonatomic, weak) id<YxzMsgAttributeModelDelegate> delegate;

// 消息高度
@property (nonatomic, assign) CGFloat msgHeight;
// 消息宽度
@property (nonatomic, assign) CGFloat msgWidth;

@property (nonatomic, strong) NSMutableAttributedString *msgAttribText;
@property (nonatomic, strong) UIColor *msgColor;
@property (nonatomic, strong) UIColor *bgColor;
- (instancetype)initWithMsgModel:(YXZMessageModel *)msgModel;

/** 重新计算属性 */
- (void)msgUpdateAttribute;
@end


