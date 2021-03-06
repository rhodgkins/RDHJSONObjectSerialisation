//
//  RDHJSONObjectSerialisation.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation.h"

#import <objc/runtime.h>

#import "RDHJSONObjectSerialisation+RDHInternal.h"

@interface RDHJSONObjectSerialisation ()

+(NSMutableDictionary *)globalClassPropertyCache;

@property (nonatomic, copy, readonly) NSMutableDictionary *classPropertyCache;

@end

@implementation RDHJSONObjectSerialisation

+(void)setGlobalDateFormatter:(NSDateFormatter *)dateFormatter
{
    [RDHPropertyInfo setDateFormatter:dateFormatter];
}

+(NSMutableDictionary *)globalClassPropertyCache
{
    static NSMutableDictionary *globalClassPropertyCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalClassPropertyCache = [NSMutableDictionary dictionary];
    });
    return globalClassPropertyCache;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _classPropertyCache = [[[self class] globalClassPropertyCache] mutableCopy];
    }
    return self;
}

-(void)dealloc
{
    [[[self class] globalClassPropertyCache] addEntriesFromDictionary:_classPropertyCache];
    [_classPropertyCache removeAllObjects];
    _classPropertyCache = nil;
}

@end

@implementation RDHJSONObjectSerialisation (RDHInternal)

-(NSOrderedSet *)propertiesForClass:(Class)cls
{
    NSValue *key = [NSValue valueWithNonretainedObject:cls];
    
    // See if we've got a cached value
    NSOrderedSet *set = self.classPropertyCache[key];
    if (!set) {
        
        NSMutableOrderedSet *properties = [NSMutableOrderedSet orderedSet];
        
        do {
            uint32_t outCount;
            objc_property_t *ps = class_copyPropertyList(cls, &outCount);
            
            for (NSUInteger i=0; i<outCount; i++) {
                objc_property_t p = ps[i];
                
                RDHPropertyInfo *info = [RDHPropertyInfo infoForProperty:p declaredInClass:cls];
                
                // Parse and add properties
                [properties addObject:info];
            }
            
            if (ps) {
                free(ps);
            }
            ps = NULL;
            
            cls = [cls superclass];
            
        } while (cls && ![[NSObject class] isKindOfClass:cls]);
        
        // Now revsere so properties are serialised from super class down
        set = [properties reversedOrderedSet];
        
        // Cache value
        self.classPropertyCache[key] = set;
    }
    return set;
}

+(BOOL)isValidJSONPrimative:(id)value
{
    if ([self isValidJSONPrimativeClass:[value class]]) {
        
        if ([value isKindOfClass:[NSDecimalNumber class]]) {
            
            // Don't allow NaN as per JSON spec
            if ([[NSDecimalNumber notANumber] isEqualToNumber:value]) {
                return NO;
            }
            
        } else if ([value isKindOfClass:[NSNumber class]]) {
            
            // Don't allow NaN or Inifity as per JSON spec
            if ([@(INFINITY) isEqualToNumber:value] || [@(NAN) isEqualToNumber:value]) {
                return NO;
            }
        }
        
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isValidJSONPrimativeClass:(Class)cls
{
    if ([cls isSubclassOfClass:[NSString class]]) {
        return YES;
    } else if ([cls isSubclassOfClass:[NSDecimalNumber class]]) {
        return YES;
    } else if ([cls isSubclassOfClass:[NSNumber class]]) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)conformsToSerialisationProtocol:(id)value
{
    return [value conformsToProtocol:@protocol(RDHJSONObjectSerialisationProtocol)];
}

@end
