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
//        self.backgroundColor = [UIColor clearColor];
        TouchView *touchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        touchView.delegate = self;
        [self addSubview:touchView];
        self.userInteractionEnabled = YES;
    }
    return self;
}
#pragma mark - Touch View Delegate
- (void)touchView:(TouchView *)view touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(point));
}

- (void)touchView:(TouchView *)view touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchView:(TouchView *)view touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
