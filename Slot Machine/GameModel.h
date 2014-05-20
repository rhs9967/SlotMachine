//
//  GameModel.h
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Lever.h"
#import "Reel.h"

static NSString *kNotificationGameDidEnd = @"kNotificationGameDidEnd";

typedef enum : int{
    kGameStagePlayer,
    kGameStageSpin,
    kGameStageResult
}kGameStage;

@interface GameModel : SKNode
@property (nonatomic) kGameStage gameStage;
@property (nonatomic) CGPoint touch;
@property int amount;
@property int bet;

-(id)init :(CGSize)size :(CGPoint)pos;
-(void)updateGameStage : (CGFloat)dt;
-(void)checkTouch : (CGPoint)location : (BOOL)touchedEnded;
-(void)increaseBet;
-(void)decreaseBet;
-(void)spinReels;
-(void)reset;
@end
