//
//  RDHJSONObjectSerialisation+RDHDeserialisation.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation+RDHDeserialisation.h"

#import "RDHJSONObjectSerialisation_RDHInternal.h"

@implementation RDHJSONObjectSerialisation (RDHDeserialisation)

+(id)objectOfKind:(Class)cls forJSONObject:(id)JSONObject options:(RDHJSONReadingOptions)options
{
    RDHJSONObjectSerialisation *deserialiser = [self new];
    return [deserialiser objectOfKind:cls forJSONObject:JSONObject options:options];
}

+(id)objectOfKind:(Class)cls forJSON:(NSData *)JSON options:(RDHJSONReadingOptions)options error:(NSError *__autoreleasing *)error
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:JSON options:0 error:error];
    return [self objectOfKind:cls forJSONObject:jsonObject options:options];
}

-(id)objectOfKind:(Class)cls forJSONObject:(id)JSONObject options:(RDHJSONReadingOptions)options
{
    NSParameterAssert(cls);
    NSParameterAssert(JSONObject);
    
    if ([cls isSubclassOfClass:[NSDictionary class]] && [JSONObject isKindOfClass:cls]) {
        return JSONObject;
    }
    
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[JSONObject count]];
        
        for (id item in JSONObject) {
            id object = item;
            if (![[self class] isValidJSONPrimativeClass:cls]) {
                object = [self objectOfKind:cls forJSONObject:object options:options];
            }
            [array addObject:object];
        }
        
        return [array copy];
        
    } else {
        
        NSAssert([[self class] conformsToSerialisationProtocol:cls], @"Object does not conform to %@", NSStringFromProtocol(@protocol(RDHJSONObjectSerialisationProtocol)));
        
        id object = [cls new];
        
        NSOrderedSet *properties = [self propertiesForClass:[object class]];
        
        for (RDHPropertyInfo *info in properties) {
            
            if (info.canDeserialise && info.canSetValue) {
                
                @try {
                    if ([RDHPropertyInfo typeImplmented:info.type]) {
                        id jsonValue = JSONObject[info.serialisationName];
                        
                        id value = [self objectForJSONObject:jsonValue withInfo:info options:options];
                        
                        [info setValue:value onObject:object];
                        
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
        
        return object;
    }
}

-(id)objectForJSONObject:(id)JSONObject withInfo:(RDHPropertyInfo *)info options:(RDHJSONReadingOptions)options
{
    if (JSONObject) {
        
        if ([[NSNull null] isEqual:JSONObject]) {
            // Ignore nulls
        } else {
            
            if ([[self class] isValidJSONPrimative:JSONObject]) {
                return JSONObject;
            } else if ([JSONObject isKindOfClass:[NSArray class]]) {
                return [self objectOfKind:[info classForObjectsIfArray] forJSONObject:JSONObject options:options];
            } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[JSONObject count]];
                for (NSString *key in JSONObject) {
                    
                    Class cls = [info classForObjectIfDictionaryPropertyWithKey:key];
                    id JSONValue = JSONObject[key];
                    
                    if (cls && JSONValue) {
                        id value = JSONValue;
                        if (![[self class] isValidJSONPrimativeClass:cls]) {
                            value = [self objectOfKind:cls forJSONObject:value options:options];
                        }
                        [dict setValue:value forKey:key];
                    }
                }
                return [dict copy];
            }
            
        }
    }
    
    return nil;
}

@end
