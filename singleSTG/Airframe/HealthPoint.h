//
//  HealthPoint.h
//  singleSTG
//
//  Created by sh219 on 15/9/1.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPoint : UIView

- (instancetype)initWithFrame:(CGRect)frame degree:(double)degree;

@property (assign ,nonatomic) double degree;
@end
