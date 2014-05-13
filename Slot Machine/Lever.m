//
//  Lever.m
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "Lever.h"

@implementation Lever{
    SKShapeNode *_base;
    SKShapeNode *_handle;
    SKShapeNode *_knob;
}

// public methods //
-(BOOL)isWithinBounds:(CGPoint)touch{
    // check x
    //if (touch.x <= ) {
    //    <#statements#>
    //}
    return NO;
}

-(BOOL)isPulledFar{
    if (self.distance >= 0.75) return YES;
    return NO;
}

-(void)createParts:(double)width :(double)height{
    // Properties
    _leverWidth = width;
    _leverHeight = height;
    
    // CGRects
    //CGRect baseRect = CGRectMake(0, 0, 90, 300);
    //CGRect handleRect = CGRectMake(30, 150, 30, 150);
    //CGRect knobCircle = CGRectMake(0, 275, 90, 90);
    
    CGRect baseRect = CGRectMake(0, 0, _leverWidth, _leverHeight);
    CGRect handleRect = CGRectMake(_leverWidth/3, _leverHeight/2, _leverWidth/3, _leverHeight/2);
    CGRect knobCircle = CGRectMake(0, _leverHeight-(_leverWidth/3), _leverWidth, _leverWidth);
    
    // base
    _base = [[SKShapeNode alloc] init];
    _base.path = [UIBezierPath bezierPathWithRect:baseRect].CGPath;
    _base.fillColor = SKColor.grayColor;
    _base.strokeColor = SKColor.blackColor;
    
    // handle
    _handle = [[SKShapeNode alloc] init];
    _handle.path = [UIBezierPath bezierPathWithRect:handleRect].CGPath;
    _handle.fillColor = SKColor.whiteColor;
    _handle.strokeColor = SKColor.blackColor;
    
    // knob
    _knob = [[SKShapeNode alloc] init];
    _knob.path = [UIBezierPath bezierPathWithOvalInRect:knobCircle].CGPath;
    _knob.fillColor = SKColor.redColor;
    _knob.strokeColor = SKColor.blackColor;
    
    // add children
    [self addChild:_base];
    [self addChild:_handle];
    [self addChild:_knob];
    
}

-(void)update{
    // knob //
    // move knob to touch location's .y (distance)
    double newKnobHeight = (_leverHeight-(_leverWidth/3)) - _distance;
    // set new CGRect
    CGRect newKnobCircle = CGRectMake(0, newKnobHeight, _leverWidth, _leverWidth);
    _knob.path = [UIBezierPath bezierPathWithRect:newKnobCircle].CGPath;
    
    // handle //
    // adjust handle height based on knob's distance from base center
    double maxKnobHeight = _leverHeight-(_leverWidth/3);
    double baseCenter = _leverHeight/2;
    double newHandleLength;
    // if knob is above center
    if (newKnobHeight >= baseCenter) {
        newHandleLength = baseCenter * ((newKnobHeight-baseCenter)/(maxKnobHeight-baseCenter));
    }
}

@end
