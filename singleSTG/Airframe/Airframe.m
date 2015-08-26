//
//  airframe.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Airframe.h"

@interface Airframe ()

@end

@implementation Airframe

CGFloat airframeRadiusWildfire = 10;
CGFloat airframeRadiusYousei = 15;
CGFloat airframeRadiusButterfly = 20;

- (instancetype)initWithCenter:(CGPoint)center detectionRadius:(CGFloat)detectionRadius operationRadius:(CGFloat)operationRadius image:(UIImage *)image{
    CGRect frame = CGRectMake(center.x-operationRadius, center.y-operationRadius, operationRadius*2, operationRadius*2);
    self = [super initWithFrame:frame image:image];
    if (self) {
        _detectionRadius = detectionRadius;
        _operationRadius = operationRadius;
    }
    return self;
}

@end

