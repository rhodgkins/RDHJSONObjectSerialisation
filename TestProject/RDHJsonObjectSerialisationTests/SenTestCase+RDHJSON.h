//
//  SenTestCase+RDHJSON.h
//  RDHJSONObjectSerialisationTests
//
//  Created by Richard Hodgkins on 06/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "RDHJSONObjectSerialisation.h"

@interface SenTestCase (RDHJSON)

-(NSString *)JSONstringForObject:(id)object options:(RDHJSONWritingOptions)options;

-(id)objectOfKind:(Class)cls forJSONString:(NSString *)string;

-(void)partialStringTests:(NSString *)test against:(NSString *)against;

@end

@interface NSData (UTF8String)

-(NSString *)UTF8String;

@end

@interface NSString (UTF8Data)

-(NSData *)UTF8Data;

@end