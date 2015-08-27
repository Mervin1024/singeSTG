//
//  OperationView.m
//  singleSTG
//
//  Created by sh219 on 15/8/27.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "OperationView.h"

@interface OperationView () <SteeringWheelDelegate> {
}

@end

@implementation OperationView
@synthesize wheel,pauseButton,shotButton,slowButton,actionButton;
CGFloat operationViewHight = 150;
CGFloat wheelScale = 7;
- (instancetype)initWithSuperView:(UIView *)view andViewController:(UIViewController *)viewController{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = CGRectMake(0, screenSize.height-operationViewHight, screenSize.width, operationViewHight);
    if ((self = [super initWithFrame:frame])) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:self];
        [self addWheel];
        [self addButtons];
        wheel.delegate = self;
        
    }
    return self;
}

- (void)addWheel{
    wheel = [[SteeringWheel alloc]initWithFrame:CGRectMake(operationViewHight/wheelScale, operationViewHight/wheelScale, operationViewHight/wheelScale*(wheelScale-2), operationViewHight/wheelScale*(wheelScale-2))];
    [self addSubview:wheel];
}

- (void)addButtons{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat buttonHight = operationViewHight/wheelScale*((wheelScale-3)/2);
    
    // pauseButton
    pauseButton = [KeyButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(screenSize.width-operationViewHight/wheelScale*2-buttonHight*2*2, operationViewHight/wheelScale*2+buttonHight, buttonHight*2, buttonHight) title:@"Pause" image:nil];
    [pauseButton setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:pauseButton];
    
    // slowButton
    slowButton = [KeyButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(screenSize.width-operationViewHight/wheelScale-buttonHight*2, operationViewHight/wheelScale, buttonHight*2, buttonHight) title:@"Slow" image:nil];
    [slowButton setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:slowButton];
    
    // shotButton
    shotButton = [KeyButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(screenSize.width-operationViewHight/wheelScale*2-buttonHight*2*2, operationViewHight/wheelScale, buttonHight*2, buttonHight) title:@"Shot" image:nil];
    [shotButton setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:shotButton];
    
    // actionButton
    actionButton = [KeyButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(screenSize.width-operationViewHight/wheelScale-buttonHight*2, operationViewHight/wheelScale*2+buttonHight, buttonHight*2, buttonHight) title:@"Boom" image:nil];
    [actionButton setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:actionButton];
}

- (void)steeringWheel:(SteeringWheel *)steeringWheel direction:(double)angle{
    [self.delegate operationView:self steeringWheelDirection:angle];
}

@end

@implementation KeyButton

- (instancetype)initWithFrame:(CGRect)frame type:(UIButtonType)buttonType title:(NSString *)title image:(UIImage *)image{
    self = [UIButton buttonWithType:buttonType];
    if (self) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setFrame:frame];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame title:(NSString *)title image:(UIImage *)image{
    return [[KeyButton alloc]initWithFrame:frame type:buttonType title:title image:image];
}

@end
