//
//  airframe.h
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Airframe : UIImageView

@property (assign, nonatomic) CGFloat diameter; // 圆的直径

- (instancetype)initWithCenter:(CGPoint)center;
@end
