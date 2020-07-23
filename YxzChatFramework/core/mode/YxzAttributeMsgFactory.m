//
//  YxzAttributeMsgFactory.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzAttributeMsgFactory.h"
#import "YxzLevelManager.h"
#import <YYText/YYText.h>
#import <YYImage/YYImage.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
@implementation YxzAttributeMsgFactory

+(NSMutableAttributedString *)generateAttribute:(YxzMsgType)msgType font:(UIFont *)font msgModel:(YXZMessageModel *)msgModel  tipImages:(NSArray<id> *)tipImages giftImage:(UIImage *)giftImage tapCompletion:(AttributeTapBlock)tap {
    NSMutableAttributedString *msgAtrribute;
    switch (msgType) {
            case YxzMsgType_Subscription: { // 关注
                msgAtrribute=[self Subscriptionfont:font msgModel:msgModel tapCompletion:tap];
            }
                break;
            case YxzMsgType_Share: { // 分享
                msgAtrribute=[self Sharefont:font msgModel:msgModel tapCompletion:tap];
            }
                break;
            case YxzMsgType_Other:
            case YxzMsgType_barrage: { // 弹幕消息
                msgAtrribute=[self commentfont:font msgModel:msgModel tipImages:tipImages tapCompletion:tap];
            }
                break;
            case YxzMsgType_memberEnter: { // 用户进入直播间
                msgAtrribute=[self MemberEnterfont:font msgModel:msgModel tipImages:tipImages tapCompletion:tap];
            }
                break;
            case YxzMsgType_gift_text: {   // 礼物弹幕(文本)消息
                msgAtrribute=[self Gift_Textfont:font msgModel:msgModel tipImages:tipImages giftImage:giftImage tapCompletion:tap];
            }
                break;
            case YxzMsgType_Announcement: { // 系统公告信息
                msgAtrribute=[self UnknowMsgModel:msgModel font:font tapCompletion:tap];
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
    return msgAtrribute;
}
// 系统提示消息
+ (NSMutableAttributedString *)UnknowMsgModel:(YXZMessageModel *)msgModel font:(UIFont *)font tapCompletion:(AttributeTapBlock)tap{
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    
    NSMutableAttributedString *attribute = [self getAttributed:msgModel.content font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:tap];
    attribute.yy_paragraphStyle = paraStyle;
    
    return attribute;
}
// 礼物消息
+(NSMutableAttributedString *)Gift_Textfont:(UIFont *)font msgModel:(YXZMessageModel *)msgModel tipImages:(NSArray<id> *)tipImages giftImage:(UIImage *)fromGiftImage tapCompletion:(AttributeTapBlock)tap{
    int i = [msgModel.quantity intValue];
    
    // 等级
    NSMutableAttributedString *textView =[self getAttachText:[[YxzLevelManager sharedInstance] imageForLevel:msgModel.user.level] font:font tap:YES tapCompletion:tap];;
    //[self getAttachText:[[YxzLevelManager sharedInstance] imageForLevel:msgModel.user.level] tap:YES];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    /**徽章*/
    
    [self addTipImage:textView font:font tipImages:tipImages tapCompletion:tap];
    
    NSMutableAttributedString *attribute = [self getAttributed:[NSString stringWithFormat:@"%@", msgModel.user.nickName] font:font color:MsgNameColor tap:YES shadow:NO tapCompletion:tap];
    
    NSMutableAttributedString *giveAttText = [self getAttributed:@" 送出了" font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:tap];
    
    /**礼物图片*/
    UIImage *gifImage;// = [UIImage imageWithColor:[UIColor clearColor] widthHeight:19];
    if (fromGiftImage) {
        gifImage = fromGiftImage;
    }
    
    CGSize size = CGSizeMake(19, 22);
    UIImage *newImage = [self scaleToSize:size image:gifImage];
    NSMutableAttributedString *gifImageStr =[self getAttachText:newImage font:font tap:NO tapCompletion:nil];
    //[self getAttachText:newImage tap:NO];
    
    
    NSMutableAttributedString *countText;
    if (i > 1) {
        NSString *giftX = [NSString stringWithFormat:@"x%d", i];
        countText =[self getAttributed:giftX font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:nil];
        //[self getAttributed:giftX font:font color:MsgLbColor tap:NO shadow:YES];
    }
    
    
    [textView appendAttributedString:attribute];
    [textView appendAttributedString:giveAttText];
    [textView appendAttributedString:gifImageStr];
    // 连击数超过1才显示连击数字 应测试要求
    if (countText.string.length > 0) {
        [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [textView appendAttributedString:countText];
    }
    
//    self.msgAttribText = textView;
//
//    // 获取高度 宽度
//    [self YYTextLayoutSize:self.msgAttribText];
    
    //    self.msgHeight = 24;
    return textView;
}
// 成员加入
+(NSMutableAttributedString *)MemberEnterfont:(UIFont *)font msgModel:(YXZMessageModel *)msgModel tipImages:(NSArray<id> *)tipImages tapCompletion:(AttributeTapBlock)tap {
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    
    NSMutableAttributedString *welcomeAttribText = [self getAttributed:[NSString stringWithFormat:@"%@ ", @"欢迎"] font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:tap];
    
    NSMutableAttributedString *textView =[self getAttachText:[[YxzLevelManager sharedInstance] imageForLevel:msgModel.user.level] font:font tap:YES tapCompletion:tap];
    //[self getAttachText:[[YxzLevelManager sharedInstance] imageForLevel:msgModel.user.level] tap:YES tapCompletion:tap];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    /**徽章*/
    [self addTipImage:textView font:font tipImages:tipImages tapCompletion:tap];
    
    // 显示内容
    NSMutableAttributedString *attribute = [self getAttributed:[NSString stringWithFormat:@"%@", msgModel.user.nickName] font:font color:MsgNameColor tap:YES shadow:NO tapCompletion:tap];
    
    NSMutableAttributedString *str2 = [self getAttributed:[NSString stringWithFormat:@"  %@", @"来到直播间"] font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:nil];
    
    [welcomeAttribText appendAttributedString:textView];
    [welcomeAttribText appendAttributedString:attribute];
    [welcomeAttribText appendAttributedString:str2];
    
    welcomeAttribText.yy_paragraphStyle = paraStyle;
    
    
    
    return welcomeAttribText;
}
// 聊天
+ (NSMutableAttributedString *)commentfont:(UIFont *)font msgModel:(YXZMessageModel *)msgModel tipImages:(NSArray<id> *)tipImages tapCompletion:(AttributeTapBlock)tap {
    NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    paraStyle.lineSpacing = 3.0f;//行间距
    // 首行缩进
    //paraStyle.firstLineHeadIndent = 33;
    
    // 等级
    NSMutableAttributedString *textView =[self getAttachText:[[YxzLevelManager sharedInstance] imageForLevel:msgModel.user.level] font:font tap:YES tapCompletion:tap];
    //[self getAttachText:[[YxzLevelManager sharedInstance] imageForLevel:msgModel.user.level] tap:YES];
    [textView appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    /**徽章*/
    [self addTipImage:textView font:font tipImages:tipImages tapCompletion:tap];
    
    // 名字
    NSString *firstStr = [NSString stringWithFormat:@"%@：",  msgModel.user.nickName];
    NSMutableAttributedString *name =[self getAttributed:firstStr font:font color:MsgNameColor tap:YES shadow:NO tapCompletion:tap];
    //[self getAttributed:firstStr font:font color:MsgNameColor tap:YES shadow:NO];
    
    // @用户
    if (msgModel.atUser) {
        NSString *answerStr = [NSString stringWithFormat:@"@%@ ", msgModel.atUser.nickName];
        NSMutableAttributedString *answerName = [self getAttributed:answerStr font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:tap];
        [name appendAttributedString:answerName];
    }
    
    // 内容
    NSMutableAttributedString *content = [self getAttributed:msgModel.content font:font color:MsgTitleColor tap:NO shadow:YES tapCompletion:nil];
    
    [textView appendAttributedString:name];
    [textView appendAttributedString:content];
    textView.yy_paragraphStyle = paraStyle;
    
    return textView;
    
    
}

// 分享
+(NSMutableAttributedString *)Sharefont:(UIFont *)font msgModel:(YXZMessageModel *)msgModel tapCompletion:(AttributeTapBlock)tap{
    
    NSMutableAttributedString *attribuite= [self UnknowCell:@"分享了直播间" font:font msgModel:msgModel tapCompletion:tap];
    return attribuite;
}

// 关注
+(NSMutableAttributedString *)Subscriptionfont:(UIFont *)font msgModel:(YXZMessageModel *)msgModel tapCompletion:(AttributeTapBlock)tap{
    NSMutableAttributedString *attribuite= [self UnknowCell:@"关注了主播" font:font msgModel:msgModel tapCompletion:tap];
    return attribuite;
}
// 将个人标签生成富文本
+(void)addTipImage:(NSMutableAttributedString *)attachText font:(UIFont *)font tipImages:(NSArray<id> *)tipImages tapCompletion:(AttributeTapBlock)tap{
    CGFloat lineH = 18;
    for (UIImage *image in tipImages) {
        if (![image isKindOfClass:[UIImage class]]) {
            continue;
        }
        CGFloat scale = image.size.height / lineH;
        CGSize size = CGSizeMake(image.size.width / scale, lineH);
        UIImage *newImage = [self scaleToSize:size image:image];
        NSMutableAttributedString *labs = [self getAttachText:newImage font:font tap:YES tapCompletion:tap];
        [attachText appendAttributedString:labs];
        [attachText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
}
#pragma mark ----- 图片、view生成富文本
+ (NSMutableAttributedString *)getAttachText:(UIImage *)image font:(UIFont *)font tap:(BOOL)isTap tapCompletion:(AttributeTapBlock)tap{
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    // 强制排版(从左到右)
    attachText.yy_baseWritingDirection = NSWritingDirectionLeftToRight;
    attachText.yy_writingDirection = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)];
    attachText.yy_paragraphStyle = [self paragraphStyle];
    
    if (isTap) {
        __weak typeof(self) weakSelf;
        YYTextHighlight *highlight = [YYTextHighlight new];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if (tap) {
                tap(containerView,text,range,rect);
            }
        };
        [attachText yy_setTextHighlight:highlight range:attachText.yy_rangeOfAll];
    }
    
    return attachText;
}
#pragma mark ----- 设置富文本
// 综合类型
+ (NSMutableAttributedString *)UnknowCell:(NSString *)appendStr font:(UIFont *)font msgModel:(YXZMessageModel *)msgModel tapCompletion:(AttributeTapBlock)tap{
    //NSMutableParagraphStyle *paraStyle = [self paragraphStyle];
    
    NSString *firstStr = [NSString stringWithFormat:@"%@ ", msgModel.user.nickName];
    NSMutableAttributedString *attribute = [self getAttributed:firstStr font:font color:MsgNameColor tap:YES shadow:NO tapCompletion:tap];
    
    NSMutableAttributedString *string1 = [self getAttributed:appendStr font:font color:MsgLbColor tap:NO shadow:YES tapCompletion:tap];
    
    [attribute appendAttributedString:string1];
    
    // 获取高度 宽度
//    [self YYTextLayoutSize:attribute];
    
    return attribute;
}

#pragma mark ----- 获取cell高度
+ (CGSize)YYTextLayoutSize:(NSMutableAttributedString *)attribText {
    // 距离左边8  距离右边也为8
    CGFloat maxWidth = MsgTableViewWidth - 16;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, MAXFLOAT) text:attribText];
    CGSize size = layout.textBoundingSize;
    
    if (size.height && size.height < 24) {
        size.height = 24;
    } else {
        // 再加上6=文字距离上下的间距
        size.height = size.height + 6;
    }
    
//    self.msgHeight = size.height;
//    self.msgWidth = size.width;
    return size;
}
/**
 字符串生成富文本
 @param isTap 是否添加点击事件
 @param isShadow 是否添加文字投影效果
 */
+ (NSMutableAttributedString *)getAttributed:(NSString *)text font:(UIFont *)font color:(UIColor *)color tap:(BOOL)isTap shadow:(BOOL)isShadow tapCompletion:(AttributeTapBlock)tap{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    attribute.yy_font = font;
    attribute.yy_color = color;
    // 强制排版(从左到右)
    attribute.yy_baseWritingDirection = NSWritingDirectionLeftToRight;
    attribute.yy_writingDirection = @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)];
    attribute.yy_paragraphStyle = [self paragraphStyle];
    
    if (isShadow) {
        attribute.yy_textShadow = [self getTextShadow];
    }
    
    if (isTap) {
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if (tap) {
                tap(containerView,text,range,rect);
            }
        };
        [attribute yy_setTextHighlight:highlight range:attribute.yy_rangeOfAll];
    }
    
    return attribute;
}
#pragma mark ----- 方法
+ (NSMutableParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 0.0f;//行间距
   
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    return paraStyle;
}
// 文字阴影效果
+ (YYTextShadow *)getTextShadow {
    YYTextShadow *shadow = [[YYTextShadow alloc] init];
    //shadow.shadowBlurRadius = 1;
    shadow.offset = CGSizeMake(0, 0.5);
    shadow.color = RGBAOF(0x000000, 0.5);
    
    return shadow;
}
// 像这些方法你可以提取到UIImage分类中，
+(UIImage *)scaleToSize:(CGSize)size image:(UIImage *)image
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
