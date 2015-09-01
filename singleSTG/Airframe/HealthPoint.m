//
//  HealthPoint.m
//  singleSTG
//
//  Created by sh219 on 15/9/1.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "HealthPoint.h"

@implementation HealthPoint

- (instancetype)initWithFrame:(CGRect)frame degree:(double)degree{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _degree = degree;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self addBackColor];
}

- (void)addBackColor{
    if (_degree == 1) {
        _degree = 1-0.0001;
    }
    double angle = _degree*-2*M_PI;
    CGColorRef color = [UIColor orangeColor].CGColor;
    
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(contextRef, color);
    CGContextSetLineWidth(contextRef, 3.0);
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    CGContextAddArc(contextRef, center.x, center.y, self.frame.size.width/2-3, M_PI_2*3, M_PI_2*3+angle, 1);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

- (void)setDegree:(double)degree{
    _degree = degree;
    [self setNeedsDisplay];
}

@end
