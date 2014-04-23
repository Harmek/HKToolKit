//
//  HKTableViewHeaderFooterCellView.m
//  Pods
//
//  Created by Panos Baroudjian on 4/3/14.
//
//

#import "HKTableViewHeaderFooterCellView.h"

@interface HKTableViewHeaderFooterCellView ()

@property (nonatomic, strong) UITableViewCell *cell;

@end

@implementation HKTableViewHeaderFooterCellView
@synthesize cell = _cell;

- (UITableViewCell *)cell
{
    if (!_cell)
    {
        self.cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:nil];
        _cell.backgroundColor = [UIColor clearColor];
        _cell.backgroundView = nil;
        _cell.contentView.backgroundColor = [UIColor clearColor];
    }

    return _cell;
}

- (void)setCell:(UITableViewCell *)cell
{
    if (_cell == cell)
    {
        return;
    }

    [_cell removeFromSuperview];
    _cell = cell;
    if (cell)
    {
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:cell];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(cell);
        [self.contentView
         addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"V:|[cell]|"
                         options:0
                         metrics:nil
                         views:bindings]];
        [self.contentView
         addConstraints:[NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|[cell]|"
                         options:0
                         metrics:nil
                         views:bindings]];
    }
}

- (UILabel *)textLabel
{
    return self.cell.textLabel;
}

- (UILabel *)detailTextLabel
{
    return self.cell.detailTextLabel;
}

- (UIImageView *)imageView
{
    return self.cell.imageView;
}

- (UITableViewCellAccessoryType)accessoryType
{
    return self.cell.accessoryType;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    self.cell.accessoryType = accessoryType;
}

- (UIView *)accessoryView
{
    return self.cell.accessoryView;
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    self.cell.accessoryView = accessoryView;
}

@end
