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

@interface ViewController () <OperationViewDelegate,BulletDelegate,AirframeDelegate>{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self gameEnd];
//    [self gameStart];
}

- (void)initEnemy{
    Boss *boss = [[Boss alloc]initWithCenter:CGPointMake(self.view.center.x, (self.view.frame.size.height-OPERATION_VIEW_HIGHT)/3)];
    boss.delegate = self;
    enemy = boss;
    [self.view addSubview:enemy];
}

- (void)initPlayer{
    player = [Player playerWithCenter:CGPointMake(self.view.center.x, self.view.frame.size.height-OPERATION_VIEW_HIGHT-80) superViewController:self];
    [self.view addSubview:player];
}
#pragma mark - Option View And Button Target Method
- (void)initOptionView{
    optionView = [[OptionView alloc]init];
    [self.view addSubview:optionView];
    [optionView addOptionWithTitle:@"Continue" target:self select:@selector(coutinue)];
    [optionView addOptionWithTitle:@"Restart" target:self select:@selector(gameStart)];
    [optionView addOptionWithTitle:@"Exit" target:self select:@selector(gameEnd)];
}

- (void)coutinue{
    [optionView disAppearWithCompletion:^(BOOL finished){
        gameStart = YES;
        if (operationView.shotButton.isChecked) {
            [player startShoot];
        }
        Boss *boss = enemy;
        boss.moveEnable = YES;
        enemy = boss;
        [enemy moveWithAngle:0 velocity:0];
    }];
    [operationView.pauseButton restore];
}

- (void)gameStart{
    NSLog(@"GameRestart");
    OptionCell *cell = optionView.allOptionCells[0];
    cell.enabled = YES;
    [cell setBackgroundColor:[UIColor whiteColor]];
    player.center = CGPointMake(self.view.center.x, 400);
    player.hidden = NO;
    [self coutinue];
    
    
}

- (void)gameEnd{
    NSLog(@"GameEnd");
}
#pragma mark - Operation View And Button Target Method
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
        
        Boss *boss = enemy;
        boss.moveEnable = YES;
        enemy = boss;
        [enemy moveWithAngle:0 velocity:0];
    }else{
        [player stopShoot];
        [operationView.shotButton restore];
        operationView.shotButton.isChecked = NO;
        
        Boss *boss = enemy;
        boss.moveEnable = NO;
        enemy = boss;
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
    Boss *boss = enemy;
    boss.moveEnable = NO;
    enemy = boss;
}

- (void)checkedActionButton{
    [operationView.actionButton setBackgroundColor:[UIColor redColor]];
    operationView.actionButton.enabled = NO;
    [operationView.actionButton performSelector:@selector(restore) withObject:nil afterDelay:1];
}
#pragma mark - Airframe delegate
- (void)airframe:(Airframe *)airframe didCollidedWithAirframe:(Airframe *)object{
    airframe.moveEnable = NO;
    object.moveEnable = NO;
    object.hidden = YES;
    OptionCell *cell = optionView.allOptionCells[0];
    cell.enabled = NO;
    [cell setBackgroundColor:[UIColor grayColor]];
    [self checkedPauseButton];
}

- (void)airframe:(Airframe *)airframe didOverScreenWithCenter:(CGPoint)center{
    
}

- (Airframe *)objectWillCollidedWithAirframe:(Airframe *)airframe{
    if ([airframe isKindOfClass:[Enemy class]]) {
        return player;
    }
    return nil;
}
#pragma mark - Bullet delegate
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
    
}
#pragma mark - OperationView delagate
- (void)beginControlSteeringwheel:(SteeringWheel *)steeringWheel{
    player.moveEnable = YES;
    [player moveWithAngle:0 velocity:0];
}

- (void)operationView:(OperationView *)operationView steeringWheelDirection:(double)angle velocity:(CGFloat)velocity{
    player.forwardAngle = angle;
    if (isnan(velocity)) {
        if (player.slow) {
            player.velocity = 10;
        }else{
            player.velocity = 20;
        }
    }else{
        player.velocity = velocity;
    }
    
}

- (void)endControlSteeringwheel:(SteeringWheel *)steeringWheel{
    player.forwardAngle = 0;
    player.velocity = 0;
    player.moveEnable = NO;
}
@end
