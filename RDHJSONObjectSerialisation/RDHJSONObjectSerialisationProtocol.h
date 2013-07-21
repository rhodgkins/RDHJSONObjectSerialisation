//
//  RDHJSONObjectSerialisationProtocol.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RDHJSONObjectSerialisationProtocol <NSObject>

@optional

/**
 * Used for deserialisation.
 * @returns class of the items in the array property. Arrays containing different types are not supported.
 */
+(Class)classForObjectsInArrayProperty:(NSString *)property;

/**
 * Used for deserialisation.
 * @returns class of the item in the dictionary property. Arrays containing different types are not supported.
 */
+(Class)classForObjectWithKey:(NSString *)key forDictionaryProperty:(NSString *)property;

/**
 * @returns YES if this property should be included in the JSON output, NO otherwise.
 */
+(BOOL)shouldSerialiseProperty:(NSString *)propertyName;

/**
 * @returns YES if this property should be included in the object output, NO otherwise.
 */
+(BOOL)shouldDeserialiseProperty:(NSString *)propertyName;

/**
 * @returns the serialisation field name for this property, returning nil here is the same as returning the paramter.
 */
+(NSString *)serialisationNameForProperty:(NSString *)propertyName;

+(id)serialisationValueForValue:(id)value forProperty:(NSString *)propertyName;

+(id)deserialisationValueForValue:(id)value forProperty:(NSString *)propertyName;

@end
