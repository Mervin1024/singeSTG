//
//  OptionView.h
//  singleSTG
//
//  Created by sh219 on 15/8/28.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OptionCell;
@interface OptionView : UIView

@property (copy, nonatomic) NSMutableArray *allOptionCells;

- (instancetype)initWithSuperView:(UIView *)view;
- (OptionCell *)cellWithTitle:(NSString *)title image:(UIImage *)image target:(id)target select:(SEL)select;
- (void)setOptionWithTitle:(NSString *)title target:(id)target select:(SEL)select index:(NSUInteger)index;
- (void)addOptionWithTitle:(NSString *)title target:(id)target select:(SEL)select;
- (void)removeOptionAtIndex:(NSUInteger)index;

- (void)appear;
- (void)disAppear;
@end

@interface OptionCell : UIButton

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target select:(SEL)select;

@end