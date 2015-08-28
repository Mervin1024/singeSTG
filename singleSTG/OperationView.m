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
    pauseButton = [[KeyButton alloc]initWithFrame:CGRectMake(screenSize.width-operationViewHight/wheelScale*2-buttonHight*2*2, operationViewHight/wheelScale*2+buttonHight, buttonHight*2, buttonHight) title:@"Pause" image:nil];
    [self addSubview:pauseButton];
    
    // slowButton
    slowButton = [[KeyButton alloc]initWithFrame:CGRectMake(screenSize.width-operationViewHight/wheelScale-buttonHight*2, operationViewHight/wheelScale, buttonHight*2, buttonHight) title:@"Slow" image:nil];
    [self addSubview:slowButton];
    
    // shotButton
    shotButton = [[KeyButton alloc]initWithFrame:CGRectMake(screenSize.width-operationViewHight/wheelScale*2-buttonHight*2*2, operationViewHight/wheelScale, buttonHight*2, buttonHight) title:@"Shot" image:nil];
    [self addSubview:shotButton];
    
    // actionButton
    actionButton  = [[KeyButton alloc]initWithFrame:CGRectMake(screenSize.width-operationViewHight/wheelScale-buttonHight*2, operationViewHight/wheelScale*2+buttonHight, buttonHight*2, buttonHight) title:@"Boom" image:nil];
    [self addSubview:actionButton];
}

- (void)steeringWheel:(SteeringWheel *)steeringWheel direction:(double)angle{
    [self.delegate operationView:self steeringWheelDirection:angle];
}

@end

@implementation KeyButton
@synthesize restoreDic;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backColor image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setBackgroundColor:backColor];
        [self setTitle:title forState:UIControlStateNormal];
        _isChecked = NO;
        id ima = image;
        if (!ima) {
            ima = [NSNull null];
        }
        restoreDic = @{@"Title":title,
                       @"TitleColor":[UIColor blackColor],
                       @"BackgroundColor":backColor,
                       @"Frame":@[@(frame.origin.x),@(frame.origin.y),@(frame.size.width),@(frame.size.height)],
                       @"BackgroundImage":ima};
    }
    return self;
}

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backColor image:(UIImage *)image{
    return [[KeyButton alloc]initWithFrame:frame title:title titleColor:titleColor backgroundColor:backColor image:image];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image{
    self = [self initWithFrame:frame title:title titleColor:[UIColor blackColor] backgroundColor:[UIColor orangeColor] image:image];
    
    return self;
}



// 按钮属性复原
- (void)restore{
    [self setTitleColor:[restoreDic objectForKey:@"TitleColor"] forState:UIControlStateNormal];
    id image = [restoreDic objectForKey:@"BackgroundImage"];
    if ([image isKindOfClass:[NSNull class]]) {
        image = nil;
    }
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundColor:[restoreDic objectForKey:@"BackgroundColor"]];
    [self setTitle:[restoreDic objectForKey:@"Title"] forState:UIControlStateNormal];
    NSArray *frameArray = [restoreDic objectForKey:@"Frame"];
    CGRect frame = CGRectMake([frameArray[0] floatValue], [frameArray[1] floatValue], [frameArray[2] floatValue], [frameArray[3] floatValue]);
    [self setFrame:frame];
    self.enabled = YES;
}

@end
