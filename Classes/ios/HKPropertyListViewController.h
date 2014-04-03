//
//  SNPropertyListViewController.h
//  Synergy
//
//  Created by Panos on 12/13/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKPropertyListType)
{
    HKPropertyListTypeFixed = 0,
    HKPropertyListTypeTargetObject,
};

@interface HKPropertyListViewController : UITableViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) HKPropertyListType type;

@property (nonatomic, strong) id targetObject;

@end
