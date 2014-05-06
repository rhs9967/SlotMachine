//
//  Lever.h
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Lever : SKNode

@property (nonatomic) float distance;
@property (nonatomic) BOOL isLetGo;

// public instance methods
- (BOOL) isPulledFar;

@end
