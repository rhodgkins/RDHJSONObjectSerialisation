//
//  NSObject+RDHAutoDescription.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 06/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "NSObject+RDHAutoDescription.h"

#import <objc/runtime.h>

@implementation NSObject (RDHAutoDescription)

-(void)addPropertiesToDictionary:(NSMutableDictionary *)props forClass:(Class)cls
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList(cls, &count);
    
    for (NSUInteger i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(list[i])];
        if ([@"tag" isEqualToString:name]) {
            continue;
        }
        
        id v = [self valueForKey:name];
        if (!v) {
            v = @"nil";
        } else if ([v isKindOfClass:[NSDate class]]) {
            static NSDateFormatter *df;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                df = [NSDateFormatter new];
                [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZZ"];
            });
            v = [df stringFromDate:v];
        }
        [props setValue:v forKey:name];
    }
    
    if (list) {
        free(list);
    }
}

-(NSString *)autoDescription
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    Class cls = [self class];
    do {
        [self addPropertiesToDictionary:props forClass:cls];
        cls = [cls superclass];
    } while (cls && ![[NSObject class] isKindOfClass:cls]);
    
    NSString *s = [props description];
    s = [s stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    return [NSString stringWithFormat:@"%@->%@", NSStringFromClass([self class]), s];
}

-(NSUInteger)autoHash
{
    return [[self autoDescription] hash];
}

@end
