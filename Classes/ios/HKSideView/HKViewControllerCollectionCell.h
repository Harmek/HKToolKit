//
//  HKViewControllerCollectionCell.h
//  Pods
//
//  Created by Panos Baroudjian on 4/12/14.
//
//

#import <UIKit/UIKit.h>

@interface HKViewControllerCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, assign) UIEdgeInsets contentViewControllerInsets;

@end
