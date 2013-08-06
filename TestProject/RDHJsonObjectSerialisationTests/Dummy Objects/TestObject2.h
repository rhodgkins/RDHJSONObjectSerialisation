//
//  TestObject2.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "TestObject.h"

static NSString *const RDH_KEY_COCOCA = @"COCOA_OBJECT";
static NSString *const RDH_KEY_CUSTOM = @"CUSTOM_OBJECT";

@interface TestObject2 : TestObject

@property (nonatomic, strong) NSString *excludedBothStrProp;

@property (nonatomic, strong) NSString *excludedSerialisationStrProp;

@property (nonatomic, strong) NSString *excludedDeserialisationStrProp;

@property (nonatomic, strong) NSString *renamedStrProp;

@property (nonatomic, strong) NSDictionary *dictObjectProp;

@property (nonatomic, strong) NSDictionary *dictStringProp;
@property (nonatomic, strong) NSDictionary *dictNumberProp;

@property (nonatomic, strong) TestObject *objectPropInSubClass;

@end
