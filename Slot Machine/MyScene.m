//
//  MyScene.m
//  Slot Machine
//
//  Created by Student on 5/3/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "MyScene.h"
#import "GameModel.h"
#import "Lever.h"

@implementation MyScene{
    GameModel *_gameModel;
    Lever *_lever;
    
    SKSpriteNode *_overlay;
    //SKSpriteNode *_leftReel;
    //SKSpriteNode *_middleReel;
    //SKSpriteNode *_rightReel;
    Reel *_leftReel;
    Reel *_middleReel;
    Reel *_rightReel;
    
    NSMutableArray *_reelTextures;
    
    BOOL _leverTouched;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
        
        // make gameModel
        _gameModel = [[GameModel alloc] init];
        _lever = [[Lever alloc] init];
        
        // continue setup
        [self setup];
        
        // register for kNotificationGameDidEnd notification
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(handleNotificationGameDidEnd:)
         name:kNotificationGameDidEnd
         object:_gameModel];
        
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
    //_leftReel = [SKSpriteNode spriteNodeWithTexture:[_reelTextures objectAtIndex:0]];
    //_middleReel = [SKSpriteNode spriteNodeWithTexture:[_reelTextures objectAtIndex:5]];
    //_rightReel = [SKSpriteNode spriteNodeWithTexture:[_reelTextures objectAtIndex:10]];
    _leftReel = [[Reel alloc] init];
    _middleReel = [[Reel alloc] init];
    _rightReel = [[Reel alloc] init];
    
    
    // positions
    CGPoint left = CGPointMake(_overlay.position.x - _overlay.size.width/3, _overlay.position.y-230);
    CGPoint middle = CGPointMake(_overlay.position.x, _overlay.position.y-230);
    CGPoint right = CGPointMake(_overlay.position.x + _overlay.size.width/3, _overlay.position.y-230);
    
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
    
    
    // add lever
    CGPoint leverPos = CGPointMake(_overlay.position.x*2, _overlay.position.y-150);
    _lever.position = leverPos;
    [_lever createParts:90:300];
    [self addChild:_lever];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        // get touch position
        CGPoint location = [touch locationInNode:self];
        //NSLog(@"Touch = (%f, %f)",location.x, location.y);
        
        //[self spinReel: _leftReel];
        //[self spinReel: _middleReel];
        //[self spinReel: _rightReel];
        
        
        // Check if touch location is on lever and if in player gamestage
        if ([_lever containsPoint:location] && _gameModel.gameStage == kGameStagePlayer) {
            _leverTouched = YES;
            _lever.distance = (_lever.position.y + _lever.leverHeight) - location.y;
        } else {
            _leverTouched = NO;
        }
        
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

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        //UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        if ([_lever containsPoint:location] && _leverTouched) {
            _lever.distance = (_lever.position.y + _lever.leverHeight) - location.y;
        }
        
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        //UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        // if player is still touching lever area
        if (location.x >= _lever.position.x && location.x <= _lever.position.x + _lever.leverWidth && _leverTouched) {
            // if lever was pulled far, set lever to down position and end stage
            if ([_lever isPulledFar]) {
                // set lever down
                _lever.distance = _lever.leverHeight;
                
                // end stage
                
                _gameModel.gameStage = kGameStageSpin;
                
                return;
            }
        }
        
        // lever is reset if touch is let go outside lever or was not pulled far (during player gamestage)
        if (_gameModel.gameStage == kGameStagePlayer) {
            _lever.distance = 0;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [_gameModel updateGameStage];
    [_lever update];
}

-(void)spinReel:(SKSpriteNode*)reel{
    // create an action that will animate the reel textures
    SKAction *reelAction = [SKAction animateWithTextures:_reelTextures timePerFrame:0.1];
    //[_leftReel runAction:[SKAction sequence:@[reelAction, remove]]];
    [reel runAction:reelAction];
    //[reel runAction:[SKAction repeatActionForever:reelAction]];
    
}

#pragma mark - Notifications
-(void) handleNotificationGameDidEnd:(NSNotification *)notification{
    //NSDictionary *userInfo = notification.userInfo;
    //NSNumber *num = userInfo[@"winnings"]; // the key for the dictionary
    //NSString *message = [NSString (@"Winnings: %f", num)];//NSString(@"Winnings: %f", [num intValue]);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"GameOver"
                          message:Nil // message
                          delegate:self
                          cancelButtonTitle:Nil
                          otherButtonTitles:@"Play Again", nil];
    [alert show];
}

@end
