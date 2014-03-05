//
//  SNNumeric.m
//  Synergy
//
//  Created by Panos on 12/15/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import "HKNumericCell.h"

@interface HKNumericCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UIStepper *stepper;

@end

@implementation HKNumericCell
@synthesize numField = _numField;
@synthesize stepper = _stepper;

- (UITextField *)numField
{
    if (!_numField)
    {
        self.numField = [[UITextField alloc] init];
        _numField.textAlignment = NSTextAlignmentRight;
        _numField.delegate = self;
    }
    
    return _numField;
}

- (void)setNumField:(UITextField *)textField
{
    if (_numField == textField)
    {
        return;
    }
    
    if (_numField)
    {
        [_numField removeFromSuperview];
    }
    
    _numField = textField;
    if (textField)
    {
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textField];
        UIStepper *stepper = self.stepper;
        UILabel *textLabel = self.textLabel;
        NSLayoutConstraint *left = [NSLayoutConstraint
                                    constraintWithItem:textField
                                    attribute:NSLayoutAttributeLeading
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:stepper
                                    attribute:NSLayoutAttributeRight
                                    multiplier:1.
                                    constant:8.];
        NSLayoutConstraint *right = [NSLayoutConstraint
                                     constraintWithItem:textField
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeRight
                                     multiplier:1.
                                     constant:-20.];
        NSLayoutConstraint *alignBaseline = [NSLayoutConstraint
                                             constraintWithItem:textField
                                             attribute:NSLayoutAttributeBaseline
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:textLabel
                                             attribute:NSLayoutAttributeBaseline
                                             multiplier:1.
                                             constant:0.];
        
        [self.contentView addConstraint:right];
        [self.contentView addConstraint:left];
        [self.contentView addConstraint:alignBaseline];
    }
}

- (UIStepper *)stepper
{
    if (!_stepper)
    {
        self.stepper = [[UIStepper alloc] init];
        [_stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _stepper;
}

- (void)setStepper:(UIStepper *)stepper
{
    if (_stepper == stepper)
    {
        return;
    }
    
    if (_stepper)
    {
        [_stepper removeFromSuperview];
    }
    
    _stepper = stepper;
    if (stepper)
    {
        stepper.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:stepper];
        
        UILabel *textLabel = self.textLabel;
        UITextField *numField = self.numField;
        NSLayoutConstraint *right = [NSLayoutConstraint
                                     constraintWithItem:stepper
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:numField
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1.
                                     constant:-8.];
        NSLayoutConstraint *left = [NSLayoutConstraint
                                    constraintWithItem:stepper
                                    attribute:NSLayoutAttributeLeft
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:textLabel
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.
                                    constant:8.];
        NSLayoutConstraint *centerY = [NSLayoutConstraint
                                       constraintWithItem:stepper
                                       attribute:NSLayoutAttributeCenterY
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:textLabel
                                       attribute:NSLayoutAttributeCenterY
                                       multiplier:1.
                                       constant:0.];
        [self.contentView addConstraint:right];
        [self.contentView addConstraint:left];
        [self.contentView addConstraint:centerY];
    }
}

#pragma mark — Stepper

- (void)stepperValueChanged:(UIStepper *)stepper
{
    CGFloat stepperValue = stepper.value;
    self.numField.text = @(stepperValue).description;
}

#pragma mark — Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.stepper.value = textField.text.floatValue;
    [self.stepper sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    static NSRegularExpression *s_regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
        s_regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d*$"
                                                            options:0
                                                              error:&error];
    });
    
    return [s_regex numberOfMatchesInString:string
                                    options:NSMatchingReportCompletion
                                      range:NSMakeRange(0, string.length)] > 0;
}

@end
