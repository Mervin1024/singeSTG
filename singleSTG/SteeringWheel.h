//
//  SteeringWheel.h
//  singleSTG
//
//  Created by sh219 on 15/8/27.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"
/**
 
 方向控制摇杆
 
 */
@class SteeringWheel;
@protocol SteeringWheelDelegate <NSObject>

- (void)beginControlSteeringwheel:(SteeringWheel *)steeringWheel;
- (void)steeringWheel:(SteeringWheel *)steeringWheel direction:(double)angle;
- (void)endControlSteeringwheel:(SteeringWheel *)steeringWheel;;

@end

@interface SteeringWheel : UIImageView

- (instancetype)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) id delegate;
@end
