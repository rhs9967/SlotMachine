//
//  Lever.h
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Lever : SKNode

@property (nonatomic) int leverWidth;
@property (nonatomic) int leverHeight;
@property (nonatomic) double distance;
@property (nonatomic) BOOL isRising;
@property (nonatomic) BOOL leverTouched;

// public instance methods
- (id) init;
- (BOOL) isPulledFar;
- (void) update;

@end
