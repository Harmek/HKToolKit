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
        s_font = [UIFont boldSystemFontOfSize:17.];
    });

    return s_font;
}

+ (UIFont *)detailTextDefaultFont
{
    static UIFont *s_font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_font = [UIFont systemFontOfSize:14.];
    });

    return s_font;
}

- (void)setDetailStyle:(HKLabelCellDetailStyle)detailStyle
{
    if (_detailStyle == detailStyle)
    {
        return;
    }

    _detailStyle = detailStyle;
    UILabel *textLabel = self.textLabel;
    UILabel *detailTextLabel = self.detailTextLabel;
    self.textLabel = nil;
    self.detailTextLabel = nil;
    self.textLabel = textLabel;
    self.detailTextLabel = detailTextLabel;
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
        static const NSTextAlignment s_textAlignments[HKLabelCellDetailStyleCount] =
        {
            NSTextAlignmentLeft,
            NSTextAlignmentRight,
            NSTextAlignmentLeft
        };

        textLabel.textAlignment = s_textAlignments[self.detailStyle];
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
            case HKLabelCellDetailStyleLeft:
            {
                constraints = [self constraintsForLeftTextLabel:textLabel];

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
        //        [textLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
        //                                     forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (UILabel *)detailTextLabel
{
    if (!_detailTextLabel)
    {
        self.detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [HKLabelCell detailTextDefaultFont];
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
        static const NSTextAlignment s_textAlignments[HKLabelCellDetailStyleCount] =
        {
            NSTextAlignmentRight,
            NSTextAlignmentLeft,
            NSTextAlignmentLeft
        };

        detailTextLabel.textAlignment = s_textAlignments[self.detailStyle];
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
            case HKLabelCellDetailStyleLeft:
            {
                constraints = [self constraintsForLeftDetailLabel:detailTextLabel];

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
        //        [detailTextLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
        //                                           forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (NSArray *)constraintsForLeftTextLabel:(UILabel *)textLabel
{

    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:textLabel
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:textLabel.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.
                               constant:5.];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:textLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.imageView
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1.
                                   constant:10.];

    return @[top, leading];
}

- (NSArray *)constraintsForRightTextLabel:(UILabel *)textLabel
{

    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:textLabel
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:textLabel.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.
                               constant:5.];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:textLabel
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:textLabel.superview
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.
                                  constant:-5.];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:textLabel
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.imageView
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1.
                                   constant:8.];
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:textLabel
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                 toItem:textLabel.superview
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:.5
                                 constant:.0];
    //    leading.priority = UILayoutPriorityRequired;

    return @[top, bottom, leading, width];
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
                                   constant:10.];
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:textLabel
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:textLabel.superview
                                    attribute:NSLayoutAttributeRight
                                    multiplier:1.
                                    constant:-10.];

    return @[centerY, leading, trailing];
}

- (NSArray *)constraintsForLeftDetailLabel:(UILabel *)detailLabel
{
    UILabel *textLabel = self.textLabel;
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:detailLabel
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:detailLabel.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.
                               constant:5.];
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:detailLabel
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                toItem:textLabel
                                attribute:NSLayoutAttributeRight
                                multiplier:1.
                                constant:8.];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:detailLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:detailLabel.superview
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1.
                                 constant:-8.];
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:detailLabel
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:detailLabel.superview
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:.6
                                 constant:.0];

    return @[top, left, right, width];
}

- (NSArray *)constraintsForRightDetailLabel:(UILabel *)detailLabel
{
    UILabel *textLabel = self.textLabel;
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:detailLabel
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:detailLabel.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.
                               constant:5.];
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:detailLabel
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:detailLabel.superview
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.
                                  constant:-5.];
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:detailLabel
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationGreaterThanOrEqual
                                toItem:textLabel
                                attribute:NSLayoutAttributeRight
                                multiplier:1.
                                constant:8.];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:detailLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1.
                                 constant:-8.];
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:detailLabel
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                 toItem:detailLabel.superview
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:.5
                                 constant:.0];
    return @[top, left, bottom, right, width];
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
                                constant:10.];
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:detailLabel
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:detailLabel.superview
                                    attribute:NSLayoutAttributeRight
                                    multiplier:1.
                                    constant:-10.];
    
    return @[centerY, left, trailing];
}

@end
