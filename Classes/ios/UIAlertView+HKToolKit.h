//
//  UIAlertView+HKToolKit.h
//  Pods
//
//  Created by Panos on 1/9/14.
//
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewBlock) (UIAlertView *alertView);
typedef void (^UIAlertViewButtonBlock) (UIAlertView *alertView, NSInteger buttonIndex);
typedef BOOL (^UIAlertViewReturnBoolBlock) (UIAlertView *alertView);

@interface UIAlertView (HKToolKit)

/**
 *  The block that will be called with UIAlertViewDelegate's alertView:clickedButtonAtIndex: method. Can be nil.
 */
@property (nonatomic, strong) UIAlertViewButtonBlock clickedButtonBlock;

/**
 *  The block that will be called with UIAlertViewDelegate's alertView:willDismissWithButtonIndex: method. Can be nil.
 */
@property (nonatomic, strong) UIAlertViewButtonBlock willDismissBlock;

/**
 *  The block that will be called with UIAlertViewDelegate's alertView:didDismissWithButtonIndex: method. Can be nil.
 */
@property (nonatomic, strong) UIAlertViewButtonBlock didDismissBlock;

/**
 *  The block that will be called with UIAlertViewDelegate's alertViewCancel: method. Can be nil.
 */
@property (nonatomic, strong) UIAlertViewBlock cancelBlock;

/**
 *  The block that will be called with UIAlertViewDelegate's alertViewShouldEnableFirstOtherButton method. Can be nil.
 */
@property (nonatomic, strong) UIAlertViewReturnBoolBlock shouldEnableFirstOtherButtonBlock;

/**
 *  Convenience method for initializing an alert view with blocks.
 *
 *  @param title             The string that appears in the receiver’s title bar.
 *  @param message           Descriptive text that provides more details than the title.
 *  @param cancelButtonTitle The title of the cancel button or nil if there is no cancel button.
 
 Using this argument is equivalent to setting the cancel button index to the value returned by invoking addButtonWithTitle: specifying this title.
 *  @param otherButtonTitles The titles of the other buttons.
 
 Using this argument is equivalent to invoking addButtonWithTitle: with these titles to add more buttons.
 
 Too many buttons can cause the alert view to scroll.
 *  @param clickButtonBlock  The block that will be called with UIAlertViewDelegate's alertView:clickedButtonAtIndex: method. Can be nil.
 *  @param willDismissBlock  The block that will be called with UIAlertViewDelegate's alertView:willDismissWithButtonIndex: method. Can be nil.
 *  @param didDismissBlock   The block that will be called with UIAlertViewDelegate's alertView:didDismissWithButtonIndex: method. Can be nil.
 *  @param cancelBlock       The block that will be called with UIAlertViewDelegate's alertViewCancel: method. Can be nil.
 *  @param shouldEnableBlock The block that will be called with UIAlertViewDelegate's alertViewShouldEnableFirstOtherButton method. Can be nil.
 *
 *  @return Newly initialized alert view.
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             clickButtonBlock:(UIAlertViewButtonBlock)clickButtonBlock
             willDismissBlock:(UIAlertViewButtonBlock)willDismissBlock
              didDismissBlock:(UIAlertViewButtonBlock)didDismissBlock
                  cancelBlock:(UIAlertViewBlock)cancelBlock
 shouldEnableOtherButtonBlock:(UIAlertViewReturnBoolBlock)shouldEnableBlock;

/**
 *  Convenience method for initializing an alert view with blocks.
 *
 *  @param title             The string that appears in the receiver’s title bar.
 *  @param message           Descriptive text that provides more details than the title.
 *  @param clickButtonBlock  The block that will be called with UIAlertViewDelegate's alertView:clickedButtonAtIndex: method. Can be nil.
 *  @param willDismissBlock  The block that will be called with UIAlertViewDelegate's alertView:willDismissWithButtonIndex: method. Can be nil.
 *  @param didDismissBlock   The block that will be called with UIAlertViewDelegate's alertView:didDismissWithButtonIndex: method. Can be nil.
 *  @param cancelBlock       The block that will be called with UIAlertViewDelegate's alertViewCancel: method. Can be nil.
 *  @param shouldEnableBlock The block that will be called with UIAlertViewDelegate's alertViewShouldEnableFirstOtherButton method. Can be nil.
 *  @param cancelButtonTitle The title of the cancel button or nil if there is no cancel button.
 
 Using this argument is equivalent to setting the cancel button index to the value returned by invoking addButtonWithTitle: specifying this title.
 *  @param otherButtonTitles The titles of another button.
 
 Using this argument is equivalent to invoking addButtonWithTitle: with this title to add more buttons.
 
 Too many buttons can cause the alert view to scroll.
 *
 *  @return Newly initialized alert view.
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
             clickButtonBlock:(UIAlertViewButtonBlock)clickButtonBlock
             willDismissBlock:(UIAlertViewButtonBlock)willDismissBlock
              didDismissBlock:(UIAlertViewButtonBlock)didDismissBlock
                  cancelBlock:(UIAlertViewBlock)cancelBlock
 shouldEnableOtherButtonBlock:(UIAlertViewReturnBoolBlock)shouldEnableBlock
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
