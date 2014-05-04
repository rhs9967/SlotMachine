//
//  MyScene.m
//  Slot Machine
//
//  Created by Student on 5/3/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene{
    SKSpriteNode *_overlay;
    SKSpriteNode *_leftReel;
    SKSpriteNode *_middleReel;
    SKSpriteNode *_rightReel;
    NSMutableArray *_reelTextures;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
        
        [self setup];
        
        /*
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
         */
    }
    return self;
}

-(void)setup{
    _overlay = [SKSpriteNode spriteNodeWithImageNamed:@"slotmachine-symbol-overlay"];
    _overlay.position = CGPointMake(_overlay.size.width,
                                   self.size.height/2);
    // Scale up
    _overlay.xScale = 1.5;
    _overlay.yScale = 1.5;
    [self addChild:_overlay];
    
    // load reel atlas
    SKTextureAtlas *reelAtlas = [SKTextureAtlas atlasNamed:@"Reel"];
    
    NSArray *reelTextureNames = [reelAtlas textureNames];
    _reelTextures = [NSMutableArray array];
    
    for (NSString *name in reelTextureNames) {
        SKTexture *texture = [reelAtlas textureNamed:name];
        [_reelTextures addObject:texture];
    }
    
    // setup reels
    _leftReel = [SKSpriteNode spriteNodeWithTexture:[_reelTextures objectAtIndex:0]];
    _middleReel = [SKSpriteNode spriteNodeWithTexture:[_reelTextures objectAtIndex:5]];
    _rightReel = [SKSpriteNode spriteNodeWithTexture:[_reelTextures objectAtIndex:10]];
    
    // positions
    CGPoint left = CGPointMake(_overlay.position.x - _overlay.size.width/3, _overlay.position.y);
    CGPoint middle = CGPointMake(_overlay.position.x, _overlay.position.y);
    CGPoint right = CGPointMake(_overlay.position.x + _overlay.size.width/3, _overlay.position.y);
    
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        // get touch position
        //CGPoint touchPos = [touch locationInNode:self];
        
        
        [self spinReel: _leftReel];
        [self spinReel: _middleReel];
        [self spinReel: _rightReel];
       // [self spinReel:middle];
        //[self spinReel:right];
        
        /*
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
         */
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)spinReel:(SKSpriteNode*)reel{
    // create an action that will animate the reel textures
    SKAction *reelAction = [SKAction animateWithTextures:_reelTextures timePerFrame:0.1];
    //[_leftReel runAction:[SKAction sequence:@[reelAction, remove]]];
    [reel runAction:reelAction];
    
}

@end
