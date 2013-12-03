//
//  ViewController.m
//  OneHandKeyboard
//
//  Created by Omid Hashemi on 01.11.13.
//  Copyright (c) 2013 42dp Labs GmbH. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardLayout.h"
#import "KeyboardHandler.h"


@interface ViewController ()

@end

@implementation ViewController  {
    CGPoint mostLeftTouch, previousTouchPosition;
    BOOL isInInitMode;
    int fingerCount;

    NSArray *activeKeySet;
    enum Finger activeFinger;
    BOOL fingerDetermined;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isInInitMode = YES;
    mostLeftTouch = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view setMultipleTouchEnabled:YES];
    self.vPad.layer.cornerRadius = 5;
    fingerCount = 0;
    previousTouchPosition = CGPointZero;

    activeKeySet = [KeyboardLayout thumb];
    activeFinger = thumbFinger;
    fingerDetermined = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if(isInInitMode) {
        NSLog(@"%s: init fingers:%d",__PRETTY_FUNCTION__, touches.count);

        // Enumerate over all the touches and draw a red dot on the screen where the touches were
        [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            // Get a single touch and it's location
            UITouch *touch = obj;
            CGPoint touchPoint = [touch locationInView:self.view];
            // Draw a red circle where the touch occurred
            UIView *touchView = [[UIView alloc] init];
            [touchView setBackgroundColor:[UIColor redColor]];
            touchView.frame = CGRectMake(touchPoint.x, touchPoint.y, 30, 30);
            touchView.layer.cornerRadius = 15;
            [self.view addSubview:touchView];

            [[KeyboardHandler sharedHandler] setInitialTouchPoint:touchPoint];

        }];
        
        fingerCount += touches.count;
        
        if(fingerCount >= 5)
            isInInitMode = NO;
    } else {
    
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        if([self changeKeyboardLayout:touchPoint]) {
            [UIView animateWithDuration:.15
                                  delay:0
                                options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _vPad.frame = CGRectMake(touchPoint.x, touchPoint.y - _vPad.bounds.size.height, _vPad.bounds.size.width, _vPad.bounds.size.height);
                             } completion:nil];
            [_vPad selectRow:0 inComponent:0 animated:YES];
        } else {
            //iterate through the chars
            int selectedRow = [_vPad selectedRowInComponent:0];
            //NSLog(@"%d != %d", (selectedRow++%activeKeySet.count), (++selectedRow%activeKeySet.count));
//            if(selectedRow == activeKeySet.count)
//                selectedRow = 0;
            [_vPad selectRow:(++selectedRow%activeKeySet.count) inComponent:0 animated:YES];
        }
        fingerDetermined = YES;
    }
    
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//
//    if(fingerDetermined) {
//        NSLog(@"%s",__PRETTY_FUNCTION__);
//        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
//        CGPoint diff = CGPointDiffToPoint(touchPoint, previousTouchPosition);
//        int selectedRow = [_vPad selectedRowInComponent:0];
//        if(diff.y > 0) {
//            [_vPad selectRow:selectedRow+1 inComponent:0 animated:YES];
//        } else {
//            [_vPad selectRow:selectedRow-1 inComponent:0 animated:YES];
//        }
//
//        previousTouchPosition = touchPoint;
//        fingerDetermined = NO;
//    }
//
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//
////    [self forceRepositionPad:touches];
//    NSLog(@"%s",__PRETTY_FUNCTION__);
//
//}

#pragma mark - UIPickerDelegates

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return activeKeySet.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return @"A";
    return [activeKeySet objectAtIndex:row];
}

#pragma mark - Methods

- (BOOL)changeKeyboardLayout:(CGPoint)touchPoint {
    enum Finger theFinger = [[KeyboardHandler sharedHandler] identifyFinger:touchPoint];
    NSLog(@"theFinger: %d", theFinger);

    if(theFinger == activeFinger)
        return NO;

    switch (theFinger) {

        case thumbFinger:
            activeKeySet = [KeyboardLayout thumb];
            break;
        case indexFinger:
            activeKeySet = [KeyboardLayout index];
            break;
        case middleFinger:
            activeKeySet = [KeyboardLayout middle];
            break;
        case ringFinger:
            activeKeySet = [KeyboardLayout ring];
            break;
        case pinkyFinger:
            activeKeySet = [KeyboardLayout pinky];
            break;
    }

    activeFinger = theFinger;
    [_vPad reloadAllComponents];
    return YES;
}

- (void)repositionPad:(NSSet *)set {
    
    int numOfTouches = set.count;
    
    if (numOfTouches == 0) {
        mostLeftTouch = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
        return;
    }
    
    
    for (UITouch *touch in set) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if (touchPoint.x < mostLeftTouch.x)   {
            NSLog(@"new:%@ - old:%@", NSStringFromCGPoint(touchPoint), NSStringFromCGPoint(mostLeftTouch));
            mostLeftTouch = touchPoint;
        }
    }
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         float newX = mostLeftTouch.x - (_svThumb.frame.origin.x + _svThumb.frame.size.width/2);
                         float newY = mostLeftTouch.y + (_svThumb.frame.origin.y - _svThumb.frame.size.height/2);
                         
                         _vPad.frame = CGRectMake(newX,newY, _vPad.bounds.size.width, _vPad.bounds.size.height);
                     } completion:nil];
    
}

- (void)forceRepositionPad:(NSSet *)set {
    mostLeftTouch = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [self repositionPad:set];
}


@end
