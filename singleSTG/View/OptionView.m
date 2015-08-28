//
//  OptionView.m
//  singleSTG
//
//  Created by sh219 on 15/8/28.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "OptionView.h"
#import "TouchView.h"

@interface OptionView ()<TouchViewDelegate>{
    TouchView *touchView;
}

@end

@implementation OptionView
CGFloat space = 15;
- (instancetype)init{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        touchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        touchView.alpha = 0;
        touchView.backgroundColor = [UIColor blackColor];
        [self addSubview:touchView];
        self.hidden = YES;
        _allOptionCells = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithSuperView:(UIView *)view{
    self = [self init];
    return self;
}

- (OptionCell *)cellWithTitle:(NSString *)title image:(UIImage *)image target:(id)target select:(SEL)select{
    return [[OptionCell alloc]initWithTitle:title image:image target:target select:select];
}

- (void)setOptionWithTitle:(NSString *)title target:(id)target select:(SEL)select index:(NSUInteger)index{
    [self addOptionWithTitle:title target:target select:select];
    NSUInteger count = [self.allOptionCells count];
    OptionCell *cellAtIndex = self.allOptionCells[index];
    CGRect frameAtIndex = cellAtIndex.frame;
    OptionCell *lastCell = [self.allOptionCells lastObject];
    lastCell.frame = frameAtIndex;
    for (int i = 0; i < count-1; i++) {
        if (i < index) {
            
        }else{
            OptionCell *cell = self.allOptionCells[i];
            CGRect frame = cell.frame;
            frame.origin.y += (frame.size.height + space);
            cell.frame = frame;
        }
    }
    
}

- (void)addOptionWithTitle:(NSString *)title target:(id)target select:(SEL)select{
    OptionCell *newCell = [self cellWithTitle:title image:[UIImage imageNamed:@"OptionCell"] target:target select:select];
    newCell.hidden = YES;
    if (self.allOptionCells.count == 0) {
        
    }else{
        OptionCell *cell = [self.allOptionCells lastObject];
        CGRect frame = newCell.frame;
        frame.origin.y = cell.frame.origin.y+frame.size.height+space;
        newCell.frame = frame;
        
    }
    [self addSubview:newCell];
    [self.allOptionCells addObject:newCell];
    for (OptionCell *cell in self.allOptionCells) {
        CGRect frame = cell.frame;
        frame.origin.y -= (frame.size.height/2 + space);
        cell.frame = frame;
    }
}

- (void)removeOptionAtIndex:(NSUInteger)index{
    NSUInteger count = [self.allOptionCells count];
    for (int i = 0; i < count; i++) {
        if (i <= index) {
            
        }else{
            OptionCell *cell = self.allOptionCells[i];
            CGRect frame = cell.frame;
            frame.origin.y -= frame.size.height;
            cell.frame = frame;
        }
    }
    OptionCell *cellAtIndex = self.allOptionCells[index];
    [cellAtIndex removeFromSuperview];
    [self.allOptionCells removeObject:cellAtIndex];
}

- (void)appear{
    NSUInteger count = [self.allOptionCells count];
    for (int i = 0; i < count; i++) {
        OptionCell *cell = self.allOptionCells[i];
        cell.hidden = NO;
        CGRect frame = cell.frame;
        CGPoint origin = frame.origin;
        origin.x += 5;
        frame.origin.x = -frame.size.width;
        cell.frame = frame;
        [self optionCell:cell setAnimationToPoint:origin afterDelay:i*0.1];
    }
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        touchView.alpha = 0.5;
    }];
    
}

- (void)optionCell:(OptionCell *)optionCell setAnimationToPoint:(CGPoint)point afterDelay:(NSTimeInterval)time{
    [self performSelector:@selector(setAnimationWithDictionary:) withObject:@{@"optionCell":optionCell,@"point.x":@(point.x),@"point.y":@(point.y)} afterDelay:time];
}

- (void)setAnimationWithDictionary:(NSDictionary *)dic{
    OptionCell *optionCell = [dic objectForKey:@"optionCell"];
    CGPoint point = CGPointMake([[dic objectForKey:@"point.x"] floatValue], [[dic objectForKey:@"point.y"] floatValue]);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = optionCell.frame;
        frame.origin.y = point.y;
        frame.origin.x = point.x;
        optionCell.frame = frame;
    }completion:^(BOOL finished){
        CGRect frame = optionCell.frame;
        frame.origin.x -= 5;
        optionCell.frame = frame;
    }];
}

- (void)disAppear{
    for (OptionCell *cell in self.allOptionCells) {
        cell.hidden = YES;
    }
    [UIView animateWithDuration:0.5 animations:^{
        touchView.alpha = 0;
    }completion:^(BOOL finished){
        self.hidden = YES;
    }];
}

@end

@implementation OptionCell
CGFloat cellWidth = 200;
CGFloat cellHight = 44;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target select:(SEL)select{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:CGRectMake(frame.size.width/2-cellWidth/2, frame.size.height/2-cellHight/2, cellWidth, cellHight)];
    if (self) {
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

@end
