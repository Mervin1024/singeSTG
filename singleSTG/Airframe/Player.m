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
    TouchView *touchView;
    id superController;
}

@end

@implementation Player
CGFloat const airframePlayerRadius = 6.0;
//NSString *const airframePlayerImageName = @"Player";
NSString *const airframePlayerImageName = @"Hakurei Reimu";

- (instancetype)initWithCenter:(CGPoint)center superViewController:(UIViewController *)superViewController{
    self = [super initWithCenter:center
                            size:CGSizeMake(23, 41)
                detectionRadius:airframePlayerRadius
                operationRadius:airframePlayerRadius
                          image:[UIImage imageNamed:airframePlayerImageName]];
    if (self) {
        superController = superViewController;
        touchView = [[TouchView alloc]initWithFrame:superViewController.view.frame];
//        touchView.delegate = self;
        [superViewController.view addSubview:touchView];
        self.moveEnable = NO;
        self.determine.hidden = NO;
        _slow = NO;
        _shooting = NO;
    }
    return self;
}

+ (instancetype)playerWithCenter:(CGPoint)center superViewController:(UIViewController *)superViewController{
    return [[Player alloc]initWithCenter:center superViewController:superViewController];
}

- (void)setSlow:(BOOL)slow{
    _slow = slow;
    self.determine.hidden = !slow;
}

- (void)startShoot{
    self.moveEnable = YES;
    _shooting = YES;
    [self addBullets];
}

- (void)stopShoot{
    self.moveEnable = NO;
    _shooting = NO;
}

- (void)addBullets{
    if (!self.shooting) {
        return;
    }
    NSInteger count = 5;
    for (int i = 0; i < count; i++) {
        CGPoint center = CGPointMake(self.frame.size.width/(count-1)*i+self.frame.origin.x, self.frame.origin.y);
        Bullet *bullet = [Bullet bulletWithCenter:center bulletSource:BulletSourceFirendly bulletShapeType:BulletShapeTypeKIJINSEIJA];
        [touchView addSubview:bullet];
        bullet.delegate = superController;
        double angle = M_PI/48;
        CGFloat j = i - (count-1)/2.0;
        [bullet moveWithAngle:M_PI_2*3 + angle*j velocity:100];
    }
    [self performSelector:@selector(addBullets) withObject:nil afterDelay:0.1];
}


@end
