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
NSString *const bossImageNameYUKARI = @"YAKUMO YUKARI"; // 八云 紫
NSString *const BossImageNameTenshi = @"Hinanawi Tenshi"; // 比那名居 天子
NSString *const BossImageNameKanako = @"Yasaka Kanako"; // 八坂 神奈子
NSString *const BossImageNameReimu = @"Hakurei Reimu"; // 博丽 灵梦

- (instancetype)initWithCenter:(CGPoint)center{
    self = [super initWithCenter:center
                            size:CGSizeMake(53, 88)
                 detectionRadius:airframeRadiusBoss
                 operationRadius:airframeRadiusBoss-10
                           image:[UIImage imageNamed:bossImageNameYUKARI]];
    return self;
}

@end
