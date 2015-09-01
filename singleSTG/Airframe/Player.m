//
//  Player.m
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Player.h"
#import "OperationView.h"

@interface Player () <TouchViewDelegate>{
    
    id superController;
    InclinedDirection inclinedDirection;
}

@end

@implementation Player
@synthesize touchView;
CGFloat const airframePlayerRadius = 5.0;
double const inclinedAngle = M_PI/16;
NSString *const airframePlayerImageName = @"Kijin Seija"; // 鬼人 正邪

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
//        self.determine.hidden = NO;
        self.slow = NO;
        _shooting = NO;
        inclinedDirection = InclinedDirectionNormal;
    }
    return self;
}

+ (instancetype)playerWithCenter:(CGPoint)center superViewController:(UIViewController *)superViewController{
    return [[Player alloc]initWithCenter:center superViewController:superViewController];
}

- (void)setInclinedDirection:(InclinedDirection)inclined{
    switch (inclined) {
        case InclinedDirectionLeft:{
            if (inclinedDirection == InclinedDirectionNormal) {
                self.transform = CGAffineTransformRotate(self.transform, -inclinedAngle);
            }else if (inclinedDirection == InclinedDirectionRight){
                self.transform = CGAffineTransformRotate(self.transform, -inclinedAngle*2);
            }else{
                return;
            }
            inclinedDirection = InclinedDirectionLeft;
            break;
        }
        case InclinedDirectionRight:{
            if (inclinedDirection == InclinedDirectionNormal) {
                self.transform = CGAffineTransformRotate(self.transform, inclinedAngle);
            }else if (inclinedDirection == InclinedDirectionLeft){
                self.transform = CGAffineTransformRotate(self.transform, inclinedAngle*2);
            }else{
                return;
            }
            inclinedDirection = InclinedDirectionRight;
            break;
        }
        case InclinedDirectionNormal:{
            if (inclinedDirection == InclinedDirectionLeft) {
                self.transform = CGAffineTransformRotate(self.transform, inclinedAngle);
            }else if (inclinedDirection == InclinedDirectionRight){
                self.transform = CGAffineTransformRotate(self.transform, -inclinedAngle);
            }else{
                return;
            }
            inclinedDirection = InclinedDirectionNormal;
            break;
        }
    }
}

- (void)setForwardAngle:(double)forwardAngle{
    super.forwardAngle = forwardAngle;
    if (fabs(forwardAngle) == 0) {
        [self setInclinedDirection:InclinedDirectionNormal];
    }else if (fabs(forwardAngle) < M_PI/12*3){
        [self setInclinedDirection:InclinedDirectionRight];
    }else if (fabs(forwardAngle) > M_PI/12*9){
        [self setInclinedDirection:InclinedDirectionLeft];
    }else{
        [self setInclinedDirection:InclinedDirectionNormal];
    }
    
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

- (void)move{
    if (!self.moveEnable) {
        return;
    }
//    if (![self continueMove]) {
//        return;
//    }
    CGPoint center = self.center;
    CGFloat x = center.x + cos(self.forwardAngle)*self.velocity/10;
    if (x > self.frame.size.width/2 &&
        x < SCREEN_SIZE.width - self.frame.size.width/2) {
        center.x = x;
    }
    CGFloat y = center.y + sin(self.forwardAngle)*self.velocity/10;
    if (y > self.frame.size.height/2 &&
        y < SCREEN_SIZE.height - OPERATION_VIEW_HIGHT - self.frame.size.height/2) {
        center.y = y;
    }
    [UIView animateWithDuration:0.01 animations:^{
        self.center = center;
    }completion:^(BOOL finished){
        if (finished) {
            [self move];
        }
    }];
    
}

@end
