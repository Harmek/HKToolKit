//
//  HKSwitchCell.m
//  Pods
//
//  Created by Panos Baroudjian on 4/9/14.
//
//

#import "HKSwitchCell.h"

@interface HKSwitchCell ()

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation HKSwitchCell

- (UISwitch *)switchControl
{
    if (!self.accessoryView || ![self.accessoryView isKindOfClass:[UISwitch class]])
    {
        self.switchControl = [[UISwitch alloc] init];
    }

    return (id)self.accessoryView;
}

- (void)setSwitchControl:(UISwitch *)switchControl
{
    self.accessoryView = switchControl;
}

@end
