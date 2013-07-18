//
//  AnotherSimpleObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDHJSONObjectSerialisation.h"

@interface AnotherSimpleObject : NSObject<RDHJSONObjectSerialisationProtocol>

+(instancetype)objectWithValue:(id)value;

@end

