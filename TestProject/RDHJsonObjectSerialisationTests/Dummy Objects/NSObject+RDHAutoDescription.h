//
//  NSObject+RDHAutoDescription.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 06/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RDHAutoDescription)

-(NSString *)autoDescription;

-(NSUInteger)autoHash;

@end
