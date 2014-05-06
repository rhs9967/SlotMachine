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
    Lever *_lever;
    NSMutableArray *_reels;
    int _amount;
}

// public
-(void)pullLever:(float)distance{
    _lever.distance = distance;
}

-(void)updateGameStage{
    // Game logic //
    
    // Player stage
    if (_gameStage == kGameStagePlayer) {
        // if touch detected, see if it's on the lever
        
            // if so, calculate distance from lever top to touch and pull lever
        
        // if player let go of lever & lever is pulled far enough
        if (_lever.isLetGo & [_lever isPulledFar]) {
            // move on to spin stage
            _gameStage = kGameStageSpin;
            return;
        }
        return;
    } // end player stage
    
    // Spin stage
    if (_gameStage == kGameStageSpin) {
        // if reels have actions, continue // SKNode
        
        // if reels don't have actions
            // if weren't spun, begin actions
        
            // else, move on to results stage
            _gameStage = kGameStageResult;
            return;
    } // end spin stage
    
    // Result stage
    if (_gameStage == kGameStageResult) {
        // display results
        
        // if touch detected, game over
            //[self notifyGameDidEnd];
        
    }
} // end updateGameStage

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
