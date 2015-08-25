//
//  ViewController.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "ViewController.h"
#import "Bullet.h"

@interface ViewController (){
    Barrage *barrage;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarrage];
    [self initButton];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"start" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(checked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)initBarrage{
    barrage = [[Barrage alloc]initWithSuperViewController:self];
    [self.view addSubview:barrage];
}

- (void)checked:(UIButton *)button{
    if (!barrage.started) {
        NSLog(@"start");
        [button setTitle:@"stop" forState:UIControlStateNormal];
        [barrage start];
    }else{
        NSLog(@"stop");
        [button setTitle:@"start" forState:UIControlStateNormal];
        [barrage stop];
    }
}

- (void)bullet:(Bullet *)bullet didCollidedWithObject:(id)object{
    NSLog(@"collided");
}

- (void)bullet:(Bullet *)bullet didOverScreenWithOrigin:(CGPoint)origin{
    [barrage.allBullets removeObject:bullet];
}

@end
