//
//  YxzChatBaseCell.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYLabel.h>
#import "YXZMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MsgCellGesDelegate <NSObject>
- (void)longPressGes:(YXZMessageModel *)MsgModel;
- (void)userClick:(YxzUserModel *)user;
- (void)touchMsgCellView;

// 提示关注 分享 送礼物点击
- (void)remindCellFollow:(YXZMessageModel *)msgModel;
- (void)remindCellShare;
- (void)remindCellGifts;

/** 消息属性文字发生变化（更新对应cell） */
- (void)msgAttrbuiteUpdated:(YXZMessageModel *)msgModel;

@end

@interface YxzChatBaseCell : UITableViewCell<YxzMsgAttributeModelDelegate>
@property (nonatomic, weak) id<MsgCellGesDelegate> delegate;
@property (nonatomic, strong) YYLabel *msgLabel;
@property (nonatomic, strong) UIImageView *bgLb;
@property (nonatomic, strong) YXZMessageModel *msgModel;
/** cell标示 */
+ (NSString *)msgCellIdentifier;

+ (YxzChatBaseCell *)tableView:(UITableView *)tableView cellForMsg:(YXZMessageModel *)msg indexPath:(NSIndexPath *)indexPath delegate:(id<MsgCellGesDelegate>)delegate;

// 添加长按点击事件
- (void)addLongPressGes;
@end

NS_ASSUME_NONNULL_END
