//
//  Lever.m
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "Lever.h"

static int const kLeverWidth = 90;
static int const kLeverHeight = 300;

@implementation Lever{
    SKShapeNode *_base;
    SKShapeNode *_handle;
    SKShapeNode *_knob;
}

// public
-(id)init
{
    self = [super init];
    
    // set values
    _leverWidth = kLeverWidth;
    _leverHeight = kLeverHeight;
    _isRising = YES;
    
    // SKShapeNodes
    _base = [[SKShapeNode alloc] init];
    _handle = [[SKShapeNode alloc] init];
    _knob = [[SKShapeNode alloc] init];
    
    [self createParts];
    
    return self;
}

-(BOOL)isPulledFar{
    if (_distance/kLeverHeight >= 0.75) return YES;
    return NO;
}

-(void)update{
    if (_distance < 0 || _distance > kLeverHeight) {
        return;
    }
    // Scale up
    //_overlay.xScale = 1.5;
    //_overlay.yScale = 1.5;
    
    // move knob to touch location's .y (distance)
    double maxKnobHeight = kLeverHeight-(kLeverWidth/2);
    double newKnobHeight = maxKnobHeight - _distance;
    double knobRadius = kLeverWidth;
    double knobDistance = 0;
    
    // adjust handle height based on knob's distance from base center
    double baseCenter = maxKnobHeight/2;
    double percentChange = ((newKnobHeight-baseCenter)/(maxKnobHeight-baseCenter));
    double newHandleLength = baseCenter * percentChange + (kLeverWidth/2);
    
    // knob
    knobRadius = kLeverWidth - (percentChange*6);
    knobDistance = percentChange*3;
    
    // if knob is below center
    if (_distance > kLeverHeight/2) {
        baseCenter += (kLeverWidth/4);
        knobRadius = kLeverWidth + (percentChange*6);
        knobDistance = -percentChange*3;
    }
    
    // set new CGRects
    CGRect newKnobCircle = CGRectMake(knobDistance, newKnobHeight, knobRadius, knobRadius);
    _knob.path = [UIBezierPath bezierPathWithOvalInRect:newKnobCircle].CGPath;
    
    CGRect newHandleRect = CGRectMake(kLeverWidth/3, baseCenter, kLeverWidth/3, newHandleLength);
    _handle.path = [UIBezierPath bezierPathWithRect:newHandleRect].CGPath;
    
    // tween lever is not being touched
    if (_leverTouched == NO) {
        if (_isRising) {
            _distance -= 15;
        } /*else {
            _distance += 2;
        }*/
    }
}

// private
-(void)createParts{
    // base
    CGRect baseRect = CGRectMake(0, 0, kLeverWidth, kLeverHeight);
    _base.path = [UIBezierPath bezierPathWithRect:baseRect].CGPath;
    _base.fillColor = SKColor.grayColor;
    _base.strokeColor = SKColor.blackColor;
    
    // handle
    _handle.fillColor = SKColor.whiteColor;
    _handle.strokeColor = SKColor.blackColor;
    
    // knob
    _knob.fillColor = SKColor.redColor;
    _knob.strokeColor = SKColor.blackColor;
    
    // add children
    [self addChild:_base];
    [self addChild:_handle];
    [self addChild:_knob];
    
    // CGRects
    //CGRect baseRect = CGRectMake(0, 0, 90, 300);
    //CGRect handleRect = CGRectMake(30, 150, 30, 150);
    //CGRect knobCircle = CGRectMake(0, 275, 90, 90);
    //CGRect handleRect = CGRectMake(kLeverWidth/3, kLeverHeight/2, kLeverWidth/3, kLeverHeight/2);
    //CGRect knobCircle = CGRectMake(0, kLeverHeight-(kLeverWidth/3), kLeverWidth, kLeverWidth);
}

@end
