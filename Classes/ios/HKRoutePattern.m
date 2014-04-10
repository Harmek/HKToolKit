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
@property (nonatomic, strong) NSURL *url;
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
    self.url = [NSURL URLWithString:_pattern];
}

- (void)setUrl:(NSURL *)url
{
    if (_url == url)
    {
        return;
    }

    _url = url;
    NSArray *pathComponents = [_url.path pathComponents];
    NSIndexSet *indexes = [pathComponents
                           indexesOfObjectsPassingTest:[[self class]
                                                        startsWithColonBlock]];
    self.parametersIndexes = indexes;
    self.parameters = [[pathComponents objectsAtIndexes:indexes]
                       valueForKey:NSStringFromSelector(@selector(copyWithoutColon))];

    NSMutableArray *patternPathComponents = [[self.url.path pathComponents] mutableCopy];
    [self.parametersIndexes
     enumerateIndexesWithOptions:0
     usingBlock:^(NSUInteger idx, BOOL *stop) {
         [patternPathComponents replaceObjectAtIndex:idx withObject:@"([^\\/]+)"];
     }];
    NSString *path = patternPathComponents.count ? [NSString pathWithComponents:patternPathComponents] : nil;
    NSURL *regexUrl = path ? [[NSURL alloc] initWithScheme:self.url.scheme host:self.url.host path:path] : [self.url copy];
    NSString *regexPattern = [NSString stringWithFormat:@"^%@$", [[regexUrl absoluteString]
                                                                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    NSMutableArray *pathComponents = [[self.url.path pathComponents] mutableCopy];
    [pathComponents replaceObjectsAtIndexes:self.parametersIndexes withObjects:resolvedParameters];
    NSString *path = pathComponents.count ? [NSString pathWithComponents:pathComponents] : nil;
    NSURL *resolvedUrlComponents = path ? [[NSURL alloc] initWithScheme:self.url.scheme host:self.url.host path:path] : [self.url copy];

    return [[resolvedUrlComponents absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
