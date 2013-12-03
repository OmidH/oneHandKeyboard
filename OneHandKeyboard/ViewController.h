//
//  ViewController.h
//  OneHandKeyboard
//
//  Created by Omid Hashemi on 01.11.13.
//  Copyright (c) 2013 42dp Labs GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tcText;
@property (weak, nonatomic) IBOutlet UIPickerView *vPad;
@property (weak, nonatomic) IBOutlet UIPickerView *svThumb;
@property (weak, nonatomic) IBOutlet UIPickerView *svForefinger;
@property (weak, nonatomic) IBOutlet UIPickerView *svMiddleFinger;
@property (weak, nonatomic) IBOutlet UIPickerView *svRingFinger;
@property (weak, nonatomic) IBOutlet UIPickerView *svPinky;

@end
