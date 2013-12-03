// KeyboardHandler 
// OneHandKeyboard
//
// Created by omid on 03.12.13.
// Copyright (c) 2013 42dp. All rights reserved.
//
//


#import "KeyboardHandler.h"


@implementation KeyboardHandler {
    NSMutableArray *arrInitialFingerPoints;
}

#pragma mark Singleton Methods

+ (id)sharedHandler {
    static KeyboardHandler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        arrInitialFingerPoints = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark Methods

-(void)setInitialTouchPoint:(CGPoint)cgPoint {
    //TODO: check if point is already in Array
    NSValue *value = [NSValue valueWithCGPoint:cgPoint];

    [arrInitialFingerPoints addObject:value];
    [arrInitialFingerPoints sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGPoint cgPoint1 = [(NSValue *)obj1 CGPointValue];
        CGPoint cgPoint2 = [(NSValue *)obj2 CGPointValue];

        CGPoint diff = CGPointDiffToPoint(cgPoint1,cgPoint2);

        if(diff.x < 0)
            return NSOrderedAscending;
        else if(diff.x > 0)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
}

-(enum Finger)identifyFinger:(CGPoint)cgPoint {

    enum Finger theFinger = thumbFinger;
    CGFloat lastDiff = INT32_MAX;

    for (int x = 0; x < arrInitialFingerPoints.count; x++) {
        CGPoint anInitialFingerPoint = [(NSValue *)arrInitialFingerPoints[x] CGPointValue];
        CGPoint diff = CGPointDiffToPoint(cgPoint, anInitialFingerPoint);
        if(ABS(diff.x) < lastDiff) {
            lastDiff = ABS(diff.x);
            theFinger = (enum Finger) x;
        }
    }

    return theFinger;
}


@end