//
//  SNPropertyListViewController.m
//  Synergy
//
//  Created by Panos on 12/13/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import "HKPropertyListViewController.h"
#import "HKPropertyListViewController_Protected.h"

#import "HKTableViewHeaderFooterCellView.h"
#import "HKLabelCell.h"
#import "HKTextFieldCell.h"
#import "HKNumericCell.h"
#import "HKSwitchCell.h"

NSString * const HKPropertyListSectionsKey = @"sections";
NSString * const HKPropertyListRowsKey = @"rows";
NSString * const HKPropertyListImageKey = @"image";
NSString * const HKPropertyListNameKey = @"name";
NSString * const HKPropertyListDetailKey = @"detail";
NSString * const HKPropertyListTypeKey = @"type";
NSString * const HKPropertyListPlaceholderKey = @"placeholder";
NSString * const HKPropertyListSecuredKey = @"secured";
NSString * const HKPropertyListAccessoryKey = @"accessory";
NSString * const HKPropertyListMinValueKey = @"minValue";
NSString * const HKPropertyListMaxValueKey = @"maxValue";
NSString * const HKPropertyListDefaultValueKey = @"defaultValue";
NSString * const HKPropertyListIdKey = @"id";
NSString * const HKPropertyListTitleKey = @"title";

NSString * const HKPropertyListSelectKey = @"select";
NSString * const HKPropertyListSegueKey = @"segue";

NSString * const HKPropertyListRowTypeLabelId = @"label";
NSString * const HKPropertyListRowTypeTextFieldId = @"textField";
NSString * const HKPropertyListRowTypeNumericId = @"numeric";
NSString * const HKPropertyListRowTypeBooleanId = @"boolean";

NSString * const HKLabelSectionHeaderIdentifier = @"HKPropertyListLabelHeader";
NSString * const HKLabelCellIdentifier = @"HKPropertyListLabelCell";
NSString * const HKTextFieldCellIdentifier = @"HKPropertyListTextFieldCell";
NSString * const HKNumericCellIdentifier = @"HKPropertyListNumericCell";
NSString * const HKBooleanCellIdentifier = @"HKPropertyListBoolean";

NSString * const HKPropertyListAccessoryNoneId = @"none";
NSString * const HKPropertyListAccessoryDisclosureIndicatorId = @"disclosureIndicator";
NSString * const HKPropertyListAccessoryDetailDisclosureButtonId = @"disclosureButton";
NSString * const HKPropertyListAccessoryCheckmarkId = @"checkmark";
NSString * const HKPropertyListAccessoryDetailButtonId = @"detailButton";

@implementation NSString (HKPropertyList)

- (HKPropertyListRowType)rowType
{
    static NSDictionary *s_rowTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_rowTypes = @{
                       HKPropertyListRowTypeLabelId : @(HKPropertyListRowTypeLabel),
                       HKPropertyListRowTypeTextFieldId : @(HKPropertyListRowTypeTextField),
                       HKPropertyListRowTypeNumericId : @(HKPropertyListRowTypeNumeric),
                       HKPropertyListRowTypeBooleanId : @(HKPropertyListRowTypeBoolean)
                       };
    });

    NSNumber *rowType = s_rowTypes[self];

    return rowType ? rowType.unsignedIntegerValue : HKPropertyListRowTypeLabel;
}

- (UITableViewCellAccessoryType)accessoryType
{
    static NSDictionary *s_accessoryTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_accessoryTypes = @{
                             HKPropertyListAccessoryNoneId : @(UITableViewCellAccessoryNone),
                             HKPropertyListAccessoryDisclosureIndicatorId : @(UITableViewCellAccessoryDisclosureIndicator),
                             HKPropertyListAccessoryDetailDisclosureButtonId : @(UITableViewCellAccessoryDetailDisclosureButton),
                             HKPropertyListAccessoryCheckmarkId : @(UITableViewCellAccessoryCheckmark),
                             HKPropertyListAccessoryDetailButtonId : @(UITableViewCellAccessoryDetailButton)
                             };
    });

    NSNumber *accessoryType = s_accessoryTypes[self];

    return accessoryType ? accessoryType.integerValue : UITableViewCellAccessoryNone;
}

