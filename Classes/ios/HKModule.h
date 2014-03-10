//
//  HKModule.h
//  Pods
//
//  Created by Panos.
//
//

#import <Foundation/Foundation.h>

@interface HKModule : NSObject

@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, strong, readonly) NSString *pattern;
@property (nonatomic, assign) SEL selector;

- (instancetype)initWithViewControllerClass:(Class)vcClass pattern:(NSString *)pattern andSelector:(SEL)selector;
- (id)instanciateWithPath:(NSString *)path;
- (BOOL)canInstanciateWithPath:(NSString *)path;

@end
