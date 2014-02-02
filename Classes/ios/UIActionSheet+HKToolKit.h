//
//  UIActionSheet+HKTargetActionBlock.h
//  Pods
//
//  Created by Panos on 1/5/14.
//
//

#import <UIKit/UIKit.h>

typedef void (^UIActionSheetBlock) (UIActionSheet *actionSheet);
typedef void (^UIActionSheetButtonBlock) (UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (HKToolKit)

/**
 *  The block that will be called with UIActionSheetDelegate's actionSheet:clickedButtonAtIndex: method. Can be nil.
 */
@property (nonatomic, strong) UIActionSheetButtonBlock clickedButtonBlock;

/**
 *  The block that will be called with UIActionSheetDelegate's actionSheet:willDismissWithButtonIndex: method. Can be nil.
 */
@property (nonatomic, strong) UIActionSheetButtonBlock willDismissBlock;

/**
 *  The block that will be called with UIActionSheetDelegate's actionSheet:didDismissWithButtonIndex: method. Can be nil.
 */
@property (nonatomic, strong) UIActionSheetButtonBlock didDismissBlock;

/**
 *  The block that will be called with UIActionSheetDelegate's actionSheetCancel: method. Can be nil.
 */
@property (nonatomic, strong) UIActionSheetBlock cancelBlock;

/**
 *  Initializes the action sheet using the specified starting parameters. Instead of providing a delegate, you can provide a block for each UIActionSheetDelegate callback.
 *
 *  @param title                  A string to display in the title area of the action sheet. Pass nil if you do not want to display any text in the title area.
 *  @param clickedBlock           The block that will be called with UIActionSheetDelegate's actionSheet:clickedButtonAtIndex: method. Can be nil.
 *  @param willDismissBlock       The block that will be called with UIActionSheetDelegate's willDismissWithButtonIndex: method. Can be nil.
 *  @param didDismissBlock        The block that will be called with UIActionSheetDelegate's didDismissWithButtonIndex: method. Can be nil.
 *  @param cancelBlock            The block that will be called with UIActionSheetDelegate's actionSheetCancel: method. Can be nil.
 *  @param cancelButtonTitle      The title of the cancel button. This button is added to the action sheet automatically and assigned an appropriate index, which is available from the cancelButtonIndex property. This button is displayed in black to indicate that it represents the cancel action. Specify nil if you do not want a cancel button or are presenting the action sheet on an iPad.
 *  @param destructiveButtonTitle The title of the destructive button. This button is added to the action sheet automatically and assigned an appropriate index, which is available from the destructiveButtonIndex property. This button is displayed in red to indicate that it represents a destructive behavior. Specify nil if you do not want a destructive button.
 *  @param otherButtonTitles      The titles of any additional buttons you want to add. This parameter consists of a nil-terminated, comma-separated list of strings. For example, to specify two additional buttons, you could specify the value @"Button 1", @"Button 2", nil.
 *
 *  @return A newly initialized action sheet.
 */
- (instancetype)initWithTitle:(NSString *)title
                 clickedBlock:(UIActionSheetButtonBlock)clickedBlock
             willDismissBlock:(UIActionSheetButtonBlock)willDismissBlock
              didDismissBlock:(UIActionSheetButtonBlock)didDismissBlock
                  cancelBlock:(UIActionSheetBlock)cancelBlock
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  Initializes the action sheet using the specified starting parameters. Instead of providing a delegate, you can provide a block for each UIActionSheetDelegate callback.
 *
 *  @param title                  A string to display in the title area of the action sheet. Pass nil if you do not want to display any text in the title area.
 *  @param cancelButtonTitle      The title of the cancel button. This button is added to the action sheet automatically and assigned an appropriate index, which is available from the cancelButtonIndex property. This button is displayed in black to indicate that it represents the cancel action. Specify nil if you do not want a cancel button or are presenting the action sheet on an iPad.
 *  @param destructiveButtonTitle The title of the destructive button. This button is added to the action sheet automatically and assigned an appropriate index, which is available from the destructiveButtonIndex property. This button is displayed in red to indicate that it represents a destructive behavior. Specify nil if you do not want a destructive button.
 *  @param otherButtonTitles      The titles of any additional buttons you want to add as an array of strings.
 *  @param clickedBlock           The block that will be called with UIActionSheetDelegate's actionSheet:clickedButtonAtIndex: method. Can be nil.
 *  @param willDismissBlock       The block that will be called with UIActionSheetDelegate's willDismissWithButtonIndex: method. Can be nil.
 *  @param didDismissBlock        The block that will be called with UIActionSheetDelegate's didDismissWithButtonIndex: method. Can be nil.
 *  @param cancelBlock            The block that will be called with UIActionSheetDelegate's actionSheetCancel: method. Can be nil.
 *
 *  @return A newly initialized action sheet.
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                 clickedBlock:(UIActionSheetButtonBlock)clickedBlock
             willDismissBlock:(UIActionSheetButtonBlock)willDismissBlock
              didDismissBlock:(UIActionSheetButtonBlock)didDismissBlock
                  cancelBlock:(UIActionSheetBlock)cancelBlock;

@end
