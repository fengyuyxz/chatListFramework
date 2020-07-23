//
//  YXZConstant.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#ifndef YXZConstant_h
#define YXZConstant_h
#import <UIKit/UIKit.h>
/** 消息类型 */
typedef NS_ENUM(NSUInteger, YxzMsgType) {
    YxzMsgType_Unknow=0,//未知
    YxzMsgType_Share,// 分享
    YxzMsgType_barrage,//弹幕
    YxzMsgType_Other,//他人
    YxzMsgType_memberEnter,//用户进入聊天室
    YxzMsgType_gift_text,//礼物文本消息
    YxzMsgType_Subscription,//关注订阅
    YxzMsgType_Announcement,   // 系统公告信息
};
#define cellLineSpeing  3

#define MsgTableViewWidth 300
#define MsgTableViewHeight 400
#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]

#define YxzViewRadius(view, rads)\
\
view.layer.cornerRadius = rads;\
view.layer.masksToBounds = YES;
// 主颜色 - 黄色
#define MsgLbColor          RGBA_OF(0xFFF7AA)
// 内容颜色
#define MsgTitleColor       RGBA_OF(0xFFFFFF)
// 名字颜色
#define MsgNameColor        RGBAOF(0xFFFFFF, 0.85)

// 背景颜色 黑色 透明度0.24
#define NormalBgColor   RGBAOF(0x000000, 0.24)


#endif /* YXZConstant_h */

