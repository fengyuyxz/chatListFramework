//
//  YxzChatBaseCell.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzChatBaseCell.h"
#import <Masonry/Masonry.h>
#import "YxzNormalCell.h"
#import "YxzSubscriptionCell.h"
#import "YxzCommenCell.h"
#import "YxzMsgJoinCell.h"
#import "YxzMsgGiftCell.h"
@implementation YxzChatBaseCell

- (void)dealloc {
    NSLog(@"dealloc-----%@", NSStringFromClass([self class]));
}

/** cell标示 */
+ (NSString *)msgCellIdentifier {
    // cell identifier 为自己子类类名
    return NSStringFromClass([self class]);
}
+ (YxzChatBaseCell *)initMsgCell:(UITableView *)tableView cellForType:(YxzMsgType)type indexPath:(NSIndexPath *)indexPath {
    NSString *identityName = [NSString stringWithFormat:@"%@_%ld", [self msgCellIdentifier], type];//
    [tableView registerClass:[self class] forCellReuseIdentifier:identityName];
    
    YxzChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identityName forIndexPath:indexPath];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityName];
    }
    
    return cell;
}
+ (YxzChatBaseCell *)tableView:(UITableView *)tableView cellForMsg:(YXZMessageModel *)msg indexPath:(NSIndexPath *)indexPath delegate:(id<MsgCellGesDelegate>)delegate{
    YxzChatBaseCell *cell = nil;
        YxzMsgType type = msg.msgType;
        
        switch (type) {
   
            case YxzMsgType_Announcement:
            { // 公告信息
                cell=[YxzNormalCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            }
                break;
            case YxzMsgType_Subscription:
            { // 关注
                cell=[YxzSubscriptionCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            }
                break;
            case YxzMsgType_Share:
            { // 分享
                cell=[YxzSubscriptionCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            }
                break;
            case YxzMsgType_barrage:
            case YxzMsgType_Other:
            { // 弹幕消息
                cell=[YxzCommenCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            }
                break;
            case YxzMsgType_memberEnter:
            { // 用户进入直播间
                cell=[YxzMsgJoinCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            }
                break;
            case YxzMsgType_gift_text:
            { // 礼物弹幕(文本)消息
                cell=[YxzMsgGiftCell initMsgCell:tableView cellForType:type indexPath:indexPath];
            }
                break;
            default:
                break;
        }
        cell.delegate = delegate;
        cell.msgModel = msg;
        
        return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.bgLb];
        [self addSubview:self.msgLabel];
        
        [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(cellLineSpeing+4);
            make.bottom.mas_equalTo(-2);
            make.right.mas_lessThanOrEqualTo(-8);
            
        }];

        [self.bgLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cellLineSpeing);
            make.left.bottom.mas_equalTo(0);
            make.right.equalTo(self.msgLabel.mas_right).offset(8);
        }];
        
        YxzViewRadius(self.bgLb, 12);
    }
    return self;
}
- (void)setMsgModel:(YXZMessageModel *)msgModel {
    _msgModel = msgModel;
    _msgModel.attributeModel.delegate = self;
}
#pragma mark - YxzMsgAttributeModelDelegate
/** 属性文字刷新后调用 */
- (void)attributeUpdated:(YxzMsgAttributeModel *)model{
    if ([self.msgModel.msgID isEqualToString:model.msgModel.msgID]) {
          if (self.delegate && [self.delegate respondsToSelector:@selector(msgAttrbuiteUpdated:)]) {
              dispatch_async(dispatch_get_main_queue(), ^{
                 [self.delegate msgAttrbuiteUpdated:self.msgModel];
              });
          }
      }
}

// 富文本点击
- (void)msgAttributeTapAction{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchMsgCellView)]) {
        [self.delegate touchMsgCellView];
    }
}
// 添加长按点击事件
- (void)addLongPressGes {
    //self.userInteractionEnabled = YES;
    self.msgLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
    longPressGes.minimumPressDuration = 0.3;
    [self.msgLabel addGestureRecognizer:longPressGes];
}
-(void)longPressGes:(UILongPressGestureRecognizer *)longPress{
    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressGes:)]) {
        [self.delegate longPressGes:self.msgModel];
    }
}
- (YYLabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[YYLabel alloc] init];
        _msgLabel.numberOfLines = 0;
        //_msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //_msgLabel.font = [UIFont boldSystemFontOfSize:MSG_LABEL_FONT];
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.clipsToBounds = YES;
        _msgLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _msgLabel.userInteractionEnabled = YES;
        // 强制排版(从左到右)
        _msgLabel.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
    return _msgLabel;
}

- (UIImageView *)bgLb {
    if (!_bgLb) {
        _bgLb = [[UIImageView alloc] init];
        _bgLb.userInteractionEnabled = NO;
    }
    return _bgLb;
}
@end
