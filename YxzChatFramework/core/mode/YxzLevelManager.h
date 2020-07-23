//
//  YxzLevelManager.h
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YxzLevelManager : NSObject
+ (instancetype)sharedInstance;

/** 初始化（APP生命周期只需要执行一次） */
- (void)setup;

- (UIImage *)imageForLevel:(NSInteger)Level;

@end

NS_ASSUME_NONNULL_END
