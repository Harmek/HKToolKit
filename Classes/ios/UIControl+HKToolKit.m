//
//  UIControl+HKToolKit.m
//  Pods
//
//  Created by Panos on 1/11/14.
//
//

#import "UIControl+HKToolKit.h"
#import <objc/runtime.h>

static const void *HKControlTargetsKey = &HKControlTargetsKey;

@interface HKControlTarget : NSObject

@property (nonatomic, strong) id block;

- (instancetype)initWithBlock:(id)block;
- (void)controlFired;
- (void)controlFiredWithSender:(UIControl *)sender;
- (void)controlFiredWithSender:(UIControl *)sender
             withControlEvents:(UIControlEvents)controlEvents;

@end

@implementation HKControlTarget

- (instancetype)initWithBlock:(id)block
{
    self = [super init];
    if (self)
    {
        self.block = block;
    }
    
    return self;
}

- (void)controlFired
{
    UIControlActionBlock block = self.block;
    if (block)
    {
        block();
    }
}

- (void)controlFiredWithSender:(UIControl *)sender
{
    UIControlActionSenderBlock block = self.block;
    if (block)
    {
        block(sender);
    }
}

- (void)controlFiredWithSender:(UIControl *)sender
             withControlEvents:(UIControlEvents)controlEvents
{
    UIControlActionSenderControlEventsBlock block = self.block;
    if (block)
    {
        block(sender, controlEvents);
    }
}

@end

@implementation UIControl (HKToolKit)

- (NSMutableSet *)targets
{
    NSMutableSet *targets = objc_getAssociatedObject(self, HKControlTargetsKey);
    if (!targets)
    {
        targets = [NSMutableSet set];
        objc_setAssociatedObject(self,
                                 HKControlTargetsKey,
                                 targets,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return targets;
}

- (HKControlTarget *)createControlTargetWithBlock:(id)block
{
    HKControlTarget *controlTarget = [[HKControlTarget alloc] initWithBlock:block];
    [self.targets addObject:controlTarget];
    
    return controlTarget;
}

- (UIControlBlockId)addBlock:(UIControlActionBlock)block
            forControlEvents:(UIControlEvents)controlEvents
{
    HKControlTarget *controlTarget = [self createControlTargetWithBlock:block];
    [self addTarget:controlTarget
             action:@selector(controlFired)
   forControlEvents:controlEvents];
    
    return controlTarget;
}

- (UIControlBlockId)addBlockWithSender:(UIControlActionSenderBlock)block
                      forControlEvents:(UIControlEvents)controlEvents
{
    HKControlTarget *controlTarget = [self createControlTargetWithBlock:block];
    [self addTarget:controlTarget
             action:@selector(controlFiredWithSender:)
   forControlEvents:controlEvents];
    
    return controlTarget;
}

- (UIControlBlockId)addBlockWithSenderAndControlEvents:(UIControlActionSenderControlEventsBlock)block
                                      forControlEvents:(UIControlEvents)controlEvents
{
    HKControlTarget *controlTarget = [self createControlTargetWithBlock:block];
    [self addTarget:controlTarget
             action:@selector(controlFiredWithSender:withControlEvents:)
   forControlEvents:controlEvents];
    
    return controlTarget;
}

- (void)removeControlBlockWithId:(UIControlBlockId)controlBlockId
                forControlEvents:(UIControlEvents)controlEvents
{
    NSParameterAssert([controlBlockId isKindOfClass:[HKControlTarget class]]);
    
    NSMutableSet *targets = self.targets;
    HKControlTarget *controlTarget = controlBlockId;
    [targets removeObject:controlBlockId];
    NSArray *actions = [self actionsForTarget:controlTarget
                              forControlEvent:controlEvents];
    [actions
     enumerateObjectsWithOptions:0
     usingBlock:^(NSString *selectorString, NSUInteger idx, BOOL *stop) {
         SEL action = NSSelectorFromString(selectorString);
         [self removeTarget:controlTarget
                     action:action
           forControlEvents:controlEvents];
     }];
}

@end
