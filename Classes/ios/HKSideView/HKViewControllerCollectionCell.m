//
//  HKViewControllerCollectionCell.m
//  Pods
//
//  Created by Panos Baroudjian on 4/12/14.
//
//

#import "HKViewControllerCollectionCell.h"

@interface HKViewControllerCollectionCell ()

@property (nonatomic, strong) UIView *viewControllerView;

@end

@implementation HKViewControllerCollectionCell

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (_contentViewController == contentViewController)
    {
        return;
    }

    if (_contentViewController)
    {
        [_contentViewController removeFromParentViewController];
        self.viewControllerView = nil;
    }

    _contentViewController = contentViewController;
    self.viewControllerView = contentViewController.view;
}

- (void)setViewControllerView:(UIView *)viewControllerView
{
    if (_viewControllerView == viewControllerView)
    {
        return;
    }

    [_viewControllerView removeFromSuperview];

    _viewControllerView = viewControllerView;
    if (viewControllerView)
    {
        static NSString * const s_verticalFormat = @"V:|[viewControllerView]|";
        static NSString * const s_horizontalFormat = @"H:|[viewControllerView]|";

        viewControllerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:viewControllerView];
        UIEdgeInsets insets = self.contentViewControllerInsets;
        NSDictionary *metrics = @{
                                  @"top" : @(insets.top),
                                  @"left" : @(insets.left),
                                  @"bottom" : @(insets.bottom),
                                  @"right" : @(insets.right)
                                  };
        NSDictionary *bindings = NSDictionaryOfVariableBindings(viewControllerView);
        NSArray *vertical = [NSLayoutConstraint
                             constraintsWithVisualFormat:s_verticalFormat
                             options:0
                             metrics:metrics
                             views:bindings];
        NSArray *horizontal = [NSLayoutConstraint
                               constraintsWithVisualFormat:s_horizontalFormat
                               options:0
                               metrics:metrics
                               views:bindings];
        [self.contentView addConstraints:vertical];
        [self.contentView addConstraints:horizontal];
    }
}

- (void)setContentViewControllerInsets:(UIEdgeInsets)contentViewControllerInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(contentViewControllerInsets, _contentViewControllerInsets))
    {
        return;
    }

    _contentViewControllerInsets = contentViewControllerInsets;
    UIViewController *contentViewController = self.contentViewController;
    self.contentViewController = nil;
    self.contentViewController = contentViewController;
}

@end
