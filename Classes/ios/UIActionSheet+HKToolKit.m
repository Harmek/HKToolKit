//
//  UIActionSheet+HKTargetActionBlock.m
//  Pods
//
//  Created by Panos on 1/5/14.
//
//

#import "UIActionSheet+HKToolKit.h"
#import <objc/runtime.h>

static const void *HKActionSheetDelegateKey = &HKActionSheetDelegateKey;

@interface HKActionSheetDelegate : NSObject<UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheetButtonBlock clickedButtonBlock;
@property (nonatomic, strong) UIActionSheetButtonBlock didDismissBlock;
@property (nonatomic, strong) UIActionSheetButtonBlock willDismissBlock;
@property (nonatomic, strong) UIActionSheetBlock cancelBlock;

@end

@implementation HKActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickedButtonBlock)
    {
        self.clickedButtonBlock(actionSheet, buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissBlock)
    {
        self.didDismissBlock(actionSheet, buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissBlock)
    {
        self.willDismissBlock(actionSheet, buttonIndex);
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    if (self.cancelBlock)
    {
        self.cancelBlock(actionSheet);
    }
}

@end

@implementation UIActionSheet (HKToolKit)

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                 clickedBlock:(UIActionSheetButtonBlock)clickedBlock
             willDismissBlock:(UIActionSheetButtonBlock)willDismissBlock
              didDismissBlock:(UIActionSheetButtonBlock)didDismissBlock
                  cancelBlock:(UIActionSheetBlock)cancelBlock
{
    self = [self initWithTitle:title
                      delegate:nil
             cancelButtonTitle:nil
        destructiveButtonTitle:destructiveButtonTitle
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
        
        self.clickedButtonBlock = clickedBlock;
        self.willDismissBlock = willDismissBlock;
        self.didDismissBlock = didDismissBlock;
        self.cancelBlock = cancelBlock;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 clickedBlock:(UIActionSheetButtonBlock)clickedBlock
             willDismissBlock:(UIActionSheetButtonBlock)willDismissBlock
              didDismissBlock:(UIActionSheetButtonBlock)didDismissBlock
                  cancelBlock:(UIActionSheetBlock)cancelBlock
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithTitle:title
             cancelButtonTitle:nil
        destructiveButtonTitle:destructiveButtonTitle
             otherButtonTitles:nil
                  clickedBlock:clickedBlock
              willDismissBlock:willDismissBlock
               didDismissBlock:didDismissBlock
                   cancelBlock:cancelBlock];
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

- (HKActionSheetDelegate *)blockDelegate
{
    if (!self.delegate || ![self.delegate isKindOfClass:[HKActionSheetDelegate class]])
    {
        HKActionSheetDelegate *delegate = [[HKActionSheetDelegate alloc] init];
        objc_setAssociatedObject(self,
                                 HKActionSheetDelegateKey,
                                 delegate,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
    }
    
    return self.delegate;
}

- (void)setClickedButtonBlock:(UIActionSheetButtonBlock)clickedButtonBlock
{
    self.blockDelegate.clickedButtonBlock = clickedButtonBlock;
}

- (void)setWillDismissBlock:(UIActionSheetButtonBlock)willDismissBlock
{
    self.blockDelegate.willDismissBlock = willDismissBlock;
}

- (void)setDidDismissBlock:(UIActionSheetButtonBlock)didDismissBlock
{
    self.blockDelegate.didDismissBlock = didDismissBlock;
}

- (void)setCancelBlock:(UIActionSheetBlock)cancelBlock
{
    self.blockDelegate.cancelBlock = cancelBlock;
}

- (UIActionSheetButtonBlock)clickedButtonBlock
{
    return self.blockDelegate.clickedButtonBlock;
}

- (UIActionSheetButtonBlock)willDismissBlock
{
    return self.blockDelegate.willDismissBlock;
}

- (UIActionSheetButtonBlock)didDismissBlock
{
    return self.blockDelegate.didDismissBlock;
}

- (UIActionSheetBlock)cancelBlock
{
    return self.blockDelegate.cancelBlock;
}

@end
