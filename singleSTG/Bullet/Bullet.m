//
//  BulletShape.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Bullet.h"
#import "Airframe.h"

@interface Bullet (){

}

@end

@implementation Bullet
#pragma mark - Bullet init

- (instancetype)initWithCenter:(CGPoint)center bulletSource:(BulletSource)bulletSource bulletShapeType:(BulletShapeType)bulletShapeType{
    CGRect frame;
    UIImage *image;
    switch (bulletShapeType) {
        case BulletShapeTypeSmallJade:{
            BulletSmallJade *bulletShape = [[BulletSmallJade alloc]init];
            CGFloat diameter = bulletShape.diameter;
            frame = CGRectMake(center.x-diameter/2, center.y-diameter/2, diameter, diameter);
            image = bulletShape.bulletImage;
            break;
        }
        case BulletShapeTypeEllipse:{
            BulletEllipse *bulletShape = [[BulletEllipse alloc]init];
            CGFloat majorAxis = bulletShape.majorAxis;
            CGFloat shortAxis = bulletShape.shortAxis;
            frame = CGRectMake(center.x-majorAxis/2, center.y-shortAxis/2, majorAxis, shortAxis);
            image = bulletShape.bulletImage;
            break;
        }
        default:
            break;
    }
    self = [super initWithFrame:frame image:image];
    if (self) {
        _bulletShapeType = bulletShapeType;
        _bulletSource = bulletSource;
    }
    return self;
}

+ (instancetype)bulletWithCenter:(CGPoint)center bulletSource:(BulletSource)bulletSource bulletShapeType:(BulletShapeType)bulletShapeType{
    return [[Bullet alloc]initWithCenter:center bulletSource:bulletSource bulletShapeType:bulletShapeType];
}

- (CGRect)collisionZone{
    CGRect zone;
    switch (self.bulletShapeType) {
        case BulletShapeTypeSmallJade:
            zone = self.frame;
            break;
        case BulletShapeTypeEllipse:{
            BulletEllipse *bulletShape = [[BulletEllipse alloc]init];
            CGFloat majorAxis = bulletShape.majorAxis;
            zone = CGRectMake(self.center.x-majorAxis/2, self.center.y-majorAxis/2, majorAxis, majorAxis);
            break;
        }
        default:
            break;
    }
    return zone;
}

#pragma mark - Bullet Methods

- (BOOL)isCollidedWithObject:(Airframe *)object{
    if (!object) {
        return NO;
    }
    // 潜在碰撞区
    if ([self isCollidedWithObject:object collisionZone:self.collisionZone]) {
        if ([self isCollidedWithObj:object]) { // 两单位碰撞
            NSLog(@"碰撞");
            if ([self.delegate respondsToSelector:@selector(bullet:didCollidedWithAirframe:)]) {
                [self.delegate bullet:self didCollidedWithAirframe:object];
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
- (BOOL)isCollidedWithObject:(Airframe *)object collisionZone:(CGRect)collisionZone{
    CGFloat x = fabs(collisionZone.origin.x+collisionZone.size.width/2-[object center].x);
    CGFloat y = fabs(collisionZone.origin.y+collisionZone.size.height/2-[object center].y);
    if (x <= collisionZone.size.width/2+object.detectionRadius &&
        y <= collisionZone.size.height/2+object.detectionRadius) {
        return YES;
    }
    return NO;
}
// 碰撞检测
- (BOOL)isCollidedWithObj:(Airframe *)obj{
    // 圆与圆
    if (self.bulletShapeType == BulletShapeTypeSmallJade) {
        BulletSmallJade *bulletShape = [[BulletSmallJade alloc]init];
        CGFloat x = fabs([obj center].x - self.center.x);
        CGFloat y = fabs([obj center].y - self.center.y);
        CGFloat r = bulletShape.diameter/2+obj.detectionRadius;
        CGFloat d = powf(x, 2) + powf(y, 2);
        if (d <= powf(r, 2)) { // 两圆碰撞
            return YES;
        }
        return NO;
    // 圆与椭圆
    }else if (self.bulletShapeType == BulletShapeTypeEllipse){
        BulletEllipse *bulletShape = [[BulletEllipse alloc]init];
        CGPoint transformateCenter = [self coordinateTransformationCenter:obj.center];
        CGFloat p = powf(transformateCenter.x, 2)/powf(bulletShape.majorAxis/2+obj.detectionRadius/2, 2) + powf(transformateCenter.y, 2)/powf(bulletShape.shortAxis/2+obj.detectionRadius/2, 2);
        if (p <= 1) {
            return YES;
        }
        return NO;
    }
    return NO;
}

// 转换坐标系
- (CGPoint)coordinateTransformationCenter:(CGPoint)center{
    /**
     将object中心点坐标转化为"以bullet中心点为中心，以长轴为X轴，短轴为Y轴的坐标系"的坐标
     
     这样，检测碰撞只需计算转换后的点坐标与"坐标原点“的位置关系
     */
    double angle = [self forwardAngle];
    CGPoint transformate_1 = CGPointMake(center.x-self.center.x,
                                         self.center.y-center.y);
    CGPoint transformate_2 = CGPointMake(sin(angle)*transformate_1.y+cos(angle)*transformate_1.x, cos(angle)*transformate_1.y-sin(angle)*transformate_1.x);
    return transformate_2;
}

#pragma mark - Bullet Move Method

- (BOOL)continueMove{
    // 跃出屏幕，释放
    if ([self isOverScreen]) {
        if ([self.delegate respondsToSelector:@selector(bullet:didOverScreenWithCenter:)]) {
            [self.delegate bullet:self didOverScreenWithCenter:self.center];
        }
        self.moveEnable = NO;
        [self removeFromSuperview];
        return NO;
    }
    // 碰撞检测
    Airframe *object;
    if ([self.delegate respondsToSelector:@selector(objectWillCollidedWithBullet:)]) {
        object = [self.delegate objectWillCollidedWithBullet:self];
    }
    if ([self isCollidedWithObject:object]) {
        self.moveEnable = NO;
        [self removeFromSuperview];
        return NO;
    }
    return YES;
}

@end

#pragma mark - BulletSmallJade

@implementation BulletSmallJade
CGFloat const smallJadeDiameter = 15;
NSString *const smallJadeImage = @"SmallJade";

- (instancetype)init{
    self = [super init];
    if (self) {
        _diameter = smallJadeDiameter;
        _bulletImage = [UIImage imageNamed:smallJadeImage];
    }
    return self;
}

@end

#pragma mark - BulletEllipse

@implementation BulletEllipse
CGFloat const EllipseMajorAxis = 15;
CGFloat const EllipseShortAxis = 10;
NSString *const EllipseImage = @"Ellipse";

- (instancetype)init{
    self = [super init];
    if (self) {
        _majorAxis = EllipseMajorAxis;
        _shortAxis = EllipseShortAxis;
        _bulletImage = [UIImage imageNamed:EllipseImage];
    }
    return self;
}

@end
