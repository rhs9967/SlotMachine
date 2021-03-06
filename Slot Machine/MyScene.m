//
//  MyScene.m
//  Slot Machine
//
//  Created by Student on 5/3/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "MyScene.h"
#import "EndScene.h"
#import "GameModel.h"
#import "Lever.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyScene{
    GameModel *_gameModel;
    
    SKSpriteNode *_overlay;
    SKSpriteNode *_background;
    
    // Betting
    SKLabelNode *_betAmount;
    SKSpriteNode *_betIncrease;
    SKSpriteNode *_betDecrease;
    
    // Winnings
    SKLabelNode *_amountLeft;
    SKLabelNode *_latestWin;
    
    AVAudioPlayer *_bgAudio;
    AVAudioPlayer *_bgAudio1;
    AVAudioPlayer *_bgAudio2;
    AVAudioPlayer *_winAudio;
    
    NSMutableArray *_reelTextures;
    
    double _lastTime;
    int _flashAmount;
    int _flasher;
    
    BOOL _leverTouched;
    BOOL _plusButtonTouched;
    BOOL _minusButtonTouched;
    BOOL _shouldFlash;
    
    SKEmitterNode *_spark1; 
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        // background color
        self.backgroundColor = [SKColor darkGrayColor];
        
        // AVAudioplayer //
        // URLs
        NSURL *bgURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"casino_bg1" ofType:@"mp3"]];
        NSURL *bgURL1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"casino_bg2" ofType:@"wav"]];
        NSURL *bgURL2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"casino_bg3" ofType:@"wav"]];
        NSURL *winURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"win1" ofType:@"mp3"]];
        
        // Players
        _bgAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:bgURL error:nil];
        _bgAudio1 = [[AVAudioPlayer alloc] initWithContentsOfURL:bgURL1 error:nil];
        _bgAudio2 = [[AVAudioPlayer alloc] initWithContentsOfURL:bgURL2 error:nil];
        _winAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:winURL error:nil];
        
        
        // continue setup
        [self setup];
        
        // register for kNotificationGameDidEnd notification
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(handleNotificationGameDidEnd:)
         name:kNotificationGameDidEnd
         object:_gameModel];
    }
    return self;
}

