//
//  RDHJSONObjectSerialisation+RDHDeserialisation.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation.h"

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
