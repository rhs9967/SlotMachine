//
//  EndScene.m
//  Slot Machine
//
//  Created by Student on 5/20/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "EndScene.h"
#import "TitleScene.h"
#import "MyScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation EndScene
{
    SKSpriteNode *playAgain;
    SKSpriteNode *mainMenu;
    SKLabelNode *playAgainText;
    SKLabelNode *mainMenuText;
    
    BOOL _playAgainPressed;
    BOOL _mainMenuPressed;
    
    AVAudioPlayer *_winAudio;    
    
    SKEmitterNode *endParticle;
    
}

-(id)initWithSize:(CGSize)size score:(CGFloat)score {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
        
        // labels
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        SKLabelNode *name1Label = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        SKLabelNode *name2Label = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        
        // myLabel
        myLabel.text = @"Your final Score:";
        myLabel.fontSize = 90;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)*7/5);
        
        // name1Label
        name1Label.text = [NSString stringWithFormat:@"$%.00f!!!!",score];
        name1Label.fontSize = 80;
        name1Label.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame));
        
        // PlayAgain
        playAgain = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        playAgain.position = CGPointMake(CGRectGetMidX(self.frame)*3/5,CGRectGetMidY(self.frame)*3/5);
        playAgain.name = @"playAgain";
        [self addChild:playAgain];
        
        playAgainText = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        
        playAgainText.text = @"Play Again";
        playAgainText.name = @"playAgain";
        playAgainText.fontSize = 50;
        playAgainText.fontColor = [SKColor blackColor];
        playAgainText.position = CGPointMake(CGRectGetMidX(self.frame)*3/5,CGRectGetMidY(self.frame)*3/5-15);
        [self addChild:playAgainText];
        
        
        // MainMenu button
        mainMenu = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        mainMenu.position = CGPointMake(CGRectGetMidX(self.frame)*7/5,CGRectGetMidY(self.frame)*3/5);
        mainMenu.name = @"mainMenu";
        [self addChild:mainMenu];
        
        mainMenuText = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        
        mainMenuText.text = @"Main Menu";
        mainMenuText.name = @"mainMenu";
        mainMenuText.fontSize = 50;
        mainMenuText.fontColor = [SKColor blackColor];
        mainMenuText.position = CGPointMake(CGRectGetMidX(self.frame)*7/5,CGRectGetMidY(self.frame)*3/5-15);
        [self addChild:mainMenuText];
        
        
        NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"endParticle" ofType:@"sks"];
        endParticle = [NSKeyedUnarchiver unarchiveObjectWithFile: sparkPath];
        
        endParticle.position = CGPointMake(CGRectGetMidX(self.frame),name1Label.position.y+name1Label.frame.size.width/2);
        //endParticle.position = CGPointZero;
        endParticle.zPosition = 0;
        endParticle.zRotation = 0;
        //[self addChild:endParticle];
        
        [self addChild:myLabel];
        [self addChild:name1Label];
        [self addChild:name2Label];
        
        // sound
        NSURL *winURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"win1" ofType:@"mp3"]];
        _winAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:winURL error:nil];
        [_winAudio play];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        // get touch position
        CGPoint location = [touch locationInNode:self];

        SKNode *node = [self nodeAtPoint:location];
        
        // if touch was on betting buttons
        if ([node.name isEqualToString:@"playAgain"]) {
            // begin button press
            _playAgainPressed = YES;
            playAgain.xScale = 0.8;
            playAgain.yScale = 0.8;
            playAgainText.xScale = 0.8;
            playAgainText.yScale = 0.8;
            
        }
        else if ([node.name isEqualToString:@"mainMenu"]) {
            // begin button press
            _mainMenuPressed = YES;
            mainMenu.xScale = 0.8;
            mainMenu.yScale = 0.8;
            mainMenuText.xScale = 0.8;
            mainMenuText.yScale = 0.8;
            
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _mainMenuPressed = NO;
    _playAgainPressed = NO;
    playAgain.xScale = 1;
    playAgain.yScale = 1;
    
    playAgainText.xScale = 1;
    playAgainText.yScale = 1;
    
    mainMenu.xScale = 1;
    mainMenu.yScale = 1;
    
    mainMenuText.xScale = 1;
    mainMenuText.yScale = 1;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        // get touch position
        CGPoint location = [touch locationInNode:self];

        SKNode *node = [self nodeAtPoint:location];
        

        if(_mainMenuPressed && [node.name isEqualToString:@"mainMenu"])
        {
            // Create and configure the scene
            SKScene * titleScene = [[TitleScene alloc] initWithSize:self.size];
        
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:titleScene transition:reveal];
        }
        else if (_playAgainPressed && [node.name isEqualToString:@"playAgain"])
        {
        
            // Create and configure the scene
            SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
        
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:myScene transition:reveal];
        }
        else
        {
            _mainMenuPressed = NO;
            _playAgainPressed = NO;
            playAgain.xScale = 1;
            playAgain.yScale = 1;
            
            playAgainText.xScale = 1;
            playAgainText.yScale = 1;
            
            mainMenu.xScale = 1;
            mainMenu.yScale = 1;
            
            mainMenuText.xScale = 1;
            mainMenuText.yScale = 1;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}


@end