-(void)setup{
    
    //background
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    
    _background.position = CGPointMake(self.size.width/2,
                                       self.size.height/2);
    
    [self addChild:_background];
    
    // overlay
    _overlay = [SKSpriteNode spriteNodeWithImageNamed:@"slotmachine-symbol-overlay"];
    _overlay.position = CGPointMake(_overlay.size.width,
                                   self.size.height/2);
    // Scale up
    _overlay.xScale = 1.5;
    _overlay.yScale = 1.5;
    //add overlay
    [self addChild:_overlay];
    
    // Betting //
    // Bet Amount
    _betAmount = [SKLabelNode labelNodeWithFontNamed:@"GillSans-Bold"];
    _betAmount.fontSize = 75;
    _betAmount.position = CGPointMake(_overlay.position.x, 30);
    [self addChild:_betAmount];
    
    // Bet Increase
    _betIncrease = [SKSpriteNode spriteNodeWithImageNamed:@"bet_plus.png"];
    _betIncrease.position = CGPointMake(_betAmount.position.x + (_betIncrease.frame.size.width*1.5), _betAmount.position.y + 20);
    _betIncrease.name = @"betPlus";
    [self addChild:_betIncrease];
    
    // Bet Decrease
    _betDecrease = [SKSpriteNode spriteNodeWithImageNamed:@"bet_minus.png"];
    _betDecrease.position = CGPointMake(_betAmount.position.x - (_betDecrease.frame.size.width*1.5), _betAmount.position.y + 20);
    _betDecrease.name = @"betMinus";
    [self addChild:_betDecrease];
    
    // Amount Left
    _amountLeft = [SKLabelNode labelNodeWithFontNamed:@"GillSans-Bold"];
    _amountLeft.fontSize = 75;
    _amountLeft.position = CGPointMake(_overlay.position.x - 100, _overlay.position.y + _overlay.frame.size.height/2 + 30);
    [self addChild:_amountLeft];
    
    // Latest Win
    _latestWin = [SKLabelNode labelNodeWithFontNamed:@"GillSans-Bold"];
    _latestWin.fontSize = 75;
    _latestWin.fontColor = [SKColor greenColor];
    _latestWin.position = CGPointMake(_overlay.position.x + _overlay.frame.size.width/2, _overlay.position.y + _overlay.frame.size.height/2 + 30);
    [self addChild:_latestWin];
    _flasher = 5;
    
    // create gameModel
    _gameModel = [[GameModel alloc] init:_overlay.size :_overlay.position];
    [self addChild:_gameModel];
    
    // EmitterNodes
    _spark1 = [NSKeyedUnarchiver unarchiveObjectWithFile:
               [[NSBundle mainBundle] pathForResource:@"spark1"
                                               ofType:@"sks"]];
    _spark1.position = CGPointMake(_overlay.position.x, _overlay.position.y);
    _spark1.zPosition = 10;
    _spark1.name = @"spark1";
    //_spark1.targetNode = self->_overlay;
    [self addChild:_spark1];
    
    // play bgAudio
    // play background music
    [_bgAudio setNumberOfLoops: -1];
    [_bgAudio1 setNumberOfLoops: -1];
    [_bgAudio2 setNumberOfLoops: -1];
    //[_bgAudio play];
    [_bgAudio1 play];
    [_bgAudio2 play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        // get touch position
        CGPoint location = [touch locationInNode:self];

        SKNode *node = [self nodeAtPoint:location];
        
        // if Player Stage
        if (_gameModel.gameStage == kGameStagePlayer) {
            // inform gameModel of touch
            [_gameModel checkTouch:location :NO];
            
            // if touch was on betting buttons
            if ([node.name isEqualToString:@"betPlus"]) {
                // begin button press
                _plusButtonTouched = YES;
                _betIncrease.xScale = .9;
                _betIncrease.yScale = .9;
            } else if ([node.name isEqualToString:@"betMinus"]) {
                // begin button press
                _minusButtonTouched = YES;
                _betDecrease.xScale = .9;
                _betDecrease.yScale = .9;
            }
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
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
        SKNode *node = [self nodeAtPoint:location];
        
        // if Player Stage
        if (_gameModel.gameStage == kGameStagePlayer) {
            // inform gameModel of touch
            [_gameModel checkTouch:location :YES];
            
            // if touch was on betting buttons
            if ([node.name isEqualToString:@"betPlus"] && _plusButtonTouched) {
                // inform gameModel
                [_gameModel increaseBet];
            } else if ([node.name isEqualToString:@"betMinus"] && _minusButtonTouched) {
                // inform gameModel
                [_gameModel decreaseBet];
            }
        }
        
        // end button press
        _plusButtonTouched = NO;
        _minusButtonTouched = NO;
        
        // reset button scales
        _betIncrease.xScale = 1;
        _betIncrease.yScale = 1;
        _betDecrease.xScale = 1;
        _betDecrease.yScale = 1;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    // calculate deltaTime
    double time = (double)CFAbsoluteTimeGetCurrent();
    float dt = time - _lastTime;
    _lastTime = time;
    
    [_gameModel updateGameStage:dt];
    
    // Bet Amount
    _betAmount.text = [NSString stringWithFormat:@"$%d", _gameModel.bet];
    
    // Amount Left
    _amountLeft.text = [NSString stringWithFormat:@"Total: $%d", _gameModel.amount];
    
    // if new round begins, flash winnings
    if(_gameModel.shouldFlash){
        _flashAmount = 11;
        _flasher = 10;
        _gameModel.shouldFlash = NO;
        [self addChild:_spark1];
        [_winAudio play];
    }
    
    if (_flashAmount > 0) {
        if (_flasher <=0) {
            _latestWin.text = [NSString stringWithFormat:@"$%d", _gameModel.winnings];
            _flashAmount--;
            _flasher = 10;
        } else if (_flasher <= 6) {
            _flasher--;
            _latestWin.text = [NSString stringWithFormat:@"$%d", _gameModel.winnings];
        } else {
            _flasher--;
            _latestWin.text = @"";
        }
    } else {
        _latestWin.text = @"";
        [_spark1 removeFromParent];
    }
}



#pragma mark - Notifications
-(void) handleNotificationGameDidEnd:(NSNotification *)notification{
    // Create and configure the scene
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *nextScene = [SKAction runBlock:^{
        SKScene * endScene = [[EndScene alloc] initWithSize:self.size score:_gameModel.amount];
        
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:endScene transition:reveal];
    }];
    
    SKAction *sequence = [SKAction sequence:@[wait, nextScene]];
    
    [self runAction:sequence];
}

@end
