//
//  Boss.m
//  singleSTG
//
//  Created by sh219 on 15/8/28.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Boss.h"
#import "HealthPoint.h"

@interface Boss () {
    HealthPoint *HPView;
}

@end

@implementation Boss
CGFloat const airframeRadiusBoss = 35;
CGFloat const bossWidth = 53;
CGFloat const bossHight = 88;
CGFloat const healthPointRadius = 55;
NSString *const bossImageNameYUKARI = @"YAKUMO YUKARI"; // 八云 紫
NSString *const BossImageNameTenshi = @"Hinanawi Tenshi"; // 比那名居 天子
NSString *const BossImageNameKanako = @"Yasaka Kanako"; // 八坂 神奈子
NSString *const BossImageNameReimu = @"Hakurei Reimu"; // 博丽 灵梦

- (instancetype)initWithCenter:(CGPoint)center{
    self = [super initWithCenter:center
                            size:CGSizeMake(bossWidth, bossHight)
                 detectionRadius:airframeRadiusBoss
                 operationRadius:airframeRadiusBoss-10
                           image:[UIImage imageNamed:BossImageNameReimu]];
    if (self) {
        self.healthPoint = 1.0;
        HPView = [[HealthPoint alloc]initWithFrame:CGRectMake(bossWidth/2-healthPointRadius, bossHight/2-healthPointRadius, healthPointRadius*2, healthPointRadius*2) degree:1.0];
        [self addSubview:HPView];
    }
    return self;
}

- (void)setHealthPoint:(double)healthPoint{
    super.healthPoint = healthPoint;
    HPView.degree = healthPoint;
}

@end


