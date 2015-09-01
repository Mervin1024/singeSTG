//
//  BulletShape.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Bullet.h"
#import "Airframe.h"
#import "Math.h"

@interface Bullet (){
    BulletSmallJade *smallJadeBullet;
    BulletEllipse *ellipseBullet;
    BulletKIJINSEIJA *KIJINSEIJABullet;
    
    CGFloat moveVelocity;
}

@end

@implementation Bullet
#pragma mark - Bullet init

- (instancetype)initWithCenter:(CGPoint)center bulletSource:(BulletSource)bulletSource bulletShapeType:(BulletShapeType)bulletShapeType{
    CGRect frame;
    UIImage *image;
    switch (bulletShapeType) {
        case BulletShapeTypeSmallJade:{
            smallJadeBullet = [[BulletSmallJade alloc]init];
            CGFloat diameter = smallJadeBullet.diameter+4;
            frame = CGRectMake(center.x-diameter/2, center.y-diameter/2, diameter, diameter);
            image = smallJadeBullet.bulletImage;
            break;
        }
        case BulletShapeTypeEllipse:{
            ellipseBullet = [[BulletEllipse alloc]initWithBulletEllipseColor:BulletEllipseColorGreen];
            CGFloat majorAxis = ellipseBullet.majorAxis+4;
            CGFloat shortAxis = ellipseBullet.shortAxis+4;
            frame = CGRectMake(center.x-majorAxis/2, center.y-shortAxis/2, majorAxis, shortAxis);
            image = ellipseBullet.bulletImage;
            break;
        }
        case BulletShapeTypeKIJINSEIJA:{
            KIJINSEIJABullet = [[BulletKIJINSEIJA alloc]initWithBulletKIJINSEIJAType:BulletKIJINSEIJATypeMini];
            CGFloat horizontalSide = KIJINSEIJABullet.horizontalSide+4;
            CGFloat verticalSide = KIJINSEIJABullet.verticalSide+4;
            frame = CGRectMake(center.x-horizontalSide/2, center.y-verticalSide/2, horizontalSide, verticalSide);
            image = KIJINSEIJABullet.bulletImage;
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

- (void)setForwardAngle:(double)forwardAngle{
    double difference = forwardAngle - super.forwardAngle;
    super.forwardAngle = forwardAngle;
    self.transform = CGAffineTransformRotate(self.transform, difference);
}

- (CGRect)collisionZone{
    CGRect zone;
    switch (self.bulletShapeType) {
        case BulletShapeTypeSmallJade:
            zone = self.frame;
            break;
        case BulletShapeTypeEllipse:{
            CGFloat majorAxis = ellipseBullet.majorAxis;
            zone = CGRectMake(self.center.x-majorAxis/2, self.center.y-majorAxis/2, majorAxis, majorAxis);
            break;
        }
        case BulletShapeTypeKIJINSEIJA:
            zone = self.frame;
            break;
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
        CGFloat r = smallJadeBullet.diameter/2+obj.detectionRadius;
        CGFloat d = [Math distanceOfPiont:obj.center otherPoint:self.center];
        if (d <= r) { // 两圆碰撞
            return YES;
        }
        return NO;
    // 圆与椭圆
    }else if (self.bulletShapeType == BulletShapeTypeEllipse){
        CGPoint transformateCenter = [self coordinateTransformationCenter:obj.center];
        CGFloat p = powf(transformateCenter.x, 2)/powf(ellipseBullet.majorAxis/2+obj.detectionRadius/2, 2) + powf(transformateCenter.y, 2)/powf(ellipseBullet.shortAxis/2+obj.detectionRadius/2, 2);
        if (p <= 1) {
            return YES;
        }
        return NO;
    // 圆与矩形
    }else if (self.bulletShapeType == BulletShapeTypeKIJINSEIJA){
        CGPoint transformateCenter = [self coordinateTransformationCenter:obj.center];
        CGFloat x = fabs(transformateCenter.x);
        CGFloat y = fabs(transformateCenter.y);
        if (x > KIJINSEIJABullet.horizontalSide/2+obj.detectionRadius ||
            y > KIJINSEIJABullet.verticalSide/2+obj.detectionRadius) {
            return NO;
        }
        double distance = sqrt(pow(x-KIJINSEIJABullet.horizontalSide/2, 2)+pow(y-KIJINSEIJABullet.verticalSide/2, 2));
        if (distance > obj.detectionRadius) {
            return NO;
        }
        return YES;
    }
    return NO;
}

// 转换坐标系
- (CGPoint)coordinateTransformationCenter:(CGPoint)center{
    /**
     将原坐标系坐标center转化为"以bullet中心点为中心，以长轴为X轴，短轴为Y轴的坐标系"的坐标
     
     这样，检测碰撞只需计算转换后的点坐标与"坐标原点“的位置关系
     */
    double angle = [self forwardAngle];
    CGPoint transformate_1 = CGPointMake(center.x-self.center.x,
                                         self.center.y-center.y);
    CGPoint transformate_2 = CGPointMake(sin(angle)*transformate_1.y+cos(angle)*transformate_1.x, cos(angle)*transformate_1.y-sin(angle)*transformate_1.x);
    return transformate_2;
}

#pragma mark - Bullet Move Method

- (void)move{
    if ([self.delegate respondsToSelector:@selector(moveState)]) {
        self.moveEnable = [self.delegate moveState];
    }
    moveVelocity = self.velocity;
    if (!self.moveEnable) {
        moveVelocity = 0;
    }
    if (![self continueMove]) {
        return;
    }
    CGPoint center = self.center;
    center.x += cos(self.forwardAngle)*moveVelocity/10;
    center.y += sin(self.forwardAngle)*moveVelocity/10;
    if (self.bulletShapeType != BulletShapeTypeKIJINSEIJA) {
        [UIView animateWithDuration:0.01 animations:^{
            self.center = center;
        }completion:^(BOOL finished){
            if (finished) {
                [self move];
            }
        }];
        
    }else{
        BulletKIJINSEIJA *bullet = KIJINSEIJABullet;
        if (KIJINSEIJABullet.times == 5) {
            bullet = [[BulletKIJINSEIJA alloc]initWithBulletKIJINSEIJAType:BulletKIJINSEIJATypeNormal];
        }else if (KIJINSEIJABullet.times == 15){
            bullet = [[BulletKIJINSEIJA alloc]initWithBulletKIJINSEIJAType:BulletKIJINSEIJATypeLarge];
        }
        CGRect frame = CGRectMake(center.x-(bullet.horizontalSide+4)/2, center.y-(bullet.verticalSide+4)/2, bullet.horizontalSide+4, bullet.verticalSide+4);
        UIImage *image = bullet.bulletImage;
        
        [UIView animateWithDuration:0.01 animations:^{
            if (KIJINSEIJABullet.times == 5 || KIJINSEIJABullet.times == 15) {
                double angle = self.forwardAngle;
                self.forwardAngle = 0;
                self.frame = frame;
                self.forwardAngle = angle;
                self.image = image;
            }
            self.center = center;
            KIJINSEIJABullet.times++;
        }completion:^(BOOL finished){
            if (finished) {
                [self move];
            }
        }];
    }
}

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
    if ([self.delegate respondsToSelector:@selector(objectWillCollidedWithBullet:)]) {
        Airframe *object = [self.delegate objectWillCollidedWithBullet:self];
        if ([self isCollidedWithObject:object]) {
            self.moveEnable = NO;
            [self removeFromSuperview];
            return NO;
        }
    }
    
    return YES;
}

@end

#pragma mark - BulletSmallJade

@implementation BulletSmallJade
CGFloat const smallJadeDiameter = 12.5;
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
CGFloat const EllipseMajorAxis = 11.5;
CGFloat const EllipseShortAxis = 6.5;
NSString *const EllipseImageBlue = @"Ellipse_Blue";
NSString *const EllipseImageGreen = @"Ellipse_Green";

- (instancetype)initWithBulletEllipseColor:(BulletEllipseColor)ellipseColor{
    self = [super init];
    if (self) {
        _majorAxis = EllipseMajorAxis;
        _shortAxis = EllipseShortAxis;
        _bulletEllipseColor = ellipseColor;
        switch (ellipseColor) {
            case BulletEllipseColorBlue:
                _bulletImage = [UIImage imageNamed:EllipseImageBlue];
                break;
            case BulletEllipseColorGreen:
                _bulletImage = [UIImage imageNamed:EllipseImageGreen];
                break;
        }
        
    }
    return self;
}

@end

#pragma mark - BulletKIJINSEIJA

@implementation BulletKIJINSEIJA
CGFloat const vertical = 8;
CGFloat const miniHorizontal = 14;
CGFloat const normalHorizontal = 28;
CGFloat const largeHorizontal = 31;
NSString *const KIJINSEIJAMiniImage = @"KIJINSEIJATypeMini";
NSString *const KIJINSEIJANormalImage = @"KIJINSEIJATypeNormal";
NSString *const KIJINSEIJALargeImage = @"KIJINSEIJATypeLarge";

- (instancetype)initWithBulletKIJINSEIJAType:(BulletKIJINSEIJAType)KIJINSEIJAType{
    self = [super init];
    if (self) {
        _bulletKIJINSEIJAType = KIJINSEIJAType;
        _verticalSide = vertical;
        switch (_bulletKIJINSEIJAType) {
            case BulletKIJINSEIJATypeMini:
                _horizontalSide = miniHorizontal;
                _bulletImage = [UIImage imageNamed:KIJINSEIJAMiniImage];
                break;
            case BulletKIJINSEIJATypeNormal:
                _horizontalSide = normalHorizontal;
                _bulletImage = [UIImage imageNamed:KIJINSEIJANormalImage];
                break;
            case BulletKIJINSEIJATypeLarge:
                _horizontalSide = largeHorizontal;
                _bulletImage = [UIImage imageNamed:KIJINSEIJALargeImage];
                break;
        }
        _times = 0;
    }
    return self;
}

@end
