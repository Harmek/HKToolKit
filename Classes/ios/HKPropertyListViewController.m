//
//  SNPropertyListViewController.m
//  Synergy
//
//  Created by Panos on 12/13/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import "HKPropertyListViewController.h"
#import "HKPropertyListViewController_Protected.h"

#import "HKLabelCell.h"
#import "HKTextFieldCell.h"
#import "HKNumericCell.h"

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

NSString * const HKLabelCellIdentifier = @"LabelCell";
NSString * const HKTextFieldCellIdentifier = @"TextFieldCell";
NSString * const HKNumericCellIdentifier = @"NumericCell";

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
                       HKPropertyListRowTypeNumericId : @(HKPropertyListRowTypeNumeric)
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
                          HKNumericCellIdentifier
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
    NSParameterAssert(section < sections.count);
    
    return sections[section];
}

- (NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = [self sectionForIndex:indexPath.section];
    NSArray *rows = section[HKPropertyListRowsKey];
    NSDictionary *row = rows[indexPath.row];
    
    return row;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *sections = self.properties[HKPropertyListSectionsKey];
    
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSDictionary *section = [self sectionForIndex:sectionIndex];
    NSArray *rows = section[HKPropertyListRowsKey];
    
    return rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    NSDictionary *section = [self sectionForIndex:sectionIndex];
    NSString *name = section[HKPropertyListNameKey];
    
    return name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self rowForIndexPath:indexPath];
    NSString *rowTypeStr = rowInfo[HKPropertyListTypeKey];
    HKPropertyListRowType rowType = [rowTypeStr rowType];
    NSString *cellIdentifier = [[self class] cellIdentifiers][rowType];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowWithInfo:(NSDictionary *)rowInfo rowType:(HKPropertyListRowType)rowType andRowIdentifier:(NSString *)rowIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

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

- (void)tableView:(UITableView *)tableView
    configureCell:(UITableViewCell *)cell
      withRowInfo:(NSDictionary *)rowInfo
          rowType:(HKPropertyListRowType)type
 andRowIdentifier:(NSString *)identifier
      atIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = rowInfo[HKPropertyListNameKey];
    cell.textLabel.text = name;
    NSString *detail = rowInfo[HKPropertyListDetailKey];
    if (detail)
    {
        cell.detailTextLabel.text = detail;
    }
    NSString *imageName = rowInfo[HKPropertyListImageKey];
    if (imageName)
    {
        cell.imageView.image = [UIImage imageNamed:imageName];
    }
    NSString *accessoryStr = rowInfo[HKPropertyListAccessoryKey];
    cell.accessoryType = [accessoryStr accessoryType];
    id defaultValue = rowInfo[HKPropertyListDefaultValueKey];
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
            
        default:
            break;
    }
    
    NSString *propertyIdentifier = rowInfo[HKPropertyListIdKey];
    if (defaultValue && propertyIdentifier)
    {
        [self tableView:tableView
        setDefaultValue:defaultValue
          forIdentifier:propertyIdentifier];
    }
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
    if ((cell = [view superViewOfType:[UITableViewCell class]]) ||
        (tableView = [tableView superViewOfType:[UITableView class]]) ||
        (indexPath = [tableView indexPathForCell:cell]))
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

@end
