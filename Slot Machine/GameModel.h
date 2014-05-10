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

-(void)updateGameStage;
-(void)pullLever:(float)distance;
-(Lever*)getLever;

@end
