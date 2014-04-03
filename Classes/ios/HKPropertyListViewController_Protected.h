//
//  SNPropertyListViewController_Protected.h
//  Synergy
//
//  Created by Panos on 12/13/13.
//  Copyright (c) 2013 Panos. All rights reserved.
//

#import "HKPropertyListViewController.h"

extern NSString * const HKPropertyListSectionsKey;
extern NSString * const HKPropertyListRowsKey;
extern NSString * const HKPropertyListNameKey;
extern NSString * const HKPropertyListDetailKey;
extern NSString * const HKPropertyListTypeKey;
extern NSString * const HKPropertyListPlaceholderKey;
extern NSString * const HKPropertyListSecuredKey;
extern NSString * const HKPropertyListMinValueKey;
extern NSString * const HKPropertyListMaxValueKey;
extern NSString * const HKPropertyListDefaultValueKey;
extern NSString * const HKPropertyListIdKey;
extern NSString * const HKPropertyListTitleKey;

extern NSString * const HKPropertyListSelectKey;
extern NSString * const HKPropertyListSegueKey;

extern NSString * const HKPropertyListRowTypeLabelId;
extern NSString * const HKPropertyListRowTypeTextFieldId;
extern NSString * const HKPropertyListRowTypeNumericId;

extern NSString * const HKLabelSectionHeaderIdentifier;
extern NSString * const HKLabelCellIdentifier;
extern NSString * const HKTextFieldCellIdentifier;
extern NSString * const HKNumericCellIdentifier;

extern NSString * const HKPropertyListAccessoryNoneId;
extern NSString * const HKPropertyListAccessoryDisclosureIndicatorId;
extern NSString * const HKPropertyListAccessoryDetailDisclosureButtonId;
extern NSString * const HKPropertyListAccessoryCheckmarkId;
extern NSString * const HKPropertyListAccessoryDetailButtonId;

typedef NS_ENUM(NSUInteger, HKPropertyListRowType)
{
    HKPropertyListRowTypeLabel = 0,
    HKPropertyListRowTypeTextField,
    HKPropertyListRowTypeNumeric
};

@interface NSString (HKPropertyList)

- (HKPropertyListRowType)rowType;
- (UITableViewCellAccessoryType)accessoryType;

@end

@interface UIView (HKPropertyList)

- (id)superViewOfType:(Class)type;

@end

@interface HKPropertyListViewController (Protected)

@property (nonatomic, strong, readonly) NSDictionary *properties;

- (NSDictionary *)sectionForIndex:(NSInteger)section;
- (NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)modifiedSectionIndex:(NSInteger)sectionIndex;
- (id)targetObjectForSectionIndex:(NSInteger)sectionIndex;

- (void)tableView:(UITableView *)tableView configureHeaderView:(UITableViewHeaderFooterView *)header withSectionInfo:(NSDictionary *)sectionInfo andRowIdentifier:(NSString *)identifier atSectionIndex:(NSInteger)sectionIndex;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderWithSectionInfo:(NSDictionary *)sectionInfo atSectionIndex:(NSInteger)section;

- (void)tableView:(UITableView *)tableView
    configureCell:(UITableViewCell *)cell
      withRowInfo:(NSDictionary *)rowInfo
          rowType:(HKPropertyListRowType)type
    andRowIdentifier:(NSString *)identifier
      atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView
heightForRowWithInfo:(NSDictionary *)rowInfo
             rowType:(HKPropertyListRowType)rowType
    andRowIdentifier:(NSString *)rowIdentifier
         atIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView
   didChangeValue:(id)value
    forIdentifier:(NSString *)identifier
          forCell:(UITableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView
  setDefaultValue:(id)value
    forIdentifier:(NSString *)identifier;

- (void)tableView:(UITableView *)tableView didSelectRowWithInfo:(NSDictionary *)rowInfo atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowWithInfo:(NSDictionary *)rowInfo rowType:(HKPropertyListRowType)rowType andRowIdentifier:(NSString *)rowIdentifier atIndexPath:(NSIndexPath *)indexPath;

@end
