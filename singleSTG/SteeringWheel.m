//
//  SteeringWheel.m
//  singleSTG
//
//  Created by sh219 on 15/8/27.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "SteeringWheel.h"
#import "Math.h"

@interface SteeringWheel () <TouchViewDelegate>{
    UIImageView *centerImageView;
    CGFloat buttonRadius;
    CGPoint wheelCenter;
}

@end

@implementation SteeringWheel
NSString *const steetingWheelImage = @"Disc";
NSString *const steetingWheelCenterImage = @"DiscCenter";
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        buttonRadius = frame.size.width/2/3;
        centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonRadius*2, buttonRadius*2, buttonRadius*2, buttonRadius*2)];
        [self addSubview:centerImageView];
        wheelCenter = centerImageView.center;
        centerImageView.image = [UIImage imageNamed:steetingWheelCenterImage];
        self.image = [UIImage imageNamed:steetingWheelImage];
        
        TouchView *touchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        touchView.delegate = self;
        [self addSubview:touchView];
        self.userInteractionEnabled = YES;
        
//        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
#pragma mark - Touch View Delegate
- (void)touchView:(TouchView *)view touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat distance = [Math distanceOfPiont:point otherPoint:wheelCenter];
    
    if (distance > self.frame.size.height/2) {
        return;
    }
    [self.delegate beginControlSteeringwheel:self];
    if (distance < buttonRadius/3){
        return;
    }
    if (distance > self.frame.size.height/2-buttonRadius){
        double scale = (self.frame.size.height/2-buttonRadius)/distance;
        point = CGPointMake(point.x*scale-wheelCenter.x*(scale-1), point.y*scale-wheelCenter.y*(scale-1));
        [UIView animateWithDuration:0.2 animations:^{
            centerImageView.center = point;
        }completion:^(BOOL finished){
            
        }];
    }else{
        NSTimeInterval time = distance/(self.frame.size.height/2-buttonRadius)*0.2;
        [UIView animateWithDuration:time animations:^{
            centerImageView.center = point;
        }completion:^(BOOL finished){
            
        }];
    }
    
    [self.delegate steeringWheel:self direction:[Math radianOfVector:CGPointMake(point.x-wheelCenter.x, point.y-wheelCenter.y)] velocity:NAN];
}

- (void)touchView:(TouchView *)view touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat distance = [Math distanceOfPiont:point otherPoint:wheelCenter];
    
    if (distance > self.frame.size.height/2) {
        return;
    }
    if (distance < buttonRadius/3){
        centerImageView.center = point;
        [self.delegate steeringWheel:self direction:0 velocity:0];
        return;
    }
    if (distance > self.frame.size.height/2-buttonRadius){
        double scale = (self.frame.size.height/2-buttonRadius)/distance;
        point = CGPointMake(point.x*scale-wheelCenter.x*(scale-1), point.y*scale-wheelCenter.y*(scale-1));
        centerImageView.center = point;
    }else{
        centerImageView.center = point;
    }
    [self.delegate steeringWheel:self direction:[Math radianOfVector:CGPointMake(point.x-wheelCenter.x, point.y-wheelCenter.y)] velocity:NAN];
}

- (void)touchView:(TouchView *)view touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat distance = [Math distanceOfPiont:point otherPoint:wheelCenter];
    NSTimeInterval time = distance/(self.frame.size.height/2-buttonRadius)*0.2;
    [UIView animateWithDuration:time animations:^{
        centerImageView.center = wheelCenter;
    }completion:^(BOOL finished){
        
    }];
    [self.delegate endControlSteeringwheel:self];
    
}

@end
