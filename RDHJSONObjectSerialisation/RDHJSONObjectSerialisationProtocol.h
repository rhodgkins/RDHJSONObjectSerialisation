//
//  RDHJSONObjectSerialisationProtocol.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This protocol should be adopted by any object that wants to be used with RDHJSONObjectSerialisation.
 *
 * While none of the methods are required, the protocol itself should be adopted so the serialiser
 * will know which classes to ignore.
 */
@protocol RDHJSONObjectSerialisationProtocol <NSObject>

@optional

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

/**
 * Used for deserialisation. If the objects inside this array are simple types (NSString, NSNumber, NSDate, NSData, NSArray, NSDictionary) then they will be automatically deserialised.
 * @returns class of the items in the array property. Arrays containing different types are not supported. Return nil for attempted automatic deserialisation.
 */
+(Class)classForObjectsInArrayProperty:(NSString *)property;

/**
 * Used for deserialisation. If the objects inside this dictionary are simple types (NSString, NSNumber, NSDate, NSData, NSArray, NSDictionary) then they will be automatically deserialised.
 * @returns class of the item in the dictionary property. Return nil for attempted automatic deserialisation.
 */
+(Class)classForObjectWithKey:(NSString *)key forDictionaryProperty:(NSString *)property;

/**
 * This method can be used for custom serialisation of property values. For example, say this property is declared as a NSDate, you might want to serialise it to a string of a certain format in the JSON.
 * @returns the custom serialisation value, or the value itself if no serailisation is desired.
 */
+(id)serialisationValueForValue:(id)value forProperty:(NSString *)propertyName;

/**
 * This method can be used for custom serialisation of property values. For example, say the JSON value is a string and the property is declared as a NSDate, you can use this method to parse the string to a valid NSDate from a custom format.
 * @returns the custom deserialisation value, or the value itself if no deserialisation is desired.
 */
+(id)deserialisationValueForValue:(id)value forProperty:(NSString *)propertyName;

@end
