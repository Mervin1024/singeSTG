//
//  Enemy.h
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Airframe.h"

@interface Enemy : Airframe

@end

@interface Enemy (Boss)

- (instancetype)initBossWithCenter:(CGPoint)center;

@end