//
//  Reel.h
//  Slot Machine
//
//  Created by Carl Milazzo on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Reel : SKNode
{
    NSMutableArray *_reelNodes; //used for images
    Boolean _spinning;
    CGFloat _speed;
    CGFloat _accel;
}

@property NSMutableArray *nodeNumbers; //used to check for payout


//set up
-(id)init;
-(NSMutableArray *)createReel;

//gameplay
-(void)update:(CGFloat)dt;
-(void)createNode;

-(void)spin;

//utilities
-(CGFloat)getRandomFloatBetween:(CGFloat)from to:(CGFloat)to;

@end
