//
//  Lever.m
//  Slot Machine
//
//  Created by Student on 5/6/14.
//  Copyright (c) 2014 Carl Milazzo and Bob Schrupp. All rights reserved.
//

#import "Lever.h"

@implementation Lever

-(BOOL)isPulledFar{
    if (self.distance >= 0.75) return YES;
    return NO;
}

@end
