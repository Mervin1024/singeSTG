//
//  TouchView.h
//  singleSTG
//
//  Created by 马遥 on 15/8/11.
//  Copyright (c) 2015年 Mervin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 用来捕捉触摸事件的view
 
 */

@class TouchView;
@protocol TouchViewDelegate <NSObject>

@optional
- (void)touchView:(TouchView *)view touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchView:(TouchView *)view touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchView:(TouchView *)view touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface TouchView : UIView
@property (nonatomic, weak) id<TouchViewDelegate> delegate;
@end
