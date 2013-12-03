// KeyboardHandler 
// OneHandKeyboard
//
// Created by omid on 03.12.13.
// Copyright (c) 2013 42dp. All rights reserved.
//
//


#import <Foundation/Foundation.h>

enum Finger{
    thumbFinger   = 0,
    indexFinger   = 1,
    middleFinger  = 2,
    ringFinger    = 3,
    pinkyFinger   = 4
};

@interface KeyboardHandler : NSObject

+ (id)sharedHandler;

- (void)setInitialTouchPoint:(CGPoint)cgPoint;

- (enum Finger)identifyFinger:(CGPoint)cgPoint;
@end