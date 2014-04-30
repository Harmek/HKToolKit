//
//  HKSideViewController.m
//  Pods
//
//  Created by Panos Baroudjian on 4/12/14.
//
//

#import "HKSideViewController.h"
#import "HKViewControllerCollectionCell.h"
#import "HKSideViewFlowLayout.h"
#import <HKCGPoint.h>

static UICollectionViewScrollDirection HKSideViewControllerScrollDirections[] =
{
    UICollectionViewScrollDirectionHorizontal,
    UICollectionViewScrollDirectionVertical
};

static NSString * const HKSideViewLeftCellIdentifier = @"HKSideViewLeftCell";
static NSString * const HKSideViewCenterCellIdentifier = @"HKSideViewCenterCell";
static NSString * const HKSideViewRightIdentifier = @"HKSideViewRightCell";

@interface HKSideViewController ()

@property (nonatomic, assign) BOOL startingCellShows;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) CGPoint startingContentOffset;

@property (nonatomic, assign) BOOL oldPanGestureDisabled;

@end

@implementation HKSideViewController
@synthesize panGestureRecognizer = _panGestureRecognizer;

+ (NSArray *)cellIdentifiers
{
    static NSArray *s_identifiers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_identifiers = @[
                          HKSideViewLeftCellIdentifier,
                          HKSideViewCenterCellIdentifier,
                          HKSideViewRightIdentifier
                          ];
    });

    return s_identifiers;
}

+ (NSIndexPath *)leftIndexPath
{
    static NSIndexPath *s_indexPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_indexPath = [NSIndexPath indexPathForItem:0
                                          inSection:HKSideViewSectionLeft];
    });

    return s_indexPath;
}

+ (NSIndexPath *)centerIndexPath
{
    static NSIndexPath *s_indexPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_indexPath = [NSIndexPath indexPathForItem:0
                                          inSection:HKSideViewSectionCenter];
    });

    return s_indexPath;
}

+ (NSIndexPath *)rightIndexPath
{
    static NSIndexPath *s_indexPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_indexPath = [NSIndexPath indexPathForItem:0
                                          inSection:HKSideViewSectionRight];
    });

    return s_indexPath;
}

+ (NSIndexPath *)topIndexPath
{
    static NSIndexPath *s_indexPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_indexPath = [NSIndexPath indexPathForItem:0
                                          inSection:HKSideViewSectionTop];
    });

    return s_indexPath;
}

+ (NSIndexPath *)bottomIndexPath
{
    static NSIndexPath *s_indexPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_indexPath = [NSIndexPath indexPathForItem:0
                                          inSection:HKSideViewSectionBottom];
    });

    return s_indexPath;
}

- (instancetype)initWithSideMenuDirection:(HKSideViewDirection)sideMenuDirection
{
    UICollectionViewLayout *layout =
    ({
        HKSideViewFlowLayout *flow = [[HKSideViewFlowLayout alloc] init];
        flow.scrollDirection = HKSideViewControllerScrollDirections[sideMenuDirection];
        flow;
    });
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.sideMenuDirection = sideMenuDirection;
    }

    return self;
}

- (instancetype)init
{
    self = [self initWithSideMenuDirection:HKSideViewDirectionHorizontal];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    [[[self class] cellIdentifiers]
     enumerateObjectsWithOptions:0
     usingBlock:^(NSString *identifier, NSUInteger idx, BOOL *stop) {
         [self.collectionView registerClass:[HKViewControllerCollectionCell class]
                 forCellWithReuseIdentifier:identifier];
     }];
    self.panGestureRecognizer = self.panGestureRecognizer;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (self.startingCellShows)
    {
        return;
    }

    self.startingCellShows = YES;
    self.presentingIndexPath = [[self class] centerIndexPath];
}

#pragma mark — Gesture Recognizers

