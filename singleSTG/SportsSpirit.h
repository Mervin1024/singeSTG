//
//  SportsSpirit.h
//  singleSTG
//
//  Created by sh219 on 15/8/26.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsSpirit : UIImageView

@property (assign, nonatomic) double forwardAngle; // 单位：弧度
@property (assign, nonatomic) CGFloat velocity;
@property (assign, nonatomic) BOOL moveEnable; // 默认 YES

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (void)moveWithAngle:(double)angle velocity:(CGFloat)velocity;

@end
