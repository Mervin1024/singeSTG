//
//  Player.h
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Airframe.h"
#import "Bullet.h"

@interface Player : Airframe

- (instancetype)initWithCenter:(CGPoint)center superView:(UIView *)superView;
+ (instancetype)playerWithCenter:(CGPoint)center superView:(UIView *)superView;

- (void)startShoot;
- (void)stopShoot;

@end
