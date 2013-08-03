//
//  RDHJSONObjectSerialisation+RDHSerialisation.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation+RDHSerialisation.h"

#import "RDHJSONObjectSerialisation+RDHInternal.h"

@implementation RDHJSONObjectSerialisation (RDHSerialisation)

+(BOOL)isObjectValidForSerialisation:(id)object
{
    return [self conformsToSerialisationProtocol:object] || [NSJSONSerialization isValidJSONObject:object];
}

+(NSData *)JSONForObject:(id)object options:(RDHJSONWritingOptions)options error:(NSError *__autoreleasing *)error
{
    id jsonObject = [self JSONObjectForObject:object options:options];
    return [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:error];
}

+(id)JSONObjectForObject:(id)object options:(RDHJSONWritingOptions)options
{
    RDHJSONObjectSerialisation *serialiser = [self new];
    return [serialiser JSONForObject:object options:options];
}

-(id)JSONForObject:(id)object options:(RDHJSONWritingOptions)options
{
    if (!object) {
        return nil;
    }
    
    if ([NSJSONSerialization isValidJSONObject:object]) {
        return object;
    } else if (![[self class] conformsToSerialisationProtocol:object]) {
        
        NSAssert([[self class] isObjectValidForSerialisation:object], @"Object is not able to be serialised: %@", object);
        
        return nil;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSOrderedSet *properties = [self propertiesForClass:[object class]];
    
    for (RDHPropertyInfo *info in properties) {
        
        if (info.canSerialise) {
            
            @try {
                if ([RDHPropertyInfo typeImplmented:info.type]) {
                    
                    NSString *key = info.serialisationName;
                    id value = [info getValueFromObject:object];
                    
                    [dict setValue:[[self class] JSONValueForObject:value options:options] forKey:key];
                    
//            NSLog(@"(%@) %@ : %@ -> %@ (%d)", property, [value class], value, dict[key], [self isValidJSONPrimative:value]);
                } else {
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Serialisation has not been implemented for the type %@ for property %@ declared in class %@", [RDHPropertyInfo stringForType:info.type orClass:info.typeClass], info.name, NSStringFromClass(info.declaingClass)] userInfo:nil];
                }
            } @catch (NSException *exception) {
                if (options & RDHJSONWritingOptionsRaiseExceptions) {
                    [exception raise];
                }
            }
        }
    }
    
    return dict;
}

+(id)JSONValueForObject:(id)value options:(RDHJSONWritingOptions)options
{
    if (value) {
        if ([NSJSONSerialization isValidJSONObject:value]) {
            return value;
            
        } else if ([self isValidJSONPrimative:value]) {
            return value;
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            return [self JSONForArray:value options:options];
            
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            return [self JSONForDictionary:value options:options];
            
        } else if ([value isKindOfClass:[NSData class]]) {
            return [RDHUtils base64StringFromData:value];
            
        } else if ([self conformsToSerialisationProtocol:value]) {
            return [self JSONObjectForObject:value options:options];
            
        } else if ([value isKindOfClass:[NSDate class]]) {
            
            if (options & RDHJSONWritingOptionsConvertDatesToUnixTimestamps) {
                return @((long) round([value timeIntervalSince1970]));
            } else {
                return [[RDHPropertyInfo dateFormatter] stringFromDate:value];
            }
        }
    
    } else {
        if (options & RDHJSONWritingOptionsConvertNilsToNSNulls) {
            return [NSNull null];
        }
    }
    
    return nil;
}

+(NSArray *)JSONForArray:(NSArray *)array options:(RDHJSONWritingOptions)options
{
    NSMutableArray *json = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (id a in array) {
        id v = [self JSONValueForObject:a options:options];
        if (v) {
            // Can only store valid JSON objects
            [json addObject:v];
        }
    }
    
    return json;
}

+(NSDictionary *)JSONForDictionary:(NSDictionary *)dict options:(RDHJSONWritingOptions)options
{
    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
    
    for (id key in dict) {
        id obj = dict[key];
        
        if ([key isKindOfClass:[NSString class]]) {
            // Can only use string keys
            id v = [self JSONValueForObject:obj options:options];
            if (v) {
                json[key] = v;
            }
        }
    }
    
    return json;
}

@end

