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

@property (assign, nonatomic, readonly) BOOL shooting;
@property (assign, nonatomic) BOOL slow;

- (instancetype)initWithCenter:(CGPoint)center superViewController:(UIViewController *)superViewController;
+ (instancetype)playerWithCenter:(CGPoint)center superViewController:(UIViewController *)superViewController;

- (void)startShoot;
- (void)stopShoot;

@end
