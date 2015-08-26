//
//  TouchView.m
//  singleSTG
//
//  Created by 马遥 on 15/8/11.
//  Copyright (c) 2015年 Mervin. All rights reserved.
//

#import "TouchView.h"

@interface TouchView(){
    CGPoint pointTouchesBegan;
}

@end

@implementation TouchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(touchView:touchesBegan:withEvent:)]) {
        [self.delegate touchView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self];
//    if ([self.delegate respondsToSelector:@selector(touchView:movePoint:)]) {
//        CGPoint point = CGPointMake(touchPoint.x-pointTouchesBegan.x, touchPoint.y-pointTouchesBegan.y);
//        pointTouchesBegan = touchPoint;
//        [self.delegate touchView:self movePoint:point];
//    }
    if ([self.delegate respondsToSelector:@selector(touchView:touchesMoved:withEvent:)]) {
        [self.delegate touchView:self touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
//    pointTouchesBegan = CGPointMake(0, 0);
    if ([self.delegate respondsToSelector:@selector(touchView:touchesEnded:withEvent:)]) {
        [self.delegate touchView:self touchesEnded:touches withEvent:event];
    }
}

@end
