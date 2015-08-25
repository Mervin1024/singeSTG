//
//  Barrage.h
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bullet.h"

@interface Barrage : UIView

- (instancetype)initWithSuperViewController:(UIViewController *)viewController;

- (void)start;
- (void)stop;

@property (assign, nonatomic) BOOL started;
@property (copy, nonatomic)NSMutableArray *allBullets;
@end