- (void)setPanGestureDisabled:(BOOL)panGestureDisabled
{
    _panGestureDisabled = panGestureDisabled;
    if (panGestureDisabled)
    {
        self.panGestureRecognizer = nil;
    }
    else
    {
        self.panGestureRecognizer = self.panGestureRecognizer;
    }
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (!_panGestureRecognizer && !self.panGestureDisabled)
    {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(panGestureRecognized:)];
    }

    return _panGestureRecognizer;
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (_panGestureRecognizer == panGestureRecognizer)
    {
        return;
    }

    if (_panGestureRecognizer)
    {
        [self.collectionView removeGestureRecognizer:_panGestureRecognizer];
    }

    _panGestureRecognizer = panGestureRecognizer;
    if (panGestureRecognizer)
    {
        [self.collectionView addGestureRecognizer:panGestureRecognizer];
    }
}

- (CGPoint)maxContentOffset
{
    CGSize contentSize = self.collectionView.contentSize;
    CGRect bounds = self.collectionView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    contentSize.width -= width;
    contentSize.height -= height;

    return CGPointMake(contentSize.width, contentSize.height);
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.startingContentOffset = self.collectionView.contentOffset;

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGRect bounds = self.collectionView.bounds;
            CGSize contentSize = self.collectionView.contentSize;
            CGFloat width = CGRectGetWidth(bounds);
            CGFloat height = CGRectGetHeight(bounds);
            CGFloat scaleX = (contentSize.width * .5) / width;
            CGFloat scaleY = (contentSize.height * .5) / height;
            CGPoint translation = [panGesture translationInView:self.collectionView];
            translation.x *= scaleX;
            translation.y *= scaleY;
            [panGesture setTranslation:CGPointZero
                                inView:self.collectionView];
            switch (self.sideMenuDirection)
            {
                case HKSideViewDirectionHorizontal:
                {
                    translation.y = .0;

                    break;
                }
                case HKSideViewDirectionVertical:
                {
                    translation.x = .0;

                    break;
                }
                default:
                    break;
            }
            CGPoint contentOffset = CGPointSubtract(self.collectionView.contentOffset, translation);
            CGPoint maxContentOffset = [self maxContentOffset];
            contentOffset.x = MAX(.0, MIN(contentOffset.x, maxContentOffset.x));
            contentOffset.y = MAX(.0, MIN(contentOffset.y, maxContentOffset.y));
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.presentingIndexPath];
            if (CGPointDistance(contentOffset, self.startingContentOffset) < CGRectGetWidth(cell.frame))
            {
                self.collectionView.contentOffset = contentOffset;
            }

            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint contentOffset = self.collectionView.contentOffset;
            CGSize contentSize = self.collectionView.contentSize;
            CGPoint velocity = [panGesture velocityInView:self.collectionView];
            CGFloat offset = .0;
            CGFloat total = .0;
            CGFloat direction = .0;
            switch (self.sideMenuDirection)
            {
                case HKSideViewDirectionHorizontal:
                {
                    offset = contentOffset.x;
                    total = contentSize.width;
                    direction = velocity.x;

                    break;
                }
                case HKSideViewDirectionVertical:
                {
                    offset = contentOffset.y;
                    total = contentSize.height;
                    direction = velocity.y;

                    break;
                }
                default:
                    break;
            }
            NSInteger indexDiff = copysign(1., -direction);
            NSIndexPath *presentingIndexPath = self.presentingIndexPath;
            NSInteger section = MAX(.0, MIN(presentingIndexPath.section + indexDiff,
                                            [self.collectionView numberOfSections]));
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0
                                                         inSection:section];
            [self setPresentingIndexPath:indexPath animated:YES];

            break;
        }
        default:
            break;
    }
}

#pragma mark — Setters & Getter

- (void)setSideMenuDirection:(HKSideViewDirection)sideMenuDirection animated:(BOOL)animated completion:(HKSideViewDirectionChangeCompletion)completion
{
    _sideMenuDirection = sideMenuDirection;
    UICollectionViewLayout *layout =
    ({
        HKSideViewFlowLayout *flow = [[HKSideViewFlowLayout alloc] init];
        flow.scrollDirection = HKSideViewControllerScrollDirections[sideMenuDirection];
        flow;
    });

    [self.collectionView setCollectionViewLayout:layout
                                        animated:animated
                                      completion:completion];
}

