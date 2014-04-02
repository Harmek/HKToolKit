//
//  HKPattern.m
//  Pods
//
//  Created by Panos.
//
//

#import "HKRoutePattern.h"

@interface NSString (HKPattern)

@property (nonatomic, copy, readonly) NSString *copyWithoutColon;

- (BOOL)startsWithColon;

@end

@implementation NSString (HKPattern)

- (NSString *)copyWithoutColon
{
    if (!self.length || ![self hasPrefix:@":"])
    {
        return [self copy];
    }

    return [self substringFromIndex:1];
}

- (BOOL)startsWithColon
{
    return [self hasPrefix:@":"];
}

@end

typedef BOOL (^HKPatternArrayTest)(id obj, NSUInteger idx, BOOL *stop);

@interface HKRoutePattern ()

@property (nonatomic, strong) NSArray *parameters;
@property (nonatomic, strong) NSIndexSet *parametersIndexes;
@property (nonatomic, strong) NSURLComponents *urlComponents;
@property (nonatomic, strong) NSRegularExpression *regularExpression;

@end

@implementation HKRoutePattern

+ (HKPatternArrayTest)startsWithColonBlock
{
    static HKPatternArrayTest s_block;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_block = ^(NSString *obj, NSUInteger idx, BOOL *stop)
        {
            return [obj hasPrefix:@":"];
        };
    });

    return s_block;
}

- (instancetype)initWithPattern:(NSString *)pattern
{
    self = [super init];
    if (self)
    {
        self.pattern = pattern;
    }

    return self;
}

- (void)setPattern:(NSString *)pattern
{
    if (_pattern == pattern)
    {
        return;
    }
    _pattern = [pattern copy];
    self.urlComponents = [NSURLComponents componentsWithString:_pattern];
}

- (void)setUrlComponents:(NSURLComponents *)urlComponents
{
    if (_urlComponents == urlComponents)
    {
        return;
    }

    _urlComponents = urlComponents;
    NSArray *pathComponents = [_urlComponents.path pathComponents];
    NSIndexSet *indexes = [pathComponents
                           indexesOfObjectsPassingTest:[[self class]
                                                        startsWithColonBlock]];
    self.parametersIndexes = indexes;
    self.parameters = [[pathComponents objectsAtIndexes:indexes]
                       valueForKey:NSStringFromSelector(@selector(copyWithoutColon))];

    NSMutableArray *patternPathComponents = [[self.urlComponents.path pathComponents] mutableCopy];
    [self.parametersIndexes
     enumerateIndexesWithOptions:0
     usingBlock:^(NSUInteger idx, BOOL *stop) {
         [patternPathComponents replaceObjectAtIndex:idx withObject:@"([^\\/]+)"];
     }];
    NSURLComponents *regexUrlComponents = [self.urlComponents copy];
    regexUrlComponents.path  = patternPathComponents ? [NSString pathWithComponents:patternPathComponents] : nil;
    NSString *regexPattern = [NSString stringWithFormat:@"^%@$", [[[regexUrlComponents URL] absoluteString] stringByRemovingPercentEncoding]];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexPattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    if (error)
    {
        NSLog(@"%@", error);
    }
    self.regularExpression = regex;
}

- (NSString *)stringWithParameters:(NSDictionary *)parameters
{
    NSArray *resolvedParameters = [parameters objectsForKeys:self.parameters
                                              notFoundMarker:@""];
    NSMutableArray *pathComponents = [[self.urlComponents.path pathComponents] mutableCopy];
    [pathComponents replaceObjectsAtIndexes:self.parametersIndexes withObjects:resolvedParameters];

    NSURLComponents *resolvedUrlComponents = [self.urlComponents copy];
    resolvedUrlComponents.path = [NSString pathWithComponents:pathComponents];

    return [[[resolvedUrlComponents URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)matchesPath:(NSString *)path
{
    NSTextCheckingResult *result = [self.regularExpression
                                    firstMatchInString:path
                                    options:NSMatchingReportCompletion
                                    range:NSMakeRange(0, path.length)];
    NSRange range = result.range;

    return range.location != NSNotFound && range.length != 0;
}

- (NSArray *)resolveParametersFromPath:(NSString *)path
{
    if (!self.parametersIndexes)
    {
        return nil;
    }

    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    path = url.path;
    NSArray *pathComponents = [path pathComponents];
    NSArray *unescapedParameters = [pathComponents objectsAtIndexes:self.parametersIndexes];
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:unescapedParameters.count];
    [unescapedParameters
     enumerateObjectsWithOptions:0
     usingBlock:^(NSString *parameter, NSUInteger idx, BOOL *stop) {
         [parameters addObject:[parameter stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     }];

    return parameters;
}

#pragma mark – Equality

- (NSUInteger)hash
{
    NSString *hashString = [NSString stringWithFormat:@"(%@)%@",
                            NSStringFromClass([self class]),
                            self.pattern];

    return [hashString hash];
}

- (BOOL)isEqualToPattern:(HKRoutePattern *)pattern
{
    return [self.pattern isEqualToString:pattern.pattern];
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }

    if (![object isKindOfClass:[self class]])
    {
        return NO;
    }

    return [self isEqualToPattern:object];
}

#pragma mark – NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        NSString *pattern = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(pattern))];
        self.pattern = pattern;
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.pattern
                  forKey:NSStringFromSelector(@selector(pattern))];
}

#pragma mark – NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    HKRoutePattern *copyPattern = [[[self class] alloc]
                                   initWithPattern:self.pattern];

    return copyPattern;
}

@end
