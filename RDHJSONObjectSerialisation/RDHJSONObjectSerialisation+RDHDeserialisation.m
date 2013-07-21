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
            id object = [self objectOfKind:cls forJSONObject:item options:options];
            [array addObject:object];
        }
        
        return [array copy];
        
    } else {
        
        NSAssert([[self class] conformsToSerialisationProtocol:cls], @"Object does not conform to %@", NSStringFromProtocol(@protocol(RDHJSONObjectSerialisationProtocol)));
        
        id object = [cls new];
        
        NSOrderedSet *properties = [self propertiesForClass:[object class]];
        
        for (RDHPropertyInfo *info in properties) {
            
            if (info.canDeserialise && info.canSetValue) {
                
                id jsonValue = JSONObject[info.serialisationName];
                
                id value = [self objectForJSONObject:jsonValue withInfo:info options:options];
                
                [info setValue:value onObject:object];
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
            
//            if (info.type == RDH)
            
        }
    }
    
    return nil;
}

@end
