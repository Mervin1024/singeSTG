//
//  Player.m
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Player.h"
#import "TouchView.h"

@interface Player () <TouchViewDelegate>{
    BOOL start;
    TouchView *touchView;
}

@end

@implementation Player
CGFloat const airframePlayerRadius = 7.5;
//NSString *const airframePlayerImageName = @"Player";
NSString *const airframePlayerImageName = @"SmallJade";

- (instancetype)initWithCenter:(CGPoint)center superView:(UIView *)superView{
    self = [super initWithCenter:center
                detectionRadius:airframePlayerRadius
                operationRadius:airframePlayerRadius
                          image:[UIImage imageNamed:airframePlayerImageName]];
    if (self) {
        touchView = [[TouchView alloc]initWithFrame:superView.frame];
        touchView.delegate = self;
        [superView addSubview:touchView];
//        self.moveEnable = NO;
    }
    return self;
}

+ (instancetype)playerWithCenter:(CGPoint)center superView:(UIView *)superView{
    return [[Player alloc]initWithCenter:center superView:superView];
}

- (void)startShoot{
    self.moveEnable = YES;
    start = YES;
    [self addBullets];
}

- (void)stopShoot{
    self.moveEnable = NO;
    start = NO;
}

- (void)addBullets{
    if (!start) {
        return;
    }
    for (int i = 0; i < 3; i++) {
        CGPoint center = CGPointMake(airframePlayerRadius*2/2*(i-1)+self.center.x, self.center.y-airframePlayerRadius);
        Bullet *bullet = [Bullet bulletWithCenter:center bulletSource:BulletSourceFirendly bulletShapeType:BulletShapeTypeSmallJade];
        [touchView addSubview:bullet];
        [bullet moveWithAngle:M_PI_2*3 velocity:100];
    }
    [self performSelector:@selector(addBullets) withObject:nil afterDelay:0.1];
}


@end
