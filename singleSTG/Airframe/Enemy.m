//
//  Enemy.m
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Enemy.h"
#import "Math.h"

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

- (BOOL)isCollidedWithObject:(Airframe *)obj{
    if (!obj) {
        return NO;
    }
    CGFloat distance = [Math distanceOfPiont:self.center otherPoint:obj.center];
    if (distance <= self.operationRadius+obj.operationRadius) {
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
    
    if ([self.delegate respondsToSelector:@selector(objectWillCollidedWithAirframe:)]) {
        Airframe *obj = [self.delegate objectWillCollidedWithAirframe:self];
        if ([self isCollidedWithObject:obj]) {
            if ([self.delegate respondsToSelector:@selector(airframe:didCollidedWithAirframe:)]) {
                [self.delegate airframe:self didCollidedWithAirframe:obj];
            }
//            return NO;
        }
    }
    return YES;
}

@end
