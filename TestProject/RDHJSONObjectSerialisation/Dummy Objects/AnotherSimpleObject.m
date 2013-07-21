//
//  AnotherSimpleObject.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "AnotherSimpleObject.h"

@interface AnotherSimpleObject ()
{
    NSString *_customProperty;
    NSString *_customAccessorsProperty;
}

@property (nonatomic, strong, readwrite) id valueProperty;

@property (nonatomic, strong) NSString *customProperty;
@property (nonatomic, strong, getter = CAP, setter = sCAP:) NSString *customAccessorsProperty;

@property (nonatomic, strong, readonly) NSString *readOnlyProperty;

@property (nonatomic, strong, readonly) NSString *readOnlyGetterProperty;

@property (nonatomic, strong) NSNumber *numberProperty;

@property (nonatomic) double intPrimProp;

@property (nonatomic)  char *charArrayProp;

@end

@implementation AnotherSimpleObject

+(instancetype)objectWithValue:(id)value
{
    return [[self alloc] initWithValue:value];
}

-(instancetype)initWithValue:(id)value
{
    self = [self init];
    if (self) {
        _valueProperty = value;
        _decimalProperty = [NSDecimalNumber decimalNumberWithString:@"234e-3"];
        _blockProperty = ^{};
        _intPointerProperty = malloc(sizeof(int) * 10);
        _functionPointerDefault = &NSStringFromClass;
        _voidPointerDefault = (id) @"SDFDS";
        _structProperty = (SimpleStruct) {.tttt = 10};
        _c99BoolProperty = YES;
        _cppBoolProperty = true;
        _classProperty = [NSNotificationCenter class];
        
        _customProperty = @"CUSTOM PROPERTY";
        
        _customAccessorsProperty = @"C_A_P";
        
        _readOnlyProperty = @"READONLY_PROP";
        
        _charArrayProp = "ytutytyuy";
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ [valueProperty=%@, decimalProperty=%@, readOnlyProperty=%@, CAP=%@, customerProperty=%@, numberProperty=%@]", [super description], self.valueProperty, self.decimalProperty, self.readOnlyProperty, _customAccessorsProperty, _customProperty, self.numberProperty];
}

-(NSString *)debugDescription
{
    return [self description];
}

-(NSString *)customProperty
{
    return _customProperty;
}

-(void)setCustomProperty:(NSString *)customProperty
{
    _customProperty = customProperty;
}

-(NSString *)CAP
{
    return _customAccessorsProperty;
}

-(void)sCAP:(NSString *)customAccessorsProperty
{
    _customAccessorsProperty = customAccessorsProperty;
}

-(NSString *)readOnlyGetterProperty
{
    return @"READONLY_GETTER";
}

@end
