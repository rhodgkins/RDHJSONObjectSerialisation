//
//  ExtendedSimpleObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "SimpleObject.h"

@interface ExtendedSimpleObject : SimpleObject

@property (nonatomic, copy, getter = IPSC, setter = setIPSC:) NSString *interfacPropertySubClass;

@end
