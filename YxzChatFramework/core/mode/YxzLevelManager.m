//
//  YxzLevelManager.m
//  YXZChatFramework
//
//  Created by 颜学宙 on 2020/7/22.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLevelManager.h"
#import "YxzLeveBgView.h"
@interface YxzLevelManager()

/** 数据源 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIImage *> *data;

@end

@implementation YxzLevelManager
+ (instancetype)sharedInstance {
    static YxzLevelManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YxzLevelManager alloc] init];
        instance.data = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (void)setup {
    [self.data removeAllObjects];
    
    for (NSInteger i = 0; i <= 100; i++) {
        // YxzLeveBgView就是我的等级生成器，返回view
        // 启动app我们调用一次这个方法，然后内存就有生成0-100等级图片
        YxzLeveBgView *view = [[YxzLeveBgView alloc] init];
        view.frame = CGRectMake(0, 0, 30.0, 14.0);
        view.layer.cornerRadius = 2;
        view.layer.masksToBounds = YES;
        view.isShadeLv = YES;
        view.level = i;
        
        [self.data setObject:[self convertCreateImageWithUIView:view] forKey:[NSString stringWithFormat:@"%li", (long)i]];
    }
    
    
//    NSMutableData *data = [[NSMutableData alloc]init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [archiver encodeObject:self.data forKey:@"talkData"];
//    [archiver finishEncoding];
//    NSLog(@"查看byte = %lu", (unsigned long)data.length);
}

- (UIImage *)imageForLevel:(NSInteger)Level {
    return [self.data objectForKey:[NSString stringWithFormat:@"%li", (long)Level]];
}


/** 将 UIView 转换成 UIImage */
- (UIImage *)convertCreateImageWithUIView:(UIView *)view {
    
    //UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
