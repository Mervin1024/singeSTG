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

- (instancetype)initWithCenter:(CGPoint)center size:(CGSize)size detectionRadius:(CGFloat)detectionRadius operationRadius:(CGFloat)operationRadius image:(UIImage *)image{
    CGRect frame = CGRectMake(center.x-size.width/2, center.y-size.height/2, size.width, size.height);
    self = [super initWithFrame:frame image:image];
    if (self) {
        _detectionRadius = detectionRadius;
        _operationRadius = operationRadius;
        self.determine = [[UIImageView alloc]initWithFrame:CGRectMake(size.width/2-operationRadius, size.height/2-operationRadius, operationRadius*2, operationRadius*2)];
        self.determine.image = [UIImage imageNamed:@"Determine"];
        [self addSubview:self.determine];
        self.determine.hidden = YES;
    }
    return self;
}

@end

