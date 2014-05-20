//
//  TitleScene.m
//  Slot Machine
//
//  Created by Student on 5/3/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "TitleScene.h"
#import "MyScene.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
        
        // labels
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"GillSans-Bold"];
        SKLabelNode *name1Label = [SKLabelNode labelNodeWithFontNamed:@"GillSans-Bold"];
        SKLabelNode *name2Label = [SKLabelNode labelNodeWithFontNamed:@"GillSans-Bold"];
        
        // myLabel
        myLabel.text = @"Slot Machine";
        myLabel.fontName = @"BudmoJiggler-Regular";
        myLabel.fontSize = 90;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        // name1Label
        name1Label.text = @"Carl Milazzo";
        name1Label.fontName = @"BudmoJiggler-Regular";
        name1Label.fontSize = 60;
        name1Label.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)/2);
        
        // name2Label
        name2Label.text = @"Robert Schrupp";
        name2Label.fontName = @"BudmoJiggler-Regular";
        name2Label.fontSize = 60;
        name2Label.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)/3);
        
        [self addChild:myLabel];
        [self addChild:name1Label];
        [self addChild:name2Label];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        // Create and configure the scene
        SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
        
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.view presentScene:myScene transition:reveal];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
