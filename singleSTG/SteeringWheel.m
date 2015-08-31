//
//  SteeringWheel.m
//  singleSTG
//
//  Created by sh219 on 15/8/27.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "SteeringWheel.h"

@interface SteeringWheel () <TouchViewDelegate>{
    UIImageView *centerImageView;
}

@end

@implementation SteeringWheel
NSString *const steetingWheelImage = @"Disc";
NSString *const steetingWheelCenterImage = @"DiscCenter";
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat buttonRadius = frame.size.width/2/3;
        centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonRadius*2, buttonRadius*2, buttonRadius*2, buttonRadius*2)];
        [self addSubview:centerImageView];
        centerImageView.image = [UIImage imageNamed:steetingWheelCenterImage];
        self.image = [UIImage imageNamed:steetingWheelImage];
        
        TouchView *touchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        touchView.delegate = self;
        [self addSubview:touchView];
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
#pragma mark - Touch View Delegate
- (void)touchView:(TouchView *)view touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat distance = [self distanceOfPiont:point otherPoint:centerImageView.center];
    if (distance > self.frame.size.height/2) {
        return;
    }else if (distance > self.frame.size.height/2-centerImageView.frame.size.height/2){
        double scale = (self.frame.size.height/2-centerImageView.frame.size.height/2)/distance;
        CGPoint newPoint = CGPointMake(point.x*scale-centerImageView.center.x*(scale-1), point.y*scale-centerImageView.center.y*(scale-1));
        [UIView animateWithDuration:0.2 animations:^{
            centerImageView.center = newPoint;
        }completion:^(BOOL finished){
            
        }];
        return;
    }else{
        NSTimeInterval time = distance/(self.frame.size.height/2-centerImageView.frame.size.height/2)*0.2;
        [UIView animateWithDuration:time animations:^{
            centerImageView.center = point;
        }completion:^(BOOL finished){
            
        }];
        return;
    }
}

- (void)touchView:(TouchView *)view touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchView:(TouchView *)view touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    centerImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (CGFloat)distanceOfPiont:(CGPoint)point otherPoint:(CGPoint)otherPoint{
    return sqrt(pow(point.x-otherPoint.x, 2)+pow(point.y-otherPoint.y, 2));
}

@end
