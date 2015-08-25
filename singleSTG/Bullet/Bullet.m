//
//  BulletShape.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Bullet.h"
#import "Airframe.h"

@interface Bullet ()

//*******碰撞检测**********
//------------------------
- (BOOL)isCollidedWithObj:(id)obj;
//------------------------
//******留给子类实现********

@end

@implementation Bullet
@synthesize moveEnable;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        moveEnable = NO;
    }
    return self;
}

- (BOOL)isCollidedWithObject:(id)object{
    if (!object) {
        return NO;
    }
    if ([self isCollidedWithObject:object collisionZone:self.collisionZone]) { // 潜在碰撞区
        if ([self isCollidedWithObj:object]) { // 两单位碰撞
            NSLog(@"碰撞");
            if ([self.delegate respondsToSelector:@selector(bullet:didCollidedWithObject:)]) {
                [self.delegate bullet:self didCollidedWithObject:object];
            }
            return YES;
        }
    }
    return NO;
}

- (BOOL)isOverScreen{
    if (self.center.x < -20 || self.center.x > [UIScreen mainScreen].bounds.size.width+20) {
        return YES;
    }
    if (self.center.y < -20 || self.center.y > [UIScreen mainScreen].bounds.size.height+20) {
        return YES;
    }
    return NO;
}

// 碰撞区检测
- (BOOL)isCollidedWithObject:(id)object collisionZone:(CGRect)collisionZone{
    CGFloat x = fabs(collisionZone.origin.x+collisionZone.size.width/2-[object center].x);
    CGFloat y = fabs(collisionZone.origin.y+collisionZone.size.height/2-[object center].y);
    if ([object isKindOfClass:[Airframe class]]) {
        if (x <= collisionZone.size.width/2+[object diameter]/2 &&
            y <= collisionZone.size.height/2+[object diameter]/2) {
            return YES;
        }
    }
    return NO;
}
// 碰撞检测
- (BOOL)isCollidedWithObj:(id)obj{
    /**
     
     子类需实现该方法
     
     */
    
    return NO;
}

// 转换坐标系
- (id)coordinateTransformationObject:(id)object{
    /**
     将object中心点坐标转化为"以bullet中心点为中心，以长轴为X轴，短轴为Y轴的坐标系"的坐标
     
     这样，检测碰撞只需计算转换后的点坐标与"坐标原点“的位置关系
     */
    double angle = [self forwardAngle];
    CGPoint transformate_1 = CGPointMake([object center].x-self.center.x,
                                         self.center.y-[object center].y);
    CGPoint transformate_2 = CGPointMake(sin(angle)*transformate_1.y+cos(angle)*transformate_1.x, cos(angle)*transformate_1.y-sin(angle)*transformate_1.x);
    if ([object isKindOfClass:[Airframe class]]) {
        return [[Airframe alloc]initWithCenter:transformate_2];
    }
    NSLog(@"Error Class:%@",NSStringFromClass([object class]));
    return nil;
}

- (void)moveWithAngle:(double)angle velocity:(CGFloat)velocity{
    if (!moveEnable) {
        moveEnable = YES;;
    }
    self.forwardAngle = angle;
    self.velocity = velocity;
    [self move];
}

- (void)move{
    if ([self isOverScreen]) {
        if ([self.delegate respondsToSelector:@selector(bullet:didOverScreenWithOrigin:)]) {
            [self.delegate bullet:self didOverScreenWithOrigin:self.center];
        }
        self.moveEnable = NO;
        [self removeFromSuperview];
    }
    if (!moveEnable) {
        return;
    }
    CGPoint center = self.center;
    center.x += cos(self.forwardAngle)*self.velocity;
    center.y += sin(self.forwardAngle)*self.velocity;
    [UIView animateWithDuration:0.01 animations:^{
        self.center = center;
    }completion:^(BOOL finished){
        [self moveWithAngle:self.forwardAngle velocity:self.velocity];
    }];
    
}

@end

@implementation BulletSmallJade
CGFloat smallJadeDiameter = 15;
@synthesize diameter;

- (instancetype)initWithCenter:(CGPoint)center{
    CGRect frame = CGRectMake(center.x-smallJadeDiameter/2, center.y-smallJadeDiameter/2, smallJadeDiameter, smallJadeDiameter);
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"SmallJade"]];
        diameter = smallJadeDiameter;
        self.collisionZone = frame;
    }
    return self;
}

+ (instancetype)smallJadeWithCenter:(CGPoint)center{
    return [[BulletSmallJade alloc]initWithCenter:center];
}

- (BOOL)isCollidedWithObj:(id)obj{
    CGFloat x = fabs([obj center].x - self.center.x);
    CGFloat y = fabs([obj center].y - self.center.y);
    CGFloat r = self.diameter/2+[obj diameter]/2;
    CGFloat d = powf(x, 2) + powf(y, 2);
    if (d <= powf(r, 2)) { // 两圆碰撞
        return YES;
    }
    return NO;
}

@end

@implementation BulletEllipse
CGFloat EllipseMajorAxis = 15;
CGFloat EllipseShortAxis = 10;
@synthesize majorAxis,shortAxis;

- (instancetype)initWithCenter:(CGPoint)center{
    CGRect frame = CGRectMake(center.x-EllipseMajorAxis/2, center.y-EllipseShortAxis/2, EllipseMajorAxis, EllipseShortAxis);
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"Ellipse"]];
        majorAxis = EllipseMajorAxis;
        shortAxis = EllipseShortAxis;
    }
    return self;
}

+ (instancetype)EllipseWithCenter:(CGPoint)center{
    return [[BulletEllipse alloc]initWithCenter:center];
}

- (void)setForwardAngle:(double)forwardAngle{
    self.forwardAngle = forwardAngle;
    self.transform = CGAffineTransformRotate(self.transform, forwardAngle);
}

- (CGRect)collisionZone{
    return CGRectMake(self.center.x-majorAxis/2, self.center.y-majorAxis/2, majorAxis, majorAxis);
}

- (BOOL)isCollidedWithObj:(id)obj{
    id object = [self coordinateTransformationObject:obj];
    CGFloat p = powf([object center].x, 2)/powf(self.majorAxis/2+[object diameter]/2, 2) + powf([object center].y, 2)/powf(self.shortAxis/2+[object diameter]/2, 2);
    if (p <= 1) {
        return YES;
    }
    return NO;
}

@end
