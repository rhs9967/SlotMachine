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
    NSMutableArray *_NodeNumbers; //used to check for payout
}

-(id)init;

-(void)update:(CGFloat)dt;

-(NSMutableArray *)createReel;

@end
