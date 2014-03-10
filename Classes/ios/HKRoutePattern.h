//
//  HKPattern.h
//  Pods
//
//  Created by Panos.
//
//

#import <Foundation/Foundation.h>

@interface HKRoutePattern : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *pattern;
@property (nonatomic, strong, readonly) NSArray *parameters;

- (instancetype)initWithPattern:(NSString *)pattern;

- (NSString *)stringWithParameters:(NSDictionary *)parameters;

- (BOOL)isEqualToPattern:(HKRoutePattern *)pattern;

- (BOOL)matchesPath:(NSString *)path;

- (NSArray *)resolveParametersFromPath:(NSString *)path;

@end
