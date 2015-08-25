//
//  BulletShape.h
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BulletShapeType) {
    // 小玉
    BulletShapeTypeSmallJade,
    
    // 椭弹
    BulletShapeTypeEllipse,
    
    // 大玉
    BulletShapeTypeLargeJade,
    
    // 中玉
    BulletShapeTypeMediumJade,
    
    // 米弹
    BulletShapeTypeRice,
    
    // 麟弹
    BulletShapeTypeFlake,
    
    // 刀弹
    BulletShapeTypeKnife,
    
    // 针弹
    BulletShapeTypeNeedle
    
};

@class Bullet;
@protocol BulletDelegate <NSObject>

- (void)bullet:(Bullet *)bullet didCollidedWithObject:(id)object; // 碰撞时方法回调
- (void)bullet:(Bullet *)bullet didOverScreenWithOrigin:(CGPoint)origin;

@end
//--------------------------

#pragma mark - Bullet
@interface Bullet : UIImageView

@property (assign, nonatomic) CGRect collisionZone;  // 碰撞检测区域
@property (assign, nonatomic) double forwardAngle;  // 单位：弧度
@property (assign, nonatomic) CGFloat velocity;
@property (assign, nonatomic) BOOL moveEnable;

//- (BOOL)isCollidedWithObject:(id)object; // 碰撞检测
- (void)moveWithAngle:(double)angle velocity:(CGFloat)velocity;

@property (weak, nonatomic) id <BulletDelegate> delegate;
@end
//---------------------------

#pragma mark - BulletSmallJade
@interface BulletSmallJade : Bullet

@property (assign, nonatomic) CGFloat diameter; // 圆的直径

- (instancetype)initWithCenter:(CGPoint)center;
+ (instancetype)smallJadeWithCenter:(CGPoint)center;

@end
//---------------------------

#pragma mark - BulletEllipse
@interface BulletEllipse : Bullet

@property (assign, nonatomic) CGFloat majorAxis; // 长轴 2a
@property (assign, nonatomic) CGFloat shortAxis; // 短轴 2b

- (instancetype)initWithCenter:(CGPoint)center;
+ (instancetype)EllipseWithCenter:(CGPoint)center;

@end
