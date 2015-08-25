//
//  airframe.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Airframe.h"

@implementation Airframe
CGFloat airframeDiameter = 15;
@synthesize diameter;

- (instancetype)initWithCenter:(CGPoint)center{
    CGRect frame = CGRectMake(center.x-airframeDiameter/2, center.y-airframeDiameter/2, airframeDiameter, airframeDiameter);
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"Airframe"]];
        diameter = airframeDiameter;
    }
    return self;
}
@end
