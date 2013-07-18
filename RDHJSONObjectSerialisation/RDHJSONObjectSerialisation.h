//
//  RDHJSONObjectSerialisation.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RDHJSONObjectSerialisationProtocol <NSObject>

@optional

+(BOOL)shouldSerialiseProperty:(NSString *)propertyName;

+(NSString *)serialisationNameForProperty:(NSString *)propertyName;

@end

typedef NS_OPTIONS(NSUInteger, RDHJSONWritingOptions) {
    RDHJSONWritingOptionsConvertNilsToNSNulls = (1UL << 0)
};

@interface RDHJSONObjectSerialisation : NSObject

+(NSDictionary *)dictionaryForObject:(NSObject<RDHJSONObjectSerialisationProtocol> *)object options:(RDHJSONWritingOptions)options;

@end
