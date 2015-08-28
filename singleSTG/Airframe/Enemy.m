//
//  Enemy.m
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (BOOL)isOverScreen{
    if (self.center.x < -20 || self.center.x > [UIScreen mainScreen].bounds.size.width+20) {
        return YES;
    }
    if (self.center.y < -20 || self.center.y > [UIScreen mainScreen].bounds.size.height+20) {
        return YES;
    }
    return NO;
}

- (BOOL)continueMove{
    // 跃出屏幕，释放
    if ([self isOverScreen]) {
        if ([self.delegate respondsToSelector:@selector(airframe:didOverScreenWithCenter:)]) {
            [self.delegate airframe:self didOverScreenWithCenter:self.center];
        }
        self.moveEnable = NO;
        [self removeFromSuperview];
        return NO;
    }
    return YES;
}

@end
