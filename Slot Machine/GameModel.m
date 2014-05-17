//
//  GameModel.m
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "GameModel.h"

static int const kMaxPulls = 5;

@implementation GameModel{
    //private ivars
    int _amount;
    int _pullsLeft;
    
    Reel *_leftReel;
    Reel *_middleReel;
    Reel *_rightReel;
    
    Lever *_lever;
    
    SKEmitterNode *_spark1;    
}

// public
-(id)init:(CGSize)size :(CGPoint)pos
{
    self = [super init];
    
    _pullsLeft = kMaxPulls;
    
    // Reels //
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
    
    // Lever //
    // setup lever
    _lever = [[Lever alloc] init];
    
    // position and place lever
    CGPoint leverPos = CGPointMake(pos.x*2, pos.y-150);
    _lever.position = leverPos;
    
    // add lever
    [self addChild:_lever];
    
    // EmitterNodes
    _spark1 = [NSKeyedUnarchiver unarchiveObjectWithFile:
               [[NSBundle mainBundle] pathForResource:@"spark1"
                                               ofType:@"sks"]];
    _spark1.position = CGPointMake(pos.x, pos.y);
    _spark1.zPosition = 10;
    _spark1.name = @"spark1";
    //_spark1.targetNode = self->_overlay;
    //[self addChild:_spark1];
    
    return self;
}

-(void)updateGameStage:(CGFloat)dt{
    // Game logic //
    // update Lever visuals accordingly
    [_lever update];
    
    // Player stage
    if (_gameStage == kGameStagePlayer) {
        //[_spark1 removeFromParent];
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
            // reset lever
            _lever.isRising = YES;
            
            // move to next stage
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
            [self addChild:_spark1];
            [self notifyGameDidEnd];
        }
        
        
    }
} // end updateGameStage

-(void)reset{
    [_spark1 removeFromParent];
    _gameStage = kGameStagePlayer;
    _pullsLeft = kMaxPulls;
}

-(void)spinReels
{
    [_leftReel spin];
    [_middleReel spin];
    [_rightReel spin];
}

-(void)checkTouch:(CGPoint)location :(BOOL)touchedEnded{
    // if the touch has ended, check if final touch is within lever 'area'
    if (touchedEnded) {
        if (location.x >= _lever.position.x && location.x <= _lever.position.x + _lever.leverWidth) {
            // if lever was pulled far, set lever to down position and end stage
            if ([_lever isPulledFar]) {
                // set lever down
                _lever.isRising = YES;
                _lever.leverTouched = NO;
                
                // spin reels
                [self spinReels];
                
                // end stage
                _gameStage = kGameStageSpin;
                
                return;
            }
        }
        // lever is reset if let go outside lever or wasn't pulled far
        _lever.isRising = YES;
    } else {
        // Check if touch location is on lever
        if ([_lever containsPoint:location] ) {//|| _lever.leverTouched) {
            // if so, set _leverTouched to YES
            if (_lever.leverTouched == NO) _lever.leverTouched = YES;
            
            // set lever distance accordingly
            _lever.distance = (_lever.position.y + _lever.leverHeight) - location.y;
            
            _lever.isRising = NO;
            return;
        }
    }
    
    _lever.leverTouched = NO;
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
