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
    NSMutableArray *_reels;
    int _amount;
}

// public
-(void)updateGameStage{
    // Game logic //
    
    // Player stage
    if (_gameStage == kGameStagePlayer) {
        
        return;
    } // end player stage
    
    // Spin stage
    if (_gameStage == kGameStageSpin) {
        NSLog(@"GameModel - GameStageSpin Active: SPINNING!");
        
        // if reels have actions, continue // SKNode
        
        // if reels don't have actions
            // if weren't spun, begin actions
        
            // else, move on to results stage
            //_gameStage = kGameStageResult;
            return;
    } // end spin stage
    
    // Result stage
    if (_gameStage == kGameStageResult) {
        // display results
        
        // if touch detected, game over
            //[self notifyGameDidEnd];
        
    }
} // end updateGameStage

// private
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