@end

@implementation UIView (HKPropertyList)

- (id)superViewOfType:(Class)type
{
    UIView *superview = nil;
    for (superview = self.superview;
         superview && ![superview isKindOfClass:type];
         superview = superview.superview)
    {
    }

    return superview;
}

@end

@interface HKPropertyListViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *properties;

@end

@implementation HKPropertyListViewController

+ (NSArray *)cellIdentifiers
{
    static NSArray *s_identifiers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_identifiers = @[
                          HKLabelCellIdentifier,
                          HKTextFieldCellIdentifier,
                          HKNumericCellIdentifier,
                          HKBooleanCellIdentifier
                          ];
    });

    return s_identifiers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView
     registerClass:[HKLabelCell class]
     forCellReuseIdentifier:HKLabelCellIdentifier];
    [self.tableView
     registerClass:[HKTextFieldCell class]
     forCellReuseIdentifier:HKTextFieldCellIdentifier];
    [self.tableView
     registerClass:[HKNumericCell class]
     forCellReuseIdentifier:HKNumericCellIdentifier];
    [self.tableView
     registerClass:[HKSwitchCell class]
     forCellReuseIdentifier:HKBooleanCellIdentifier];

    [self.tableView
     registerClass:[HKTableViewHeaderFooterCellView class]
     forHeaderFooterViewReuseIdentifier:HKLabelSectionHeaderIdentifier];

    NSString *title = self.properties[HKPropertyListTitleKey];
    self.title = title;
}

- (NSDictionary *)properties
{
    if (!_properties)
    {
        NSURL *plistUrl = [[NSBundle mainBundle] URLForResource:self.name
                                                  withExtension:@"plist"];
        _properties = [NSDictionary dictionaryWithContentsOfURL:plistUrl];
    }

    return _properties;
}

- (NSDictionary *)sectionForIndex:(NSInteger)section
{
    NSArray *sections = self.properties[HKPropertyListSectionsKey];
    section = [self modifiedSectionIndex:section];
    NSParameterAssert(section < sections.count);

    return sections[section];
}

- (NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger modifiedSectionIndex = [self modifiedSectionIndex:indexPath.section];
    NSDictionary *section = [self sectionForIndex:modifiedSectionIndex];
    NSArray *rows = section[HKPropertyListRowsKey];
    NSDictionary *row = rows[indexPath.row];

    return row;
}

- (NSInteger)modifiedSectionIndex:(NSInteger)sectionIndex
{
    switch (self.type)
    {
        case HKPropertyListTypeTargetObject:
        {
            if ([self.targetObject respondsToSelector:@selector(count)])
            {
                sectionIndex = 0;
            }

            break;
        }
        default:
            break;
    }

    return sectionIndex;
}

- (id)targetObjectForSectionIndex:(NSInteger)sectionIndex
{
    if ([self.targetObject respondsToSelector:@selector(count)])
    {
        if ([self.targetObject respondsToSelector:@selector(objectAtIndexedSubscript:)])
        {
            return self.targetObject[sectionIndex];
        }
    }

    return self.targetObject;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.type)
    {
        case HKPropertyListTypeTargetObject:
        {
            if ([self.targetObject respondsToSelector:@selector(count)])
            {
                return [self.targetObject count];
            }
        }
        case HKPropertyListTypeFixed:
        {
            NSArray *sections = self.properties[HKPropertyListSectionsKey];

            return sections.count;
        }
        default:
            break;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSDictionary *section = [self sectionForIndex:sectionIndex];
    NSArray *rows = section[HKPropertyListRowsKey];

    return rows.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIdx
{
    HKTableViewHeaderFooterCellView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HKLabelSectionHeaderIdentifier];
    NSDictionary *section = [self sectionForIndex:sectionIdx];

    [self tableView:tableView
configureHeaderView:header
    withSectionInfo:section
   andRowIdentifier:HKLabelSectionHeaderIdentifier
     atSectionIndex:sectionIdx];

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = [self sectionForIndex:section];

    return [self tableView:tableView heightForHeaderWithSectionInfo:sectionInfo atSectionIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView cellIdentifierWithRowInfo:(NSDictionary *)rowInfo rowType:(HKPropertyListRowType)rowType atIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[self class] cellIdentifiers][rowType];

    return cellIdentifier;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self rowForIndexPath:indexPath];
    NSString *rowTypeStr = rowInfo[HKPropertyListTypeKey];
    HKPropertyListRowType rowType = [rowTypeStr rowType];
    NSString *cellIdentifier = [self tableView:tableView cellIdentifierWithRowInfo:rowInfo rowType:rowType atIndexPath:indexPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];

    [self tableView:tableView
      configureCell:cell
        withRowInfo:rowInfo
            rowType:rowType
   andRowIdentifier:cellIdentifier
        atIndexPath:indexPath];

    return cell;
}

