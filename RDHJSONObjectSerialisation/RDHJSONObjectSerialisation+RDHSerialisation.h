//
//  RDHJSONObjectSerialisation+RDHSerialisation.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation.h"

typedef NS_OPTIONS(NSUInteger, RDHJSONWritingOptions) {
    RDHJSONWritingOptionsConvertNilsToNSNulls = (1UL << 0),
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
