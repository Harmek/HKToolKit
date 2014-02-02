//
//  UIAlertView+HKToolKit.m
//  Pods
//
//  Created by Panos on 1/9/14.
//
//

#import "UIAlertView+HKToolKit.h"
#import <objc/runtime.h>

static const void *HKAlertViewDelegateKey = &HKAlertViewDelegateKey;

@interface HKAlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertViewButtonBlock clickedButtonBlock;
@property (nonatomic, strong) UIAlertViewButtonBlock didDismissBlock;
@property (nonatomic, strong) UIAlertViewButtonBlock willDismissBlock;
@property (nonatomic, strong) UIAlertViewBlock cancelBlock;
@property (nonatomic, strong) UIAlertViewReturnBoolBlock shouldEnableBlock;

@end

@implementation HKAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickedButtonBlock)
    {
        self.clickedButtonBlock(alertView, buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissBlock)
    {
        self.didDismissBlock(alertView, buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissBlock)
    {
        self.willDismissBlock(alertView, buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (self.cancelBlock)
    {
        self.cancelBlock(alertView);
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (self.shouldEnableBlock)
    {
        return self.shouldEnableBlock(alertView);
    }
    
    return YES;
}

@end

@implementation UIAlertView (HKToolKit)

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             clickButtonBlock:(UIAlertViewButtonBlock)clickButtonBlock
             willDismissBlock:(UIAlertViewButtonBlock)willDismissBlock
              didDismissBlock:(UIAlertViewButtonBlock)didDismissBlock
                  cancelBlock:(UIAlertViewBlock)cancelBlock
 shouldEnableOtherButtonBlock:(UIAlertViewReturnBoolBlock)shouldEnableBlock
{
    self = [self initWithTitle:title
                       message:message
                      delegate:nil
             cancelButtonTitle:nil
             otherButtonTitles:nil];
    if (self)
    {
        [otherButtonTitles
         enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop)
         {
             [self addButtonWithTitle:title];
         }];
        if (cancelButtonTitle)
        {
            self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
        }

        self.blockDelegate.clickedButtonBlock = clickButtonBlock;
        self.blockDelegate.willDismissBlock = willDismissBlock;
        self.blockDelegate.didDismissBlock = didDismissBlock;
        self.blockDelegate.cancelBlock = cancelBlock;
        self.blockDelegate.shouldEnableBlock = shouldEnableBlock;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
             clickButtonBlock:(UIAlertViewButtonBlock)clickButtonBlock
             willDismissBlock:(UIAlertViewButtonBlock)willDismissBlock
              didDismissBlock:(UIAlertViewButtonBlock)didDismissBlock
                  cancelBlock:(UIAlertViewBlock)cancelBlock
 shouldEnableOtherButtonBlock:(UIAlertViewReturnBoolBlock)shouldEnableBlock
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithTitle:title
                       message:message
                      delegate:nil
             cancelButtonTitle:nil
             otherButtonTitles:nil];
    if (self)
    {
        va_list otherButtonTitlesList;
        va_start(otherButtonTitlesList, otherButtonTitles);
        for (NSString *otherButtonTitle = otherButtonTitles;
             !!otherButtonTitle;
             otherButtonTitle = va_arg(otherButtonTitlesList, NSString *))
        {
            [self addButtonWithTitle:otherButtonTitle];
        }
        va_end(otherButtonTitlesList);

        if (cancelButtonTitle)
        {
            self.cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
        }
    }
    
    return self;
}

- (HKAlertViewDelegate *)blockDelegate
{
    if (!self.delegate || ![self.delegate isKindOfClass:[HKAlertViewDelegate class]])
    {
        HKAlertViewDelegate *delegate = [[HKAlertViewDelegate alloc] init];
        objc_setAssociatedObject(self,
                                 HKAlertViewDelegateKey,
                                 delegate,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
    }
    
    return self.delegate;
}

- (void)setClickedButtonBlock:(UIAlertViewButtonBlock)clickedButtonBlock
{
    self.blockDelegate.clickedButtonBlock = clickedButtonBlock;
}

- (void)setWillDismissBlock:(UIAlertViewButtonBlock)willDismissBlock
{
    self.blockDelegate.willDismissBlock = willDismissBlock;
}

- (void)setDidDismissBlock:(UIAlertViewButtonBlock)didDismissBlock
{
    self.blockDelegate.didDismissBlock = didDismissBlock;
}

- (void)setCancelBlock:(UIAlertViewBlock)cancelBlock
{
    self.blockDelegate.cancelBlock = cancelBlock;
}

- (void)setShouldEnableFirstOtherButtonBlock:(UIAlertViewReturnBoolBlock)shouldEnableFirstOtherButtonBlock
{
    self.blockDelegate.shouldEnableBlock = shouldEnableFirstOtherButtonBlock;
}

- (UIAlertViewButtonBlock)clickedButtonBlock
{
    return self.blockDelegate.clickedButtonBlock;
}

- (UIAlertViewButtonBlock)willDismissBlock
{
    return self.blockDelegate.willDismissBlock;
}

- (UIAlertViewButtonBlock)didDismissBlock
{
    return self.blockDelegate.didDismissBlock;
}

- (UIAlertViewBlock)cancelBlock
{
    return self.blockDelegate.cancelBlock;
}

- (UIAlertViewReturnBoolBlock)shouldEnableFirstOtherButtonBlock
{
    return self.blockDelegate.shouldEnableBlock;
}

@end
