//
//  SNLabelCell.h
//  Synergy
//
//  Created by Panos on 12/15/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKLabelCellDetailStyle)
{
    HKLabelCellDetailStyleRight = 0,
    HKLabelCellDetailStyleSubtitle,
    
    SNLabelCellDetailStyleCount
};

@interface HKLabelCell : UITableViewCell

+ (UIFont *)textDefaultFont;
+ (UIFont *)detailTextDefaultFont;

@property (nonatomic, assign) HKLabelCellDetailStyle detailStyle;
@property (nonatomic, assign) CGFloat imageViewMaxWidth;

@end
