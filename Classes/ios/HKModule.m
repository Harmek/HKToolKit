//
//  HKModule.m
//  Pods
//
//  Created by Panos.
//
//

#import "HKModule.h"
#import "HKRoutePattern.h"

static BOOL EncodedTypesMatch(const char *type1, const char *type2)
{
    return type1[0] == type2[0];
}

@interface HKModule ()

@property (nonatomic, strong) HKRoutePattern *route;

@end

@implementation HKModule

- (instancetype)initWithViewControllerClass:(Class)vcClass pattern:(NSString *)pattern andSelector:(SEL)selector
{
    self = [self init];
    if (self)
    {
        self.viewControllerClass = vcClass;
        self.route = [[HKRoutePattern alloc] initWithPattern:pattern];
        self.selector = selector;
    }
    
    return self;
}

- (NSString *)pattern
{
    return self.route.pattern;
}

- (SEL)selector
{
    if (!_selector)
    {
        _selector = @selector(init);
    }
    
    return _selector;
}

- (BOOL)canInstanciateWithPath:(NSString *)path
{
    return [self.route matchesPath:path];
}

- (id)instanciateWithPath:(NSString *)path
{
    id instance = [self.viewControllerClass alloc];
    NSMethodSignature *signature = [instance methodSignatureForSelector:self.selector];
    NSAssert(signature != nil, @"%@ does not respond to selector: '%@'",
             instance, NSStringFromSelector(self.selector));
    NSInvocation* invocation =
    ({
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
        [inv setTarget:instance];
        [inv setSelector:self.selector];
        [inv retainArguments];
        inv;
    });
    NSArray *parameters = [self.route resolveParametersFromPath:path];
    for (NSUInteger i = 2; i < signature.numberOfArguments; ++i)
    {
        NSString *parameter = parameters[i - 2];
        const char *argument = [signature getArgumentTypeAtIndex:i];
        if (EncodedTypesMatch(argument, @encode(id)) ||
            EncodedTypesMatch(argument, @encode(Class)))
        {
            [invocation setArgument:&parameter atIndex:i];
        }
        else if (EncodedTypesMatch(argument, @encode(char)) ||
                 EncodedTypesMatch(argument, @encode(unsigned char)))
        {
            unichar value = [parameter characterAtIndex:0];
            [invocation setArgument:&value atIndex:i];
        }
        else if (EncodedTypesMatch(argument, @encode(int)) ||
                 EncodedTypesMatch(argument, @encode(NSInteger)) ||
                 EncodedTypesMatch(argument, @encode(unsigned int)) ||
                 EncodedTypesMatch(argument, @encode(NSUInteger)))
        {
            NSInteger value = [parameter integerValue];
            [invocation setArgument:&value atIndex:i];
        }
        else if (EncodedTypesMatch(argument, @encode(long long)))
        {
            long long value = [parameter longLongValue];
            [invocation setArgument:&value atIndex:i];
        }
        else if (EncodedTypesMatch(argument, @encode(BOOL)))
        {
            BOOL value = [parameter boolValue];
            [invocation setArgument:&value atIndex:i];
        }
        else if (EncodedTypesMatch(argument, @encode(float)))
        {
            float value = [parameter floatValue];
            [invocation setArgument:&value atIndex:i];
        }
        else if (EncodedTypesMatch(argument, @encode(double)))
        {
            double value = [parameter doubleValue];
            [invocation setArgument:&value atIndex:i];
        }
    }
    [invocation invoke];
    void *returnValue = NULL;
    if (signature.methodReturnLength)
    {
        [invocation getReturnValue:&returnValue];
    }
    id result = (__bridge id)(returnValue);
    
    return result;
}

@end
