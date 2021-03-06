//
//  HKModuleManager.h
//  Pods
//
//  Created by Panos
//
//

@import UIKit;

extern NSString * const HKModuleTransitionTypeName;
extern NSString * const HKModuleTransitionAnimatedName;
extern NSString * const HKModuleTransitionModalPresentationStyleName;
extern NSString * const HKModuleTransitionModalTransitionStyleName;
extern NSString * const HKModuleTransitionPresentationCompleteBlockName;
extern NSString * const HKModuleTransitionPopoverArrowDirectionName;
extern NSString * const HKModuleTransitionPopoverContentSizeName;
extern NSString * const HKModuleTransitionEmbedInNavigationControllerName;
extern NSString * const HKModuleTransitionTransitioningDelegateName;

typedef void (^HKModuleTransitionPresentationCompleteBlock) (UIViewController *toViewController);

typedef NS_ENUM(NSUInteger, HKModuleTransitionType)
{
    HKModuleTransitionTypePush = 0,
    HKModuleTransitionTypeModal,
    HKModuleTransitionTypePopover,
    HKModuleTransitionTypeEmbed
};

@interface HKModuleManager : NSObject

+ (instancetype)sharedManager;

- (void)registerViewControllerClass:(Class)viewControllerClass
                         forPattern:(NSString *)pattern
                   withInitSelector:(SEL)initSelector;

- (id)performSegueWithPath:(NSString *)path
                parameters:(NSDictionary *)parameters
        fromViewController:(UIViewController *)sourceViewController
                    sender:(id)sender
               withOptions:(NSDictionary *)options;

- (id)instanciateViewControllerWithPath:(NSString *)path;

@end
