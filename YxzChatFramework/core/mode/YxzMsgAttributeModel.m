//
//  YxzMsgAttributeModel.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzMsgAttributeModel.h"
#import "YxzAttributeMsgFactory.h"
#import "YXZMessageModel.h"
#import "YxzLevelManager.h"
#import <YYText/YYText.h>
#import <YYImage/YYImage.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
@interface YxzMsgAttributeModel()
@property (nonatomic, strong) UIFont *font;
/** 附件图片（目前只有用户徽章） */
@property (nonatomic, strong) NSArray<id> *tipImages;
/** 附件图片下载结束 */
@property (nonatomic, assign) BOOL finishDownloadTipImg;
/** 礼物缩略图 */
@property (nonatomic, strong) UIImage *giftImage;
/** 礼物缩略图下载结束 */
@property (nonatomic, assign) BOOL finishDownloadGiftImg;


///////////////////////////////// 附加属性 /////////////////////////////////
/** SDwebImage的所有请求 */
@property (nonatomic, strong) NSMutableArray *tempLoads;

@end



@implementation YxzMsgAttributeModel
- (instancetype)init {
    if (self = [super init]) {
        self.msgColor = MsgLbColor;
        self.bgColor = NormalBgColor;
        
        self.font = [UIFont boldSystemFontOfSize:14];
        
        self.tempLoads = [NSMutableArray array];
    }
    return self;
}
- (instancetype)initWithMsgModel:(YXZMessageModel *)msgModel {
    if (self = [self init]) {
        self.msgModel = msgModel;
        
        [self msgUpdateAttribute];
    }
    return self;
}
/** 重新计算属性 */
- (void)msgUpdateAttribute {
    [self getAttributedStringFromSelf];
}



/** 下载标签图片（目前只有徽章） */
- (void)downloadTagImage {
    // 这里的逻辑和下载礼物缩略图同样的逻辑
}
#pragma mark - 图片标签下载
/** 下载礼物缩略图 */
- (void)downloadGiftImage {
    NSString *urlStr = self.msgModel.giftModel.thumbnailUrl;
    if (!urlStr || urlStr.length < 1) {
        return;
    }
    if (self.finishDownloadGiftImg) {
        return;
    }
    self.finishDownloadGiftImg = YES;
    
    // 1. 如果本地有图片
    self.giftImage = [self cacheImage:urlStr];
    if (self.giftImage) {
        return;
    }
    
    // 2. 下载远程图片
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak typeof(self) weakSelf =  self;
    id sdLoad = [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image){
            // 刷新UI
            weakSelf.giftImage = image;
            // 更新属性文字
            [weakSelf downloadTagImageFinish];
        }
    }];
    [self.tempLoads addObject:sdLoad];
}

- (void)downloadTagImageFinish {
    // 更新属性文字
    [self msgUpdateAttribute];
    // 通知代理刷新属性文字
    if (self.delegate && [self.delegate respondsToSelector:@selector(attributeUpdated:)]) {
        [self.delegate attributeUpdated:self];
    }
}


- (void)getAttributedStringFromSelf {
    __weak typeof(self)weakSelf;
    void(^AttributeTapBlock)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)=^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(msgAttributeTapAction)]) {
                       [weakSelf.delegate msgAttributeTapAction];
         }
    };
    NSMutableAttributedString *msgTxt;
    switch (self.msgModel.msgType) {
        case YxzMsgType_Subscription: { // 关注
            self.bgColor = NormalBgColor;

            msgTxt=[YxzAttributeMsgFactory generateAttribute:self.msgModel.msgType font:self.font msgModel:self.msgModel tipImages:self.tipImages giftImage:self.giftImage tapCompletion:AttributeTapBlock];
           
            

               
        }
            break;
        case YxzMsgType_Share: { // 分享
            self.bgColor = NormalBgColor;
            msgTxt=[YxzAttributeMsgFactory generateAttribute:self.msgModel.msgType font:self.font msgModel:self.msgModel tipImages:self.tipImages giftImage:self.giftImage tapCompletion:AttributeTapBlock];
        }
            break;
        case YxzMsgType_Other:
        case YxzMsgType_barrage: { // 弹幕消息
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            
            msgTxt=[YxzAttributeMsgFactory generateAttribute:self.msgModel.msgType font:self.font msgModel:self.msgModel tipImages:self.tipImages giftImage:self.giftImage tapCompletion:AttributeTapBlock];
        }
            break;
        case YxzMsgType_memberEnter: { // 用户进入直播间
            // 下载标签图片
            [self downloadTagImage];
            self.bgColor = NormalBgColor;
            msgTxt=[YxzAttributeMsgFactory generateAttribute:self.msgModel.msgType font:self.font msgModel:self.msgModel tipImages:self.tipImages giftImage:self.giftImage tapCompletion:AttributeTapBlock];
        }
            break;
        case YxzMsgType_gift_text: {   // 礼物弹幕(文本)消息
            // 下载标签图片
            [self downloadTagImage];
            // 下载礼物图片
            [self downloadGiftImage];
            self.bgColor = NormalBgColor;
            msgTxt=[YxzAttributeMsgFactory generateAttribute:self.msgModel.msgType font:self.font msgModel:self.msgModel tipImages:self.tipImages giftImage:self.giftImage tapCompletion:AttributeTapBlock];
        }
            break;
        case YxzMsgType_Announcement: { // 系统公告信息
            self.bgColor = NormalBgColor;
             msgTxt=[YxzAttributeMsgFactory generateAttribute:self.msgModel.msgType font:self.font msgModel:self.msgModel tipImages:self.tipImages giftImage:self.giftImage tapCompletion:AttributeTapBlock];
                   
        }
            break;
//        case NDSubMsgType_TimeMsg: { // 客户端提示消息
//            self.bgColor = RemindBgColor2;
//            [self Announcement];
//        }
//            break;
            
        default:
            break;
    }

    CGSize size=[YxzAttributeMsgFactory YYTextLayoutSize:msgTxt];
    self.msgWidth=size.width;
    self.msgHeight=size.height;
    self.msgAttribText=msgTxt;
     
}
#pragma mark - TOOL 图片缓存
- (UIImage *)cacheImage:(NSString *)urlStr {
    // 缓存的图片（内存）
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlStr];
    
    // 缓存的图片（硬盘）
    if (!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    }
    
    return image;
}
@end
