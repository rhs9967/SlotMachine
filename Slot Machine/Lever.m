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
-(BOOL)isPulledFar{
    if (self.distance >= 0.75) return YES;
    return NO;
}

-(void)createParts{
    // CGRects
    CGRect baseRect = CGRectMake(0, 0, 30, 100);
    CGRect handleRect = CGRectMake(10, 50, 10, 50);
    CGRect knobCircle = CGRectMake(0, 100, 30, 30);
    
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

@end
