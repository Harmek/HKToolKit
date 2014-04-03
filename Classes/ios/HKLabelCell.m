//
//  SNLabelCell.m
//  Synergy
//
//  Created by Panos on 12/15/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import "HKLabelCell.h"

@interface HKLabelCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HKLabelCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;

+ (UIFont *)textDefaultFont
{
    static UIFont *s_font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    });
    
    return s_font;
}

+ (UIFont *)detailTextDefaultFont
{
    static UIFont *s_font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    });
    
    return s_font;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        self.imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _imageView;
}

- (void)setImageView:(UIImageView *)imageView
{
    if (_imageView == imageView)
    {
        return;
    }

    if (_imageView)
    {
        [_imageView removeFromSuperview];
    }

    _imageView = imageView;
    if (imageView)
    {
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:imageView];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(imageView);
        NSArray *vertical = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:|-5-[imageView]-5-|"
                             options:0
                             metrics:nil
                             views:bindings];
        NSArray *horizontal = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-5-[imageView]"
                               options:0
                               metrics:nil
                               views:bindings];
        [self.contentView addConstraints:vertical];
        [self.contentView addConstraints:horizontal];
        if (self.imageViewMaxWidth > .0)
        {
            NSLayoutConstraint *maxWidth = [NSLayoutConstraint
                                            constraintWithItem:imageView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                            toItem:nil
                                            attribute:NSLayoutAttributeNotAnAttribute
                                            multiplier:1.
                                            constant:self.imageViewMaxWidth];
            [self.contentView addConstraint:maxWidth];
        }
    }
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [HKLabelCell textDefaultFont];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _textLabel;
}

- (void)setTextLabel:(UILabel *)textLabel
{
    if (_textLabel == textLabel)
    {
        return;
    }
    
    if (_textLabel)
    {
        [_textLabel removeFromSuperview];
    }
    
    _textLabel = textLabel;
    if (textLabel)
    {
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textLabel];
        
        NSArray *constraints = nil;
        switch (self.detailStyle)
        {
            case HKLabelCellDetailStyleRight:
            {
                constraints = [self constraintsForRightTextLabel:textLabel];
                
                break;
            }
            case HKLabelCellDetailStyleSubtitle:
            {
                constraints = [self constraintsForSubtitleTextLabel:textLabel];
                
                break;
            }
            default:
                break;
        }
        [self.contentView addConstraints:constraints];
        [textLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                     forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (UILabel *)detailTextLabel
{
    if (!_detailTextLabel)
    {
        static const NSTextAlignment s_textAlignments[SNLabelCellDetailStyleCount] =
        {
            NSTextAlignmentRight,
            NSTextAlignmentCenter
        };
        
        self.detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [HKLabelCell detailTextDefaultFont];
        _detailTextLabel.textAlignment = s_textAlignments[self.detailStyle];
    }
    
    return _detailTextLabel;
}

- (void)setDetailTextLabel:(UILabel *)detailTextLabel
{
    if (_detailTextLabel == detailTextLabel)
    {
        return;
    }
    
    if (_detailTextLabel)
    {
        [_detailTextLabel removeFromSuperview];
    }
    
    _detailTextLabel = detailTextLabel;
    if (detailTextLabel)
    {
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:detailTextLabel];
        NSArray *constraints = nil;
        switch (self.detailStyle)
        {
            case HKLabelCellDetailStyleRight:
            {
                constraints = [self constraintsForRightDetailLabel:detailTextLabel];
                
                break;
            }
            case HKLabelCellDetailStyleSubtitle:
            {
                constraints = [self constraintsForSubtitleDetailLabel:detailTextLabel];
                
                break;
            }
            default:
                break;
        }
        [self.contentView addConstraints:constraints];
        [detailTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                           forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (NSArray *)constraintsForRightTextLabel:(UILabel *)textLabel
{
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:textLabel
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.contentView
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.
                                   constant:0.];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:textLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.imageView
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1.
                                   constant:8.];

    return @[centerY, leading];
}

- (NSArray *)constraintsForSubtitleTextLabel:(UILabel *)textLabel
{
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:textLabel
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.contentView
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.
                                   constant:-4.];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:textLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.imageView
                                   attribute:NSLayoutAttributeLeft
                                   multiplier:1.
                                   constant:20.];
    
    return @[centerY, leading];
}

- (NSArray *)constraintsForRightDetailLabel:(UILabel *)detailLabel
{
    UILabel *textLabel = self.textLabel;
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:detailLabel
                                   attribute:NSLayoutAttributeBaseline
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:textLabel
                                   attribute:NSLayoutAttributeBaseline
                                   multiplier:1.
                                   constant:0.];
//    NSLayoutConstraint *left = [NSLayoutConstraint
//                                constraintWithItem:detailLabel
//                                attribute:NSLayoutAttributeLeading
//                                relatedBy:NSLayoutRelationEqual
//                                toItem:textLabel
//                                attribute:NSLayoutAttributeLeading
//                                multiplier:1.
//                                constant:8.];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:detailLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1.
                                 constant:-8.];
    
    return @[centerY, right];
}

- (NSArray *)constraintsForSubtitleDetailLabel:(UILabel *)detailLabel
{
    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:detailLabel
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.contentView
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1.
                                   constant:4.];
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:detailLabel
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.imageView
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.
                                constant:20.];
    
    return @[centerY, left];
}

@end
