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

+(void)setGlobalDateFormatter:(NSDateFormatter *)dateFormatter;

@end

#import "RDHJSONObjectSerialisation+RDHSerialisation.h"
#import "RDHJSONObjectSerialisation+RDHDeserialisation.h"
