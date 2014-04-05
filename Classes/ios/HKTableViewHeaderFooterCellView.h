//
//  HKTableViewHeaderFooterCellView.h
//  Pods
//
//  Created by Panos Baroudjian on 4/3/14.
//
//

#import <UIKit/UIKit.h>

@interface HKTableViewHeaderFooterCellView : UITableViewHeaderFooterView

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@end
