//
//  UIControl+HKToolKit.h
//  Pods
//
//  Created by Panos on 1/11/14.
//
//

#import <UIKit/UIKit.h>

typedef void (^UIControlActionBlock) (void);
typedef void (^UIControlActionSenderBlock) (id sender);
typedef void (^UIControlActionSenderControlEventsBlock) (id sender, UIControlEvents controlEvents);

/**
 *  This opaque type is used to keep track of the blocks added to a control.
 */
typedef id UIControlBlockId;

/**
 *  This extension provides 3 conveniences functions to add an action as a block when a event is fired.
 */
@interface UIControl (HKToolKit)

/**
 *  Adds a block as an action for a particular event (or events) to an internal dispatch table.
 *
 *  @param block         The block that will be called. This block does not take any arguments.
 *  @param controlEvents A bitmask specifying the control events for which the action message is sent.
 *
 *  @return An Id that you can use to remove this action block with `removeControlBlockWithId:forControlEvents:`.
 */
- (UIControlBlockId)addBlock:(UIControlActionBlock)block forControlEvents:(UIControlEvents)controlEvents;

/**
 *  Adds a block as an action for a particular event (or events) to an internal dispatch table.
 *
 *  @param block         The block that will be called. This block takes the event's sender as an argument.
 *  @param controlEvents A bitmask specifying the control events for which the action message is sent.
 *
 *  @return An Id that you can use to remove this action block with `removeControlBlockWithId:forControlEvents:`.
 */
- (UIControlBlockId)addBlockWithSender:(UIControlActionSenderBlock)block
                      forControlEvents:(UIControlEvents)controlEvents;

/**
 *  Adds a block as an action for a particular event (or events) to an internal dispatch table.
 *
 *  @param block         The block that will be called. This block takes the event's sender and the event bitmask as arguments.
 *  @param controlEvents A bitmask specifying the control events for which the action message is sent.
 *
 *  @return An Id that you can use to remove this action block with `removeControlBlockWithId:forControlEvents:`.
 */
- (UIControlBlockId)addBlockWithSenderAndControlEvents:(UIControlActionSenderControlEventsBlock)block
                                      forControlEvents:(UIControlEvents)controlEvents;

/**
 *  Removes an action block for a particular event (or events) from an internal dispatch table.
 *
 *  @param controlBlockId The UIControlBlockId specific to the action block.
 *  @param controlEvents  A bitmask specifying the control events associated with target and action.
 */
- (void)removeControlBlockWithId:(UIControlBlockId)controlBlockId
                forControlEvents:(UIControlEvents)controlEvents;
@end
