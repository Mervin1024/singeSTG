//
//  SteeringWheel.m
//  singleSTG
//
//  Created by sh219 on 15/8/27.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "SteeringWheel.h"

@interface SteeringWheel () <TouchViewDelegate>{
    TouchButton *button;
}

@end

@implementation SteeringWheel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat buttonRadius = frame.size.width/2/3;
        button = [[TouchButton alloc]initWithFrame:CGRectMake(buttonRadius*2, buttonRadius*2, buttonRadius*2, buttonRadius*2)];
        [self addSubview:button];
        button.delegate = self;
        
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}
#pragma mark - Touch View Delegate
- (void)touchView:(TouchView *)view touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchView:(TouchView *)view touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchView:(TouchView *)view touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end

@implementation TouchButton
NSString *const touchButtonImage = @"TouchButton";
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    if ((self = [super initWithFrame:frame])) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
        [imageView setImage:image];
        
        imageView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame image:[UIImage imageNamed:touchButtonImage]];
    return self;
}

@end
