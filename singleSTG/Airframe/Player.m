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
    CGPoint pointDidMoved;
    CGPoint pointChanged;
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
        pointDidMoved = self.center;
    }
    return self;
}

+ (instancetype)playerWithCenter:(CGPoint)center superView:(UIView *)superView{
    return [[Player alloc]initWithCenter:center superView:superView];
}

- (void)startShoot{
    pointChanged = CGPointMake(0, 0);
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
        [bullet moveWithAngle:M_PI_2*3 velocity:10];
    }
    [self performSelector:@selector(addBullets) withObject:nil afterDelay:0.1];
}
double timestamp = 0;
CGPoint touchP;
double differenceOfTime;
CGFloat velocity;
- (void)touchView:(TouchView *)view touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    timestamp = event.timestamp;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchP = touchPoint;
}

- (void)touchView:(TouchView *)view touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    differenceOfTime = event.timestamp - timestamp;
    timestamp = event.timestamp;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    pointChanged = CGPointMake(touchPoint.x-touchP.x, touchPoint.y-touchP.y);
    pointDidMoved = CGPointMake(pointDidMoved.x+pointChanged.x, pointDidMoved.y+pointChanged.y);
    velocity = [self distanceOfPoint:touchPoint anotherPoint:touchP]/differenceOfTime/10;
    
    
    touchP = touchPoint;
    [self movePlayer];
//    self.center = CGPointMake(self.center.x+pointChanged.x, self.center.y+pointChanged.y);
}

- (CGFloat)distanceOfPoint:(CGPoint)point_1 anotherPoint:(CGPoint)point_2{
    return sqrtf(powf(point_1.x-point_2.x, 2) + powf(point_1.y-point_2.y, 2));
}

- (void)movePlayer{
    if (velocity > 2) {
        velocity = 2;
    }
//    NSLog(@"%@",NSStringFromCGPoint(pointDidMoved));
    double a = pointDidMoved.x-self.center.x;
    double b = pointDidMoved.y-self.center.y;
    NSLog(@"a:%f",a);
    NSLog(@"b:%f",b);
    double angle;
    if (b == 0) {
        angle = 0;
    }else if (a == 0){
        if (b > 0) {
            angle = M_PI_2;
        }else{
            angle = M_PI_2*3;
        }
    }else{
        #error double-nan
        angle = asin(b/a);
    }
    NSLog(@"angle:%f",angle);
    
    if (self.velocity == 0) {
        [self moveWithAngle:angle velocity:velocity];
//        [self moveWithAngle:M_PI_2 velocity:10];
    }else{
        self.velocity = velocity;
        self.forwardAngle = angle;
    }
    
}

- (BOOL)continueMove{
//    if ([self distanceOfPoint:pointDidMoved anotherPoint:self.center] <= airframePlayerRadius) {
//        self.forwardAngle = 0;
//        self.velocity = 0;
//        return NO;
//    }
//    NSLog(@"%@",NSStringFromCGPoint(self.center));
    return YES;
}

@end