- (void)setSideMenuDirection:(HKSideViewDirection)sideMenuDirection animated:(BOOL)animated
{
    [self setSideMenuDirection:sideMenuDirection animated:animated completion:nil];
}

- (void)setSideMenuDirection:(HKSideViewDirection)sideMenuDirection
{
    [self setSideMenuDirection:sideMenuDirection animated:NO];
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController == leftViewController)
    {
        return;
    }

    _leftViewController = leftViewController;
    [self.collectionView reloadItemsAtIndexPaths:@[[[self class] leftIndexPath]]];
}

- (void)setCenterViewController:(UIViewController *)centerViewController
{
    if (_centerViewController == centerViewController)
    {
        return;
    }

    _centerViewController = centerViewController;
    [self.collectionView reloadItemsAtIndexPaths:@[[[self class] centerIndexPath]]];
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController == rightViewController)
    {
        return;
    }

    _rightViewController = rightViewController;
    [self.collectionView reloadItemsAtIndexPaths:@[[[self class] rightIndexPath]]];
}

#pragma mark — Public methods

- (void)setPresentingIndexPath:(NSIndexPath *)presentingIndexPath
{
    [self setPresentingIndexPath:presentingIndexPath animated:NO];
}

- (void)setPresentingIndexPath:(NSIndexPath *)presentingIndexPath animated:(BOOL)animated
{
    if (_presentingIndexPath == presentingIndexPath)
    {
        return;
    }

    if (_presentingIndexPath && self.panGestureEnabledWhenSide)
    {
        if (![presentingIndexPath isEqual:[[self class] centerIndexPath]])
        {
            self.oldPanGestureDisabled = self.panGestureDisabled;
            self.panGestureDisabled = NO;
        }
        else
        {
            self.panGestureDisabled = self.oldPanGestureDisabled;
        }
    }

    _presentingIndexPath = [presentingIndexPath copy];
    [self.collectionView
     scrollToItemAtIndexPath:_presentingIndexPath
     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically
     animated:animated];
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSAssert(viewController != nil, nil);

    NSIndexPath *indexPath = nil;
    if (viewController == self.leftViewController)
    {
        indexPath = [[self class] leftIndexPath];
    }
    else if (viewController == self.centerViewController)
    {
        indexPath = [[self class] centerIndexPath];
    }
    else if (viewController == self.rightViewController)
    {
        indexPath = [[self class] rightIndexPath];
    }

    [self setPresentingIndexPath:indexPath animated:animated];
}

#pragma mark — Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return HKSideViewSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[self class] cellIdentifiers][indexPath.section];
    HKViewControllerCollectionCell *cell = [collectionView
                                            dequeueReusableCellWithReuseIdentifier:identifier
                                            forIndexPath:indexPath];
    UIViewController *viewController = nil;
    switch ((HKSideViewSection)indexPath.section)
    {
        case HKSideViewSectionLeft:
        {
            viewController = self.leftViewController;

            break;
        }
        case HKSideViewSectionCenter:
        {
            viewController = self.centerViewController;

            break;
        }
        case HKSideViewSectionRight:
        {
            viewController = self.rightViewController;

            break;
        }
        default:
            break;
    }

    if (cell.contentViewController != viewController)
    {
        [viewController willMoveToParentViewController:self];
        cell.contentViewController = viewController;
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:viewController];
    }

    return cell;
}

#pragma mark — Collection view flow layout delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = collectionView.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);

    return CGSizeMake(width, height);
}

@end

@implementation UIViewController (HKSideViewController)

- (HKSideViewController *)sideViewController
{
    UIViewController *result = self;
    for (; result && ![result isKindOfClass:[HKSideViewController class]];
         result = result.parentViewController)
    {
    }
    
    return (HKSideViewController *)result;
}

@end
