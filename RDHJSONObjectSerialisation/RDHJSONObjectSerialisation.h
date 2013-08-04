//
//  RDHJSONObjectSerialisation.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 */
@interface RDHJSONObjectSerialisation : NSObject

/**
 * Setting this date formatter will affect all dates produced by the seraliser and dates read by the deserialiser.
 * @param dateFormatter the custom date formatter.
 */
+(void)setGlobalDateFormatter:(NSDateFormatter *)dateFormatter;

@end

////////////////////////////////////////////
//////////////// SERIALISER ////////////////
////////////////////////////////////////////

typedef NS_OPTIONS(NSUInteger, RDHJSONWritingOptions) {
    RDHJSONWritingOptionsConvertNilsToNSNulls = (1UL << 0),
    RDHJSONWritingOptionsConvertDatesToUnixTimestamps = (1UL << 1),
    RDHJSONWritingOptionsRaiseExceptions = (1UL << 31)
};

/**
 *
 */
@interface RDHJSONObjectSerialisation (RDHSerialisation)

+(BOOL)isObjectValidForSerialisation:(id)object;

+(NSData *)JSONForObject:(id)object options:(RDHJSONWritingOptions)options error:(NSError *__autoreleasing*)error;

+(id)JSONObjectForObject:(id)object options:(RDHJSONWritingOptions)options;

@end


////////////////////////////////////////////
/////////////// DESERIALISER ///////////////
////////////////////////////////////////////

typedef NS_OPTIONS(NSUInteger, RDHJSONReadingOptions) {
    RDHJSONReadingOptionsDummyOption = (1UL << 0),
    RDHJSONReadingOptionsRaiseExceptions = (1UL << 31)
};

/**
 *
 */
@interface RDHJSONObjectSerialisation (RDHDeserialisation)

/**
 * If the JSON object is an Array, the provided class should be the class of the items in the array. Arrays containing different types are not supported.
 */
+(id)objectOfKind:(Class)cls forJSON:(NSData *)JSON options:(RDHJSONReadingOptions)options error:(NSError *__autoreleasing*)error;

/**
 * If the JSON object is an Array, the provided class should be the class of the items in the array. Arrays containing different types are not supported.
 */
+(id)objectOfKind:(Class)cls forJSONObject:(id)JSON options:(RDHJSONReadingOptions)options;

@end
