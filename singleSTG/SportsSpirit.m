//
//  SportsSpirit.m
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "SportsSpirit.h"

@interface SportsSpirit ()

- (BOOL)continueMove;

@end

@implementation SportsSpirit

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:image];
        _moveEnable = YES;
        _forwardAngle = 0;
        _velocity = 0;
    }
    return self;
}

- (void)setForwardAngle:(double)forwardAngle{
    double difference = forwardAngle - _forwardAngle;
    _forwardAngle = forwardAngle;
    self.transform = CGAffineTransformRotate(self.transform, difference);
}

- (void)moveWithAngle:(double)angle velocity:(CGFloat)velocity{
    self.forwardAngle = angle;
    self.velocity = velocity;
    [self move];
}

- (void)move{
    if (!self.moveEnable) {
        return;
    }
    if (![self continueMove]) {
        return;
    }
    CGPoint center = self.center;
    center.x += cos(self.forwardAngle)*self.velocity;
    center.y += sin(self.forwardAngle)*self.velocity;
    [UIView animateWithDuration:0.01 animations:^{
        self.center = center;
    }completion:^(BOOL finished){
        [self moveWithAngle:self.forwardAngle velocity:self.velocity];
    }];
    
}

- (BOOL)continueMove{
    return YES;
}

@end
