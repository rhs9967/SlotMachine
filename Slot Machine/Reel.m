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
static CGFloat const kOffScreen = -115;
static CGFloat const kTop = 460;

static CGFloat const kMaxSpeed = 115;
static CGFloat const kMinAccel = .5;
static int const kRangeAccel = .2;

static CGFloat const kSpinTime = 5;

@implementation Reel

-(id)init
{
    self = [super init];
    
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
    }
    for (int i = 0; i< kNumOnReel; i++)
    {
        SKSpriteNode *Node = (SKSpriteNode *)_reelNodes[i];
        [self addChild:Node];
    }
    _spinning = NO;
    return nil;
}

//create a new node at position 0
-(void)createNode
{
    //randomized image
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    NSString *image;
    NSNumber *num;
    
    if(random < k7Chance)
    {
        image = @"7.png";
        num = @1;
    }
    else if(random < kBellChance)
    {
        image = @"Bell.png";
        num = @2;
    }
    else if (random < kBarChance)
    {
        image = @"Bar.png";
        num = @3;
    }
    else if(random < kWatermelonChance)
    {
        image = @"Watermelon.png";
        num = @4;
    }
    else
    {
        //cherry
        image = @"Cherry.png";
        num = @5;
    }
    
    //make a new SKSpriteNode to insert into the array
    SKSpriteNode *newNode = [SKSpriteNode spriteNodeWithImageNamed:image];
    newNode.position = CGPointMake(0, kTop);
    [_reelNodes insertObject: newNode atIndex: 0];
    [_nodeNumbers insertObject: num atIndex: 0];
    
    //make sure all below it are now in the right spots
    for(int j = 1; j< _reelNodes.count; j++)
    {
        SKSpriteNode *Node = (SKSpriteNode *)_reelNodes[j];
        Node.position = CGPointMake(0, kTop-(Node.size.height*j));
    }
    
}

-(void)spin
{
    if(!_spinning)
    {
        _spinning = YES;
        CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
        _accel = (random * kRangeAccel)+kMinAccel;
        _curSpinTime = 0;
    }
}

-(void)stop
{
    if(_spinning)
    {
        _spinning = NO;
    }
}

-(void)update:(CGFloat)dt
{
    //check nodes and see if they need to change
    if(_spinning)
    {
        _curSpinTime += dt;
        
        for (int i = 0; i< kNumOnReel; i++)
        {
            SKSpriteNode *Node = (SKSpriteNode *)_reelNodes[i];
            
            //accelerate
            if(_speed < kMaxSpeed)
            {
                _speed = _speed + _accel;
            }
            else
            {
                _speed = kMaxSpeed;
            }
            //move
            Node.position = CGPointMake(Node.position.x, Node.position.y-_speed);
            
            if(Node.position.y <= kOffScreen)
            {
                //remove this and all nodes after it
                for(int j = kNumOnReel-1; j >= i; j--)
                {
                    SKSpriteNode *RemoveNode = (SKSpriteNode *)_reelNodes[j];
                    
                    //remove
                    [self removeChildrenInArray:@[RemoveNode]];
                    [_reelNodes removeObject:RemoveNode];
                    [_nodeNumbers removeObjectAtIndex:j];
                    
                    //add new
                    [self createNode];
                    [self addChild:(SKSpriteNode *)_reelNodes[0]];
                    
                    if(_curSpinTime >= kSpinTime)
                    {
                        [self stop];
                    }
                }
            }
        }
    }
    
}

//
//
//
-(CGFloat)getRandomFloatBetween:(CGFloat)from to:(CGFloat)to {
    
    return (from + arc4random_uniform(to - from + 1));
    
}

@end
