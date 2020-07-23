//
//  YxzLeveBgView.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YxzLeveBgView : UIImageView
@property (nonatomic, assign) NSInteger level;

// 文字是否显示高亮
@property (nonatomic, assign) BOOL isShadeLv;

@end

NS_ASSUME_NONNULL_END
