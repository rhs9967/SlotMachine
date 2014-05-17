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
    //Lever *_lever;
    
    SKSpriteNode *_overlay;

    
    NSMutableArray *_reelTextures;
    
    double _lastTime;
    
    BOOL _leverTouched;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
        
        // make gameModel
        //_lever = [[Lever alloc] init];
        
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
    
    //create gameModel
    _gameModel = [[GameModel alloc] init:_overlay.size :_overlay.position];
    [self addChild:_gameModel];
    
    //add overlay
    [self addChild:_overlay];
    
    // load reel atlas
    SKTextureAtlas *reelAtlas = [SKTextureAtlas atlasNamed:@"Reel"];
    
    NSArray *reelTextureNames = [reelAtlas textureNames];
    _reelTextures = [NSMutableArray array];
    
    for (NSString *name in reelTextureNames) {
        SKTexture *texture = [reelAtlas textureNamed:name];
        [_reelTextures addObject:texture];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        // get touch position
        CGPoint location = [touch locationInNode:self];
        //NSLog(@"Touch = (%f, %f)",location.x, location.y);
        
        // if Player Stage
        if (_gameModel.gameStage == kGameStagePlayer) {
            // inform gameModel of touch
            [_gameModel checkTouch:location :NO];
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        //UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        // if Player Stage
        if (_gameModel.gameStage == kGameStagePlayer) {
            // inform gameModel of touch
            [_gameModel checkTouch:location :NO];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        //UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        // if Player Stage
        if (_gameModel.gameStage == kGameStagePlayer) {
            // inform gameModel of touch
            [_gameModel checkTouch:location :YES];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    // calculate deltaTime
    double time = (double)CFAbsoluteTimeGetCurrent();
    // NSLog(@"time=%f",time);
    float dt = time - _lastTime;
    _lastTime = time;
    // NSLog(@"delta=%f",dt);
    
    [_gameModel updateGameStage:dt];
    //[_lever update];
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
