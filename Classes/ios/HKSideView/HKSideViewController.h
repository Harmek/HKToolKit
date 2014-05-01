//
//  HKSideViewController.h
//  Pods
//
//  Created by Panos Baroudjian on 4/12/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKSideViewDirection)
{
    HKSideViewDirectionHorizontal = 0,
    HKSideViewDirectionVertical,
};

typedef NS_ENUM(NSInteger, HKSideViewSection)
{
    HKSideViewSectionLeft = 0,
    HKSideViewSectionTop = HKSideViewSectionLeft,
    HKSideViewSectionCenter,
    HKSideViewSectionRight,
    HKSideViewSectionBottom = HKSideViewSectionRight,

    HKSideViewSectionCount,
};

typedef void (^HKSideViewDirectionChangeCompletion) (BOOL complete);

@interface HKSideViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) HKSideViewDirection sideMenuDirection;
@property (nonatomic, strong) NSIndexPath *startingIndexPath;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong,
           getter = leftViewController,
           setter = setLeftViewController:) UIViewController *topViewController;
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
@property (nonatomic, strong,
           getter = rightViewController,
           setter = setRightViewController:) UIViewController *bottomViewController;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL panGestureDisabled;
@property (nonatomic, assign) BOOL panGestureEnabledOnSides;
@property (nonatomic, copy) NSIndexPath *presentingIndexPath;

+ (NSIndexPath *)leftIndexPath;
+ (NSIndexPath *)centerIndexPath;
+ (NSIndexPath *)rightIndexPath;
+ (NSIndexPath *)topIndexPath;
+ (NSIndexPath *)bottomIndexPath;

- (instancetype)initWithSideMenuDirection:(HKSideViewDirection)direction;
- (void)setSideMenuDirection:(HKSideViewDirection)sideMenuDirection
                    animated:(BOOL)animated
                  completion:(HKSideViewDirectionChangeCompletion)completion;
- (void)setSideMenuDirection:(HKSideViewDirection)sideMenuDirection
                    animated:(BOOL)animated;
- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)setPresentingIndexPath:(NSIndexPath *)presentingIndexPath animated:(BOOL)animated;

@end

@interface UIViewController (HKSideViewController)

@property (nonatomic, strong, readonly) HKSideViewController *sideViewController;

@end
