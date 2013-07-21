//
//  SimpleObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDHJSONObjectSerialisationProtocol.h"

@interface SimpleObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, copy) NSString *interfaceProperty;

@end
