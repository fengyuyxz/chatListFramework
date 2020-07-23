//
//  YxzChatListTableView.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXZMessageModel.h"
// 刷新消息方式
typedef NS_ENUM(NSUInteger, YxzReloadLiveMsgRoomType) {
    YxzReloadLiveMsgRoom_Time = 0, // 0.5秒刷新一次消息
    YxzReloadLiveMsgRoom_Direct,   // 直接刷新
};
@protocol RoomMsgListDelegate <NSObject>
@optional
- (void)startScroll;
- (void)endScroll;
- (void)touchSelfView;
// 回复
- (void)didAiTe:(YxzUserModel *)user;
- (void)didUser:(YxzUserModel *)user;

// 提示关注 分享 送礼物点击
- (void)didRemindFollowComplete:(void(^)(BOOL))complete;
- (void)didRemindShare;
- (void)didRemindGifts;
- (void)didCopyWithText:(NSString *)text;
@end
@interface YxzChatListTableView : UIView
@property (nonatomic, weak) id<RoomMsgListDelegate> delegate;
@property (nonatomic, assign) YxzReloadLiveMsgRoomType reloadType;
@property (nonatomic, strong) UITableView *tableView;
/** 添加新的消息 */
- (void)addNewMsg:(YXZMessageModel *)msgModel;

// 倒计时显示的系统提示语
- (void)startDefaultMsg:(NSString *)text;

//清空消息重置
- (void)reset;
- (void)startTimer;
@end