#pragma mark — Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self rowForIndexPath:indexPath];
    NSString *rowTypeStr = rowInfo[HKPropertyListTypeKey];
    HKPropertyListRowType rowType = [rowTypeStr rowType];
    NSString *cellIdentifier = [[self class] cellIdentifiers][rowType];

    return [self tableView:tableView
      heightForRowWithInfo:rowInfo
                   rowType:rowType
          andRowIdentifier:cellIdentifier
               atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowWithInfo:(NSDictionary *)rowInfo atIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self rowForIndexPath:indexPath];
    NSDictionary *select = rowInfo[HKPropertyListSelectKey];
    if (!select)
    {
        [self tableView:tableView didSelectRowWithInfo:rowInfo atIndexPath:indexPath];
        return;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *segue = select[HKPropertyListSegueKey];
    if (segue && [self shouldPerformSegueWithIdentifier:segue sender:cell])
    {
        [self performSegueWithIdentifier:segue
                                  sender:cell];
    }
}

#pragma mark — Protected

- (void)tableView:(UITableView *)tableView configureHeaderView:(UITableViewHeaderFooterView *)header withSectionInfo:(NSDictionary *)sectionInfo andRowIdentifier:(NSString *)identifier atSectionIndex:(NSInteger)sectionIndex
{
    NSString *title = nil;
    switch (self.type)
    {
        case HKPropertyListTypeTargetObject:
        {
            NSString *keyPath = sectionInfo[HKPropertyListIdKey];
            id targetObject = [self targetObjectForSectionIndex:sectionIndex];
            if (keyPath.length)
            {
                title = [targetObject valueForKeyPath:keyPath];

                break;
            }
        }
        case HKPropertyListTypeFixed:
        {
            NSString *name = sectionInfo[HKPropertyListNameKey];
            title = name;

            break;
        }
        default:
            break;
    }

    header.textLabel.text = title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderWithSectionInfo:(NSDictionary *)sectionInfo atSectionIndex:(NSInteger)section
{
    return 38.;
}

- (void)tableView:(UITableView *)tableView
    configureCell:(UITableViewCell *)cell
      withRowInfo:(NSDictionary *)rowInfo
          rowType:(HKPropertyListRowType)type
 andRowIdentifier:(NSString *)rowIdentifier
      atIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = rowInfo[HKPropertyListNameKey];
    cell.textLabel.text = name;
    switch (self.type)
    {
        case HKPropertyListTypeTargetObject:
        {
            NSString *keyPath = rowInfo[HKPropertyListIdKey];
            id targetObject = [self targetObjectForSectionIndex:indexPath.section];
            if (keyPath.length)
            {
                cell.detailTextLabel.text = [targetObject valueForKeyPath:keyPath];

                break;
            }
        }
        case HKPropertyListTypeFixed:
        {
            NSString *detail = rowInfo[HKPropertyListDetailKey];
            if (detail)
            {
                cell.detailTextLabel.text = detail;
            }

            break;
        }
        default:
            break;
    }

    NSString *imageName = rowInfo[HKPropertyListImageKey];
    if (imageName)
    {
        cell.imageView.image = [UIImage imageNamed:imageName];
    }
    NSString *accessoryStr = rowInfo[HKPropertyListAccessoryKey];
    cell.accessoryType = [accessoryStr accessoryType];
    NSString *propertyIdentifier = rowInfo[HKPropertyListIdKey];
    id defaultValue = [self tableView:tableView defaultValueForIdentifier:propertyIdentifier] ?: rowInfo[HKPropertyListDefaultValueKey];
    switch (type)
    {
        case HKPropertyListRowTypeTextField:
        {
            HKTextFieldCell *textFieldCell = (id)cell;
            NSString *placeholder = rowInfo[HKPropertyListPlaceholderKey];
            NSNumber *secured = rowInfo[HKPropertyListSecuredKey];
            textFieldCell.textField.placeholder = placeholder;
            textFieldCell.textField.delegate = self;
            textFieldCell.textField.secureTextEntry = secured.boolValue;

            break;
        }
        case HKPropertyListRowTypeNumeric:
        {
            HKNumericCell *numericCell = (id)cell;
            NSNumber *minValue = rowInfo[HKPropertyListMinValueKey];
            NSNumber *maxValue = rowInfo[HKPropertyListMaxValueKey];
            NSNumber *defaultNumber = defaultValue;
            numericCell.stepper.minimumValue = minValue.floatValue;
            numericCell.stepper.maximumValue = maxValue.floatValue;
            numericCell.stepper.value = defaultNumber.floatValue;
            [numericCell.stepper sendActionsForControlEvents:UIControlEventValueChanged];
            [numericCell.stepper addTarget:self
                                    action:@selector(numericCellStepperValueChanged:)
                          forControlEvents:UIControlEventValueChanged];

            break;
        }
        case HKPropertyListRowTypeBoolean:
        {
            HKSwitchCell *switchCell = (id)cell;
            NSNumber *defaultNumber = defaultValue;
            switchCell.switchControl.on = defaultNumber.boolValue;
            [switchCell.switchControl addTarget:self
                                         action:@selector(switchCellSwitchValueChanged:)
                               forControlEvents:UIControlEventValueChanged];
        }

        default:
            break;
    }

    if (defaultValue && propertyIdentifier)
    {
        [self tableView:tableView
        setDefaultValue:defaultValue
          forIdentifier:propertyIdentifier];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowWithInfo:(NSDictionary *)rowInfo
             rowType:(HKPropertyListRowType)rowType
    andRowIdentifier:(NSString *)rowIdentifier
         atIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (id)tableView:(UITableView *)tableView defaultValueForIdentifier:(NSString *)identifier
{
    return nil;
}

- (void)tableView:(UITableView *)tableView
  setDefaultValue:(id)value
    forIdentifier:(NSString *)identifier
{

}

- (void)tableView:(UITableView *)tableView
   didChangeValue:(id)value
    forIdentifier:(NSString *)identifier
          forCell:(UITableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
{

}

- (void)sendChangeValueMessage:(id)value
                       forView:(UIView *)view
{
    UITableViewCell *cell = nil;
    UITableView *tableView = nil;
    NSIndexPath *indexPath = nil;
    if (!(cell = [view superViewOfType:[UITableViewCell class]]) ||
        !(tableView = [cell superViewOfType:[UITableView class]]) ||
        !(indexPath = [tableView indexPathForCell:cell]))
    {
        return;
    }

    NSDictionary *rowInfo = [self rowForIndexPath:indexPath];
    NSString *identifier = rowInfo[HKPropertyListIdKey];
    if (!identifier)
    {
        return;
    }

    [self tableView:tableView
     didChangeValue:value
      forIdentifier:identifier
            forCell:cell
        atIndexPath:indexPath];
}

#pragma mark — Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *value = textField.text;

    [self sendChangeValueMessage:value
                         forView:textField];
}

#pragma mark — UIStepper

- (void)numericCellStepperValueChanged:(UIStepper *)stepper
{
    NSNumber *value = @(stepper.value);

    [self sendChangeValueMessage:value
                         forView:stepper];
}

#pragma mark — UISwitch

- (void)switchCellSwitchValueChanged:(UISwitch *)switchCtrl
{
    NSNumber *value = @(switchCtrl.on);
    
    [self sendChangeValueMessage:value forView:switchCtrl];
}
@end
