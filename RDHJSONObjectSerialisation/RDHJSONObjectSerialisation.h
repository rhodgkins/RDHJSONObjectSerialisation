//
//  RDHJSONObjectSerialisation.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Base class for serialisation/deserialisation.
 */
@interface RDHJSONObjectSerialisation : NSObject

/**
 * Setting this date formatter will affect all dates produced by the seraliser and dates read by the 
 * deserialiser. This can be overriden by the protocol methods RDHJSONObjectSerialisationProtocol#serialisationValueForValue:forProperty: 
 * and RDHJSONObjectSerialisationProtocol#deserialisationValueForValue:forProperty:
 * @param dateFormatter the custom date formatter.
 */
+(void)setGlobalDateFormatter:(NSDateFormatter *)dateFormatter;

@end

////////////////////////////////////////////
//////////////// SERIALISER ////////////////
////////////////////////////////////////////

/// Options available when serialising.
typedef NS_OPTIONS(NSUInteger, RDHJSONWritingOptions) {
    /// Value to use instead of passing in 0 as an option parameter.
    RDHJSONWritingOptionsNoOptions = 0,
    /// Any properties that are `nil` will be outputted as NSNull#null and eventually `null` in the JSON.
    RDHJSONWritingOptionsConvertNilsToNulls = (1UL << 0),
    /// Any date properties will be outputted as Unix timestamps in seconds.
    RDHJSONWritingOptionsConvertDatesToUnixTimestamps = (1UL << 1),
    /// Used for debugging any problems with serialisation.
    RDHJSONWritingOptionsRaiseExceptions = (1UL << 31)
};

/**
 * Serialisation methods.
 */
@interface RDHJSONObjectSerialisation (RDHSerialiser)

/**
 * Tests to see if an object can be serialised using RDHJSONObjectSerialisation.
 *
 * The rules are any of the following:
 * - The object conforms to RDHJSONObjectSerialisationProtocol
 * - NSJSONSerialization#isValidJSONObject with the provided object returns YES
 * @param object the object to test.
 * @returns YES if the object can be serialised, NO otherwise.
 */
+(BOOL)isObjectValidForSerialisation:(id)object;

/**
 * Serialises an object to a JSON string (but returned as NSData).
 * @param object the object to serialise, which should conform to RDHJSONObjectSerialisationProtocol, or be a NSArray or NSDictionary.
 * @param options writing options for the serialisation.
 * @param error errors that occur from NSJSONSerialization.
 * @returns a string as a JSON representation encoded as NSData. If an error occuring during NSJSONSerialization nil is returned.
 * @see #JSONObjectForObject:options:
 */
+(NSData *)JSONForObject:(id)object options:(RDHJSONWritingOptions)options error:(NSError *__autoreleasing*)error;

/**
 * Serialises an object to a NSDictionary/NSArray.
 * @param object the object to serialise, which should conform to RDHJSONObjectSerialisationProtocol, or be a NSArray or NSDictionary.
 * @param options writing options for the serialisation.
 * @returns a JSON representation as a NSArray or NSDictionary which can be passed into NSJSONSerialization#dataWithJSONObject:options:error
 * @see #JSONForObject:options:error
 */
+(id)JSONObjectForObject:(id)object options:(RDHJSONWritingOptions)options;

@end


////////////////////////////////////////////
/////////////// DESERIALISER ///////////////
////////////////////////////////////////////

/// Options available when deserialising.
typedef NS_OPTIONS(NSUInteger, RDHJSONReadingOptions) {
    /// Value to use instead of passing in 0 as an option parameter.
    RDHJSONReadingOptionsNoOptions = 0,
    /// Used for debugging any problems with deserialisation.
    RDHJSONReadingOptionsRaiseExceptions = (1UL << 31)
};

/**
 * Deserialisation methods.
 */
@interface RDHJSONObjectSerialisation (RDHDeserialiser)

/**
 * If the JSON object is an Array, the provided class should be the class of the items in the array. Arrays containing different types are not supported.
 * If the cls is a NSDictionary and JSON is an object, then the JSONObject is returned.
 * @param cls the class that should be used as a template for deserialisation. This should conform to RDHJSONObjectSerialisationProtocol.
 * @param JSONObject an NSArray or NSDictionary from NSJSONSerialization#JSONObjectWithData:options:error:
 * @param options reading options for the deserialisation.
 * @param error errors that occur from NSJSONSerialization
 * @returns an object of kind cls populated by the provided JSON. If an error occuring during NSJSONSerialization nil is returned.
 * @see #objectOfKind:forJSONObject:options
 */
+(id)objectOfKind:(Class)cls forJSON:(NSData *)JSON options:(RDHJSONReadingOptions)options error:(NSError *__autoreleasing*)error;

/**
 * If the JSON object is an Array, the provided class should be the class of the items in the array. Arrays containing different types are not supported.
 * If the cls is a NSDictionary and JSONObject is a NSDictionary, then the JSONObject is returned.
 * @param cls the class that should be used as a template for deserialisation. This should conform to RDHJSONObjectSerialisationProtocol.
 * @param JSONObject an NSArray or NSDictionary from NSJSONSerialization#JSONObjectWithData:options:error:
 * @param options reading options for the deserialisation.
 * @returns an object of kind cls populated by the provided JSON.
 * @see #objectOfKind:forJSON:options:error
 */
+(id)objectOfKind:(Class)cls forJSONObject:(id)JSONObject options:(RDHJSONReadingOptions)options;

@end
