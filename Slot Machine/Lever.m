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
    if (_distance/_leverHeight >= 0.75) return YES;
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
    //CGRect handleRect = CGRectMake(_leverWidth/3, _leverHeight/2, _leverWidth/3, _leverHeight/2);
    //CGRect knobCircle = CGRectMake(0, _leverHeight-(_leverWidth/3), _leverWidth, _leverWidth);
    
    // base
    _base = [[SKShapeNode alloc] init];
    _base.path = [UIBezierPath bezierPathWithRect:baseRect].CGPath;
    _base.fillColor = SKColor.grayColor;
    _base.strokeColor = SKColor.blackColor;
    
    // handle
    _handle = [[SKShapeNode alloc] init];
    //_handle.path = [UIBezierPath bezierPathWithRect:handleRect].CGPath;
    _handle.fillColor = SKColor.whiteColor;
    _handle.strokeColor = SKColor.blackColor;
    
    // knob
    _knob = [[SKShapeNode alloc] init];
    //_knob.path = [UIBezierPath bezierPathWithOvalInRect:knobCircle].CGPath;
    _knob.fillColor = SKColor.redColor;
    _knob.strokeColor = SKColor.blackColor;
    
    // add children
    [self addChild:_base];
    [self addChild:_handle];
    [self addChild:_knob];
    
}

-(void)update{
    if (_distance < 0) {
        return;
    }
    // Scale up
    //_overlay.xScale = 1.5;
    //_overlay.yScale = 1.5;
    
    // move knob to touch location's .y (distance)
    double maxKnobHeight = _leverHeight-(_leverWidth/2);
    double newKnobHeight = maxKnobHeight - _distance;
    double knobRadius = _leverWidth;
    double knobDistance = 0;
    
    // adjust handle height based on knob's distance from base center
    double baseCenter = maxKnobHeight/2;
    double percentChange = ((newKnobHeight-baseCenter)/(maxKnobHeight-baseCenter));
    double newHandleLength = baseCenter * percentChange + (_leverWidth/2);
    
    // knob
    knobRadius = _leverWidth - (percentChange*6);
    knobDistance = percentChange*3;
    
    // if knob is below center
    if (_distance > _leverHeight/2) {
        baseCenter += (_leverWidth/4);
        knobRadius = _leverWidth + (percentChange*6);
        knobDistance = -percentChange*3;
    }
    
    //NSLog(@"distance: %f",_distance);
    
    // set new CGRects
    CGRect newKnobCircle = CGRectMake(knobDistance, newKnobHeight, knobRadius, knobRadius);
    _knob.path = [UIBezierPath bezierPathWithOvalInRect:newKnobCircle].CGPath;
    
    CGRect newHandleRect = CGRectMake(_leverWidth/3, baseCenter, _leverWidth/3, newHandleLength);
    _handle.path = [UIBezierPath bezierPathWithRect:newHandleRect].CGPath;
}

@end
