//
//  GameModel.m
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel{
    //private ivars
    int _amount;
    int _pullsLeft;
    
    Reel *_leftReel;
    Reel *_middleReel;
    Reel *_rightReel;
    
}

// public
-(id)init:(CGSize)size :(CGPoint)pos
{
    self = [super init];
    
    _pullsLeft = 5;
    // setup reels
    _leftReel = [[Reel alloc] init];
    _middleReel = [[Reel alloc] init];
    _rightReel = [[Reel alloc] init];
    
    // positions
    CGPoint left = CGPointMake(pos.x - size.width/3, pos.y-230);
    CGPoint middle = CGPointMake(pos.x, pos.y-230);
    CGPoint right = CGPointMake(pos.x + size.width/3, pos.y-230);
    
    // place reels
    _leftReel.zPosition = -1;
    _leftReel.position = left;
    [self addChild:_leftReel];
    
    _middleReel.zPosition = -1;
    _middleReel.position = middle;
    [self addChild:_middleReel];
    
    _rightReel.zPosition = -1;
    _rightReel.position = right;
    [self addChild:_rightReel];
    
    return self;
}

-(void)updateGameStage:(CGFloat)dt{
    // Game logic //
    
    // Player stage
    if (_gameStage == kGameStagePlayer) {
        
        return;
    } // end player stage
    
    // Spin stage
    if (_gameStage == kGameStageSpin) {
        NSLog(@"GameModel - GameStageSpin Active: SPINNING!");
        
        // if reels have actions, continue // SKNode
        [_leftReel update:dt];
        [_middleReel update:dt];
        [_rightReel update:dt];
        
        // if not spinning move on to results stage
        if(!_rightReel.spinning)
        {
            _gameStage = kGameStageResult;
        }
        return;
    } // end spin stage
    
    // Result stage
    if (_gameStage == kGameStageResult) {
        // check for winnings
        if([self didWin])
        {
            // display results
            
        }
        // if touch detected, game over
        _gameStage = kGameStagePlayer;
        _pullsLeft--;
        NSLog(@"Pulls Left: %d",_pullsLeft);
        if(_pullsLeft <= 0)
        {
            [self notifyGameDidEnd];
        }
        
    }
} // end updateGameStage

-(void)spinReels
{
    [_leftReel spin];
    [_middleReel spin];
    [_rightReel spin];
}

// private
-(Boolean)didWin
{
    for(int i = 1; i < 4; i++)
    {
        NSLog(@"Line %d,|%@|%@|%@|",i,_leftReel.nodeNumbers[i],_middleReel.nodeNumbers[i],_rightReel.nodeNumbers[i]);
    }
    return false;
}

-(void) notifyGameDidEnd{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // wrap a Boolean into an NSNumber object using literals syntax
    //NSNumber *didDealerWin = @(_didDealerWin);
    NSNumber *winnings = [NSNumber numberWithInt:_amount]; // dictionary can only store objects ... so we turned the int into an object
    
    // create a dictionary using literals syntax
    NSDictionary *dict = @{@"winnings":winnings};
    
    // "publish" nofitication
    [notificationCenter postNotificationName:kNotificationGameDidEnd object:self userInfo:dict];
}

@end
