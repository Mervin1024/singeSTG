//
//  ViewController.m
//  singleSTG
//
//  Created by sh219 on 15/8/25.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "ViewController.h"
#import "Bullet.h"
#import "Player.h"
#import "OperationView.h"

@interface ViewController () <OperationViewDelegate>{
    OperationView *operationView;
    Barrage *barrage;
    Player *player;
    BOOL gameStart;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initBarrage];
    [self initPlayer];
//    [self initButton];
    [self initOperationView];
    
    gameStart = NO;
    [self.view setBackgroundColor:[UIColor yellowColor]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(50, 50, 100, 50)];
    [button setTitle:@"start" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(checked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)initBarrage{
    barrage = [[Barrage alloc]initWithSuperViewController:self];
    [self.view addSubview:barrage];
}

- (void)initPlayer{
    player = [Player playerWithCenter:CGPointMake(self.view.center.x, 400) superView:self.view];
    [self.view addSubview:player];
}

- (void)initOperationView{
    operationView = [[OperationView alloc]initWithSuperView:self.view andViewController:self];
    operationView.delegate = self;
    [operationView.shotButton addTarget:self action:@selector(checkedShotButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkedShotButton{
    if (!player.shooting) {
        [player startShoot];
        [operationView.shotButton setTitle:@"Shooting" forState:UIControlStateNormal];
        player.shooting = YES;
    }else{
        [player stopShoot];
        [operationView.shotButton setTitle:@"Shot" forState:UIControlStateNormal];
        player.shooting = NO;
    }
}

- (void)checked:(UIButton *)button{
    if (!gameStart) {
        NSLog(@"start");
        [button setTitle:@"stop" forState:UIControlStateNormal];
        [barrage start];
        [player startShoot];
        gameStart = YES;
    }else{
        NSLog(@"stop");
        [button setTitle:@"start" forState:UIControlStateNormal];
        [barrage stop];
        [player stopShoot];
        gameStart = NO;
    }
}

- (id)objectWillCollidedWithBullet:(Bullet *)bullet{
    switch (bullet.bulletSource) {
        case BulletSourceEnemy:
            return nil;
            break;
        case BulletSourceFirendly:
            return nil;
            break;
    }
}

- (void)bullet:(Bullet *)bullet didCollidedWithAirframe:(id)object{
    NSLog(@"collided");
}

- (void)bullet:(Bullet *)bullet didOverScreenWithCenter:(CGPoint)center{
    [barrage.allBullets removeObject:bullet];
}

- (void)operationView:(OperationView *)operationView steeringWheelDirection:(double)angle{
    NSLog(@"%f",angle);
}
@end
