//
//  SportsSpirit.m
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "SportsSpirit.h"

@interface SportsSpirit (){
    UIImageView *imageView;
}

- (BOOL)continueMove;


@end

@implementation SportsSpirit

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imageView setImage:image];
        _moveEnable = YES;
        _forwardAngle = 0;
        _velocity = 0;
        [self addSubview:imageView];
        _image = image;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    super.frame = frame;
    frame.origin = CGPointMake(0, 0);
    imageView.frame = frame;
}

- (void)setImage:(UIImage *)image{
    imageView.image = image;
}

- (void)moveWithAngle:(double)angle velocity:(CGFloat)velocity{
    self.forwardAngle = angle;
    self.velocity = velocity;
//    if (velocity == 0) {
//        return;
//    }
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
    center.x += cos(self.forwardAngle)*self.velocity/10;
    center.y += sin(self.forwardAngle)*self.velocity/10;
    [UIView animateWithDuration:0.01 animations:^{
        self.center = center;
    }completion:^(BOOL finished){
        if (finished) {
            [self move];
        }
    }];
    
}

- (BOOL)continueMove{
    return YES;
}

@end
