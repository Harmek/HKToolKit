//
//  SNTextLabelCell.m
//  Synergy
//
//  Created by Panos on 12/14/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import "HKTextFieldCell.h"

@interface HKTextFieldCell ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HKTextFieldCell
@synthesize textField = _textField;

- (UITextField *)textField
{
    if (!_textField)
    {
        self.textField = [[UITextField alloc] init];
    }
    
    return _textField;
}

- (void)setTextField:(UITextField *)textField
{
    if (_textField == textField)
    {
        return;
    }
    
    if (_textField)
    {
        [_textField removeFromSuperview];
    }
    
    _textField = textField;
    if (textField)
    {
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textField];
        UILabel *textLabel = self.textLabel;
        NSLayoutConstraint *left = [NSLayoutConstraint
                                    constraintWithItem:textField
                                    attribute:NSLayoutAttributeLeading
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:textLabel
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
        
        [self.contentView addConstraint:left];
        [self.contentView addConstraint:right];
        [self.contentView addConstraint:alignBaseline];
    }
}

@end
