//
//  YxzSubscriptionCell.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzSubscriptionCell.h"

@implementation YxzSubscriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)msgAttributeTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClick:)]) {
        [self.delegate userClick:self.msgModel.user];
    }
}

- (void)setMsgModel:(YXZMessageModel *)msgModel {
    [super setMsgModel:msgModel];
        
    self.msgLabel.attributedText = msgModel.attributeModel.msgAttribText;
    
    self.bgLb.backgroundColor = msgModel.attributeModel.bgColor;
}
@end
