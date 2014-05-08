//
//  Reel.m
//  Slot Machine
//
//  Created by Carl Milazzo on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "Reel.h"

#define ARC4RANDOM_MAX      0x100000000

static CGFloat const k7Chance = 0.10;
static CGFloat const kBellChance = 0.25;
static CGFloat const kBarChance = 0.45;
static CGFloat const kWatermelonChance = 0.70;
static CGFloat const kCherryChance = 1;

static int const kNumOnReel = 5;

@implementation Reel

-(id)init
{
    {
        self = [super init];
    }
    
    _reelNodes = [[NSMutableArray alloc]init];
    _nodeNumbers = [[NSMutableArray alloc]init];
    //setup standard images
    [self createReel];
    
    return self;
}

//used in init
-(NSMutableArray *)createReel
{
    for (int i = 0; i< kNumOnReel; i++) {
        //create the node
        [self createNode];
        //move other sprites down
        for(int j = 1; j<i; j++)
        {
            //[_reelNodes[j] position] = CGPointMake(0, ([_reelNodes[j] position].y + [_reelNodes[0] size].height));
        }
    }
    return nil;
}

//create a new node
-(void)createNode
{
    //randomized image
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    NSString *image;
    
    if(random < k7Chance)
    {
        image = @"7.png";
    }
    else if(random < kBellChance)
    {
        image = @"Bell.png";
    }
    else if (random < kBarChance)
    {
        image = @"Bar.png";
    }
    else if(random < kWatermelonChance)
    {
        image = @"Watermelon.png";
    }
    else
    {
        //cherry
        image = @"Cherry.png";
    }
    
    //make a new SKSpriteNode to insert into the array
    SKSpriteNode *newNode = [SKSpriteNode spriteNodeWithImageNamed:image];
    [_reelNodes insertObject: newNode atIndex: 0];
}


-(void)update:(CGFloat)dt
{
    //check nodes and see if they need to change
    
}

//
//
//
-(CGFloat)getRandomFloatBetween:(CGFloat)from to:(CGFloat)to {
    
    return (from + arc4random_uniform(to - from + 1));
    
}

@end
