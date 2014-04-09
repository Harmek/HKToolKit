//
//  HKModuleManager.m
//  Pods
//
//  Created by Panos.
//
//

#import "HKModuleManager.h"
#import "HKModule.h"
#import "HKRoutePattern.h"

NSString * const HKModuleTransitionTypeName = @"HKModuleTransitionType";
NSString * const HKModuleTransitionAnimatedName = @"HKModuleTransitionAnimated";
NSString * const HKModuleTransitionModalPresentationStyleName = @"HKModuleTransitionModalPresentationStyle";
NSString * const HKModuleTransitionModalTransitionStyleName = @"HKModuleTransitionModalTransitionStyle";
NSString * const HKModuleTransitionPresentationCompleteBlockName = @"HKModuleTransitionPresentationCompleteBlock";
NSString * const HKModuleTransitionPopoverArrowDirectionName = @"HKModuleTransitionPopoverArrowDirection";
NSString * const HKModuleTransitionPopoverContentSizeName = @"HKModuleTransitionPopoverContentSize";
NSString * const HKModuleTransitionEmbedInNavigationControllerName = @"HKModuleTransitionEmbedInNavigationController";

@interface HKModuleManager ()

@property (nonatomic, strong) NSMutableArray *modules;

@end

@implementation HKModuleManager

+ (instancetype)sharedManager
{
    static id s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[[self class] alloc] init];
    });
    
    return s_manager;
}

- (NSMutableArray *)modules
{
    if (!_modules)
    {
        self.modules = [NSMutableArray array];
    }
    
    return _modules;
}

- (void)registerViewControllerClass:(Class)viewControllerClass
                         forPattern:(NSString *)pattern
                   withInitSelector:(SEL)initSelector
{
    NSParameterAssert(viewControllerClass != nil);
    NSParameterAssert(pattern != nil);
    
    HKModule *module = [[HKModule alloc]
                        initWithViewControllerClass:viewControllerClass
                        pattern:pattern
                        andSelector:initSelector];
    [self.modules addObject:module];
}

- (id)instanciateViewControllerWithPath:(NSString *)path
{
    NSUInteger index = [self.modules indexOfObjectPassingTest:^BOOL(HKModule *module, NSUInteger idx, BOOL *stop) {
        return [module canInstanciateWithPath:path];
    }];
    if (index == NSNotFound)
    {
        return nil;
    }
    
    HKModule *matchingModule = self.modules[index];
    id result = [matchingModule instanciateWithPath:path];
    
    return result;
}

- (id)performSegueWithPath:(NSString *)path
                parameters:(NSDictionary *)parameters
        fromViewController:(UIViewController *)sourceViewController
                    sender:(UIView *)sender
               withOptions:(NSDictionary *)options
{
    UIViewController *toViewController = [self instanciateViewControllerWithPath:path];
    NSNumber *transitionType = options[HKModuleTransitionTypeName] ?: @(HKModuleTransitionTypePush);
    if (parameters)
    {
        [toViewController setValuesForKeysWithDictionary:parameters];
    }
    HKModuleTransitionType transitionTypeValue = transitionType.unsignedIntegerValue;
    NSNumber *animated = options[HKModuleTransitionAnimatedName] ?: @YES;
    NSNumber *embedInNavCtrl = options[HKModuleTransitionEmbedInNavigationControllerName] ?: @NO;

    switch (transitionTypeValue)
    {
        case HKModuleTransitionTypePush:
        {
            NSAssert(sourceViewController.navigationController != nil,
                     @"[%@]: %@ must have a navigation controller in order to push %@",
                     [self class],
                     sourceViewController,
                     toViewController);
            
            [sourceViewController.navigationController
             pushViewController:toViewController
             animated:animated.boolValue];
            
            return toViewController;
        }
        case HKModuleTransitionTypeModal:
        {
            NSNumber *presentationStyle = options[HKModuleTransitionModalPresentationStyleName] ?: @(UIModalPresentationCurrentContext);
            NSNumber *transitionStyle = options[HKModuleTransitionModalTransitionStyleName] ?: @(UIModalTransitionStyleCoverVertical);
            if (embedInNavCtrl.boolValue)
            {
                toViewController = [[UINavigationController alloc] initWithRootViewController:toViewController];
            }
            toViewController.modalPresentationStyle = presentationStyle.integerValue;
            toViewController.modalTransitionStyle = transitionStyle.integerValue;
            HKModuleTransitionPresentationCompleteBlock block = options[HKModuleTransitionPresentationCompleteBlockName];
            [sourceViewController
             presentViewController:toViewController
             animated:animated.boolValue
             completion:^{
                 if (block)
                 {
                     block(toViewController);
                 }
             }];
            
            return toViewController;
        }
        case HKModuleTransitionTypePopover:
        {
            if (embedInNavCtrl.boolValue)
            {
                toViewController = [[UINavigationController alloc] initWithRootViewController:toViewController];
            }

            UIPopoverController *ppc = [[UIPopoverController alloc] initWithContentViewController:toViewController];
            NSNumber *arrowDirection = options[HKModuleTransitionPopoverArrowDirectionName] ?: @(UIPopoverArrowDirectionAny);
            NSValue *contentSize = options[HKModuleTransitionPopoverContentSizeName];
            if (contentSize)
            {
                ppc.popoverContentSize = contentSize.CGSizeValue;
            }
            
            [ppc
             presentPopoverFromRect:sender.frame
             inView:sender.superview
             permittedArrowDirections:arrowDirection.unsignedIntegerValue
             animated:animated.boolValue];
            
            return ppc;
        }
        case HKModuleTransitionTypeEmbed:
        {
            [toViewController willMoveToParentViewController:sourceViewController];
            [sourceViewController addChildViewController:toViewController];
            [toViewController didMoveToParentViewController:sourceViewController];
            
            return toViewController;
        }
    }
    
    return nil;
}

@end
