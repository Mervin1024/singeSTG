//
//  Barrage.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Barrage.h"
#import "ViewController.h"

@interface Barrage (){
    UIViewController* superViewController;
}
@end

@implementation Barrage
@synthesize started;
double count = 0;
double a = 0;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _allBullets = [NSMutableArray array];
        started = NO;
    }
    return self;
}

- (instancetype)initWithSuperViewController:(UIViewController *)viewController{
    self = [self initWithFrame:viewController.view.frame];
    superViewController = viewController;
    return self;
}

- (void)addBullets{
    if (!started) {
        return;
    }
    Bullet *bullet = [Bullet bulletWithCenter:self.center bulletSource:BulletSourceEnemy bulletShapeType:BulletShapeTypeSmallJade];
    bullet.delegate = (id)superViewController;
    [self addSubview:bullet];
    [self.allBullets addObject:bullet];
    [self shootBullet:bullet];
    
}

- (void)shootBullet:(Bullet *)bullet{
    double angle = M_PI_4 + count;
    if (count <= M_PI/24) {
        a = M_PI/24;
    }else if (count >= M_PI/2.2){
        a = - M_PI/24;
    }
    count += a;
    CGFloat velocity = 1.5;
    [bullet moveWithAngle:angle velocity:velocity];
    [self performSelector:@selector(addBullets) withObject:nil afterDelay:0.1];
}

- (void)start{
    started = YES;
    [self addBullets];
}

- (void)stop{
    started = NO;
}

@end
