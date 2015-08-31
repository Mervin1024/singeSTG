//
//  Math.m
//  singleSTG
//
//  Created by sh219 on 15/8/31.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "Math.h"

@implementation Math

+ (CGFloat)distanceOfPiont:(CGPoint)point otherPoint:(CGPoint)otherPoint{
    return sqrt(pow(point.x-otherPoint.x, 2)+pow(point.y-otherPoint.y, 2));
}

+ (double)radianOfVector:(CGPoint)vector{
    if (vector.x >= 0) {
        return atan(vector.y/vector.x);
    }else{
        return M_PI+atan(vector.y/vector.x);
    }
}

@end
