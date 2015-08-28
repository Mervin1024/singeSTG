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
#import "OptionView.h"
#import "Boss.h"

@interface ViewController () <OperationViewDelegate,BulletDelegate>{
    OperationView *operationView;
    Player *player;
    OptionView *optionView;
    BOOL gameStart;
    BOOL pause;
    id enemy;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initEnemy];
    [self initPlayer];
//    [self initButton];
    [self initOperationView];
    [self initOptionView];
    
    gameStart = YES;
    pause = NO;
    [self.view setBackgroundColor:[UIColor yellowColor]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initEnemy{
    enemy = [[Boss alloc]initWithCenter:CGPointMake(self.view.center.x, 100)];
    [self.view addSubview:enemy];
}

- (void)initPlayer{
    player = [Player playerWithCenter:CGPointMake(self.view.center.x, 400) superViewController:self];
    [self.view addSubview:player];
}

- (void)initOptionView{
    optionView = [[OptionView alloc]init];
    [self.view addSubview:optionView];
    [optionView addOptionWithTitle:@"Continue" target:self select:@selector(coutinue)];
    [optionView addOptionWithTitle:@"Restart" target:self select:@selector(gameStart)];
    [optionView addOptionWithTitle:@"Exit" target:self select:@selector(gameEnd)];
}

- (void)coutinue{
    gameStart = YES;
    if (operationView.shotButton.isChecked) {
        [player startShoot];
    }
    [optionView disAppear];
    [operationView.pauseButton restore];
}

- (void)gameStart{
    NSLog(@"GameRestart");
//    [optionView disAppear];
//    [operationView.pauseButton restore];
}

- (void)gameEnd{
    NSLog(@"GameEnd");
//    [optionView disAppear];
//    [operationView.pauseButton restore];
}

- (void)initOperationView{
    operationView = [[OperationView alloc]initWithSuperView:self.view andViewController:self];
    operationView.delegate = self;
    [operationView.shotButton addTarget:self action:@selector(checkedShotButton) forControlEvents:UIControlEventTouchUpInside];
    [operationView.slowButton addTarget:self action:@selector(checkedSlowButton) forControlEvents:UIControlEventTouchUpInside];
    [operationView.pauseButton addTarget:self action:@selector(checkedPauseButton) forControlEvents:UIControlEventTouchUpInside];
    [operationView.actionButton addTarget:self action:@selector(checkedActionButton) forControlEvents:UIControlEventTouchDown];
    
}

- (void)checkedShotButton{
    if (!operationView.shotButton.isChecked) {
        [player startShoot];
        [operationView.shotButton setTitle:@"Shooting" forState:UIControlStateNormal];
        operationView.shotButton.isChecked = YES;
    }else{
        [player stopShoot];
        [operationView.shotButton restore];
        operationView.shotButton.isChecked = NO;
    }
}

- (void)checkedSlowButton{
    if (!operationView.slowButton.isChecked) {
        [operationView.slowButton setBackgroundColor:[UIColor yellowColor]];
        player.slow = YES;
        operationView.slowButton.isChecked = YES;
    }else{
        [operationView.slowButton restore];
        player.slow = NO;
        operationView.slowButton.isChecked = NO;
    }
}

- (void)checkedPauseButton{
    gameStart = NO;
    [player stopShoot];
    [optionView appear];
    [operationView.pauseButton setBackgroundColor:[UIColor yellowColor]];
    
}

- (void)checkedActionButton{
    [operationView.actionButton setBackgroundColor:[UIColor redColor]];
    operationView.actionButton.enabled = NO;
    [operationView.actionButton performSelector:@selector(restore) withObject:nil afterDelay:1];
}

//- (void)checked:(UIButton *)button{
//    if (!gameStart) {
//        NSLog(@"start");
//        [button setTitle:@"stop" forState:UIControlStateNormal];
//        [barrage start];
//        [player startShoot];
//        gameStart = YES;
//    }else{
//        NSLog(@"stop");
//        [button setTitle:@"start" forState:UIControlStateNormal];
//        [barrage stop];
//        [player stopShoot];
//        gameStart = NO;
//    }
//}

- (BOOL)moveState{
    if (!gameStart) {
        return NO;
    }
    return YES;
}

- (id)objectWillCollidedWithBullet:(Bullet *)bullet{
    switch (bullet.bulletSource) {
        case BulletSourceEnemy:
            return nil;
            break;
        case BulletSourceFirendly:
            return enemy;
            break;
    }
}

- (void)bullet:(Bullet *)bullet didCollidedWithAirframe:(Airframe *)object{
    
}

- (void)bullet:(Bullet *)bullet didOverScreenWithCenter:(CGPoint)center{
//    [barrage.allBullets removeObject:bullet];
}

- (void)operationView:(OperationView *)operationView steeringWheelDirection:(double)angle{
    NSLog(@"%f",angle);
}
@end
