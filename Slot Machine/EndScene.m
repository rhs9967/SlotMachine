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

@implementation EndScene
{
    SKSpriteNode *playAgain;
    SKSpriteNode *mainMenu;
    
    BOOL _playAgainPressed;
    BOOL _mainMenuPressed;
    
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
        name1Label.text = [NSString stringWithFormat:@"%f!!!!",score];
        name1Label.fontSize = 60;
        name1Label.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame));
        
        // PlayAgain
        playAgain = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        playAgain.position = CGPointMake(CGRectGetMidX(self.frame)*3/5,CGRectGetMidY(self.frame)*3/5);
        playAgain.name = @"playAgain";
        [self addChild:playAgain];
        
        SKLabelNode *playAgainText = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        
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
        
        SKLabelNode *mainMenuText = [SKLabelNode labelNodeWithFontNamed:@"BudmoJiggler-Regular"];
        
        mainMenuText.text = @"Main Menu";
        mainMenuText.name = @"mainMenu";
        mainMenuText.fontSize = 50;
        mainMenuText.fontColor = [SKColor blackColor];
        mainMenuText.position = CGPointMake(CGRectGetMidX(self.frame)*7/5,CGRectGetMidY(self.frame)*3/5-15);
        [self addChild:mainMenuText];
        
        
        [self addChild:myLabel];
        [self addChild:name1Label];
        [self addChild:name2Label];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        
        // get touch position
        CGPoint location = [touch locationInNode:self];
        //NSLog(@"Touch = (%f, %f)",location.x, location.y);
        SKNode *node = [self nodeAtPoint:location];
        
        // if touch was on betting buttons
        if ([node.name isEqualToString:@"playAgain"]) {
            // begin button press
            _playAgainPressed = YES;
            
        }
        else if ([node.name isEqualToString:@"mainMenu"]) {
            // begin button press
            _mainMenuPressed = YES;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        
        // get touch position
        CGPoint location = [touch locationInNode:self];
        //NSLog(@"Touch = (%f, %f)",location.x, location.y);
        SKNode *node = [self nodeAtPoint:location];
        
        // if touch was on betting buttons
        if (([node.name isEqualToString:@"playAgain"]&&_playAgainPressed)||([node.name isEqualToString:@"mainMenu"]&&_mainMenuPressed)) {
            
            //do nothing
        }
        else
        {
            _mainMenuPressed = NO;
            _playAgainPressed = NO;
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _mainMenuPressed = NO;
    _playAgainPressed = NO;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_mainMenuPressed)
    {
        // Create and configure the scene
        SKScene * titleScene = [[TitleScene alloc] initWithSize:self.size];
        
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:titleScene transition:reveal];
    }
    else if (_playAgainPressed)
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
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}


@end
