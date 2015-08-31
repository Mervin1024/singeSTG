//
//  Boss.m
//  singleSTG
//
//  Created by sh219 on 15/8/28.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Boss.h"

@implementation Boss
CGFloat const airframeRadiusBoss = 35;
NSString *const airframeBossImageName = @"GreenBall";


- (instancetype)initWithCenter:(CGPoint)center{
    self = [super initWithCenter:center
                            size:CGSizeMake(70, 70)
                 detectionRadius:airframeRadiusBoss
                 operationRadius:airframeRadiusBoss-10
                           image:[UIImage imageNamed:airframeBossImageName]];
    return self;
}

@end
