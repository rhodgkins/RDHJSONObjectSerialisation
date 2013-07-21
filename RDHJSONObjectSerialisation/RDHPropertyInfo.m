//
//  RDHPropertyInfo.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHPropertyInfo.h"

#import "RDHJSONObjectSerialisationProtocol.h"

#import "RDHUtils.h"

typedef NS_ENUM(char, RDHPropertyAttribute)
{
    RDHPropertyAttributeType = 'T',
    RDHPropertyAttributeIVar = 'V',
    RDHPropertyAttributeReadonly = 'R',
    RDHPropertyAttributeNonAtomic = 'N',
    RDHPropertyAttributeGetter = 'G',
    RDHPropertyAttributeSetter = 'S',
    RDHPropertyAttributeDynamic = 'D',
    RDHPropertyAttributeAssign = '\0',
    RDHPropertyAttributeWeak = 'W',
    RDHPropertyAttributeStrong = '&',
    RDHPropertyAttributeCopy = 'C',
    RDHPropertyAttributeEligibleForGarbageCollection = 'P'
};

static NSString * RDHValueForAttributeStarting(const char **attr)
{
    NSMutableData *d = [NSMutableData data];
    
    // Skip first character
    char c = *(++(*attr));
    // Continue till comma (which indicates end of attribute) or end of string
    while (c != ',' && c != '\0') {
        [d appendBytes:*attr length:1];
        c = *(++(*attr));
    }
    
    if ([d length] > 0) {
        return [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    } else {
        return nil;
    }
}

@interface RDHPropertyInfo ()

@property (nonatomic, copy, readonly) NSString *getter;
@property (nonatomic, copy, readonly) NSString *setter;
@property (nonatomic, assign, readonly) Ivar iVar;

@property (nonatomic, copy, readonly) NSString *getterName;

@property (nonatomic, assign, readonly) RDHPropertyAttribute kind;

@property (nonatomic, assign, readonly) BOOL hasCustomSerialisationMethod;
@property (nonatomic, assign, readonly) BOOL hasCustomDeserialisationMethod;

@end

@implementation RDHPropertyInfo

+(instancetype)infoForProperty:(objc_property_t)prop declaredInClass:(Class)declaringClass
{
    return [[self alloc] initWithProperty:prop declaredInClass:declaringClass];
}

-(instancetype)initWithProperty:(objc_property_t)prop declaredInClass:(Class)declaringClass
{
    self = [self init];
    if (self) {
        NSParameterAssert(declaringClass);
        _declaingClass = declaringClass;
        _name = [NSString stringWithUTF8String:property_getName(prop)];
        NSParameterAssert(_name);
        
        const char *propAttrs = property_getAttributes(prop);
        NSAssert(propAttrs[0] != '\0', @"Property attribute string is empty for property: %@", _name);
        
        NSString *typeString = nil;
        NSString *iVarName = nil;
        
        _kind = RDHPropertyAttributeAssign;
        _eligibleForGarbageCollection = NO;
        _readonly = NO;
        _nonatomic = NO;
        _dynamic = NO;
        
        //        NSLog(@"%s", propAttrs);
        do {
            RDHPropertyAttribute attr = *propAttrs;
            NSString *value = RDHValueForAttributeStarting(&propAttrs);
            
            // Look for code
            switch (attr) {
                case RDHPropertyAttributeType:
                    // The property type @encode.
                    typeString = value;
                    break;
                    
                case RDHPropertyAttributeGetter:
                    // The property defines a custom getter selector name.
                    _getter = value;
                    break;
                    
                case RDHPropertyAttributeSetter:
                    // The property defines a custom setter selector name.
                    _setter = value;
                    
                case RDHPropertyAttributeIVar:
                    // The iVar backing the property
                    iVarName = value;
                    break;
                    
                case RDHPropertyAttributeReadonly:
                    // The property is read-only (readonly).
                    _readonly = YES;
                    break;
                    
                case RDHPropertyAttributeEligibleForGarbageCollection:
                    // The property is eligible for garbage collection.
                    _eligibleForGarbageCollection = YES;
                    break;
                    
                case RDHPropertyAttributeDynamic:
                    _dynamic = YES;
                    break;
                    
                case RDHPropertyAttributeNonAtomic:
                    _nonatomic = YES;
                    break;
                    
                case RDHPropertyAttributeAssign:
                    break;
                    
                case RDHPropertyAttributeWeak:
                case RDHPropertyAttributeStrong:
                case RDHPropertyAttributeCopy:
                    _kind = attr;
                    break;
            }
        } while (*(propAttrs++) != '\0');
        
        _type = [[self class] typeFromEncodedString:typeString];
        if (_type == RDHPropertyTypeObject) {
            _typeClass = [[self class] classFromEncodedClassString:typeString];
        } else {
            _typeClass = nil;
        }
        
        _iVar = NULL;
        if (iVarName) {
            NSAssert([iVarName canBeConvertedToEncoding:NSASCIIStringEncoding], @"iVar name cannot be converted: %@", iVarName);
            _iVar = class_getInstanceVariable(declaringClass, [iVarName cStringUsingEncoding:NSASCIIStringEncoding]);
        }
        
        const BOOL checkForSerialisingProperty = [declaringClass respondsToSelector:@selector(shouldSerialiseProperty:)];
        const BOOL checkForDeserialisingProperty = [declaringClass respondsToSelector:@selector(shouldDeserialiseProperty::)];
        const BOOL checkForSerialisationNameForProperty = [declaringClass respondsToSelector:@selector(serialisationNameForProperty:)];
        
        _hasCustomSerialisationMethod = [declaringClass respondsToSelector:@selector(serialisationValueForValue:forProperty:)];
        _hasCustomDeserialisationMethod = [declaringClass respondsToSelector:@selector(deserialisationValueForValue:forProperty:)];
        
        _canSerialise = checkForSerialisingProperty ? [declaringClass shouldSerialiseProperty:_name] : YES;
        _canDeserialise = checkForDeserialisingProperty ? [declaringClass shouldDeserialiseProperty:_name] : YES;
        _serialisationName = checkForSerialisationNameForProperty ? [declaringClass serialisationNameForProperty:_name] : _name;
        if (!_serialisationName) {
            _serialisationName = _name;
        }
    }
    return self;
}

-(id)serialisationValueForValue:(id)value
{
    if (self.hasCustomSerialisationMethod) {
        return [self.declaingClass serialisationValueForValue:value forProperty:self.name];
    } else {
        return value;
    }
}

-(id)deserialisationValueForValue:(id)value
{
    if (self.hasCustomDeserialisationMethod) {
        return [self.declaingClass deserialisationValueForValue:value forProperty:self.name];
    } else {
        return value;
    }
}

-(id)getValueFromObject:(id)object
{
    id value = [object valueForKey:[self getterName]];
    // See if there was a custom serialiser and run it thru it
    value = [self serialisationValueForValue:value];
    if (self.type == RDHPropertyTypeObject && [self.typeClass isSubclassOfClass:[NSNumber class]]) {
        
        if ([value isKindOfClass:[NSNumber class]]) {
            // Value is still NSNumber
            value = [RDHUtils stringForDecimalNumber:value];
        }
        
    } else if (self.type == RDHPropertyTypeClass) {
        
        if (class_isMetaClass(object_getClass(value))) {
            // Value still a class
            value = NSStringFromClass(value);
        }
    }
    return value;
}

-(BOOL)setValue:(id)value onObject:(id)object
{
    if (self.canSetValue) {
        // See if there was a custom deserialiser and run it thru it
        value = [self deserialisationValueForValue:value];
        
        BOOL allowedToSet = NO;
        NSException *ex = nil;
        @try {
            allowedToSet = [self checkType:value];
        } @catch (NSException *exception) {
            ex = exception;
        } @finally {
            
            if (allowedToSet) {
                
                value = [self specialValueForValue:value];
                
                if (self.setter) {
                    SEL setterSelector = NSSelectorFromString(self.setter);
                    if ([object respondsToSelector:setterSelector]) {
                        // Just to stop errors
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [object performSelector:setterSelector withObject:value];
#pragma clang diagnostic pop
                    }
                } else if (!self.readonly) {
                    // Set value is standard so just
                    [object setValue:value forKeyPath:self.name];
                } else {
                    // Most likely readonly property so set the backing iVar
                    object_setIvar(object, self.iVar, value);
                }
                return YES;
            }
        }
        
        [ex raise];
    }
    return NO;
}

-(BOOL)checkType:(id)value
{
    if (!value) {
        return YES;
    }
    // We need to make sure that the incoming value can be assigned to this property
    
    if (self.type == RDHPropertyTypeObject) {
        // Only set if the types match or we're using id type
        if ([value isKindOfClass:self.typeClass] || !self.typeClass) {
            return YES;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [self.typeClass isSubclassOfClass:[NSNumber class]];
        }
    } else {
        
        if ([value isKindOfClass:[NSNumber class]]) {
            return [[self class] canAssignNumber:self.type];
        } else if ([value isKindOfClass:[NSString class]]) {
            return [[self class] canAssignString:self.type];
        }
        
    }
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Cannot set value of class %@ on property %@ declared as type %@ in class %@", [value class], self.name, [[self class] stringForType:self.type orClass:self.typeClass], NSStringFromClass(self.declaingClass)] userInfo:nil];
}

-(id)specialValueForValue:(id)value
{
    // Convert special values
    if (self.type == RDHPropertyTypeClass) {
        value = NSClassFromString(value);
        
    } else if (self.type == RDHPropertyTypeObject) {
        
        if ([self.typeClass isSubclassOfClass:[NSDecimalNumber class]]) {
            value = [RDHUtils decimalNumberForString:value];
        } else if ([self.typeClass isSubclassOfClass:[NSNumber class]]) {
            value = [RDHUtils numberForString:value];
        }
    } else if ([[self class] canAssignNumber:self.type]) {
        if ([value isKindOfClass:[NSString class]]) {
            // Convert to decimal number to preserve accuracy
            value = [RDHUtils decimalNumberForString:value];
        }
    }
    
    return value;
}

-(NSString *)getterName
{
    return self.getter ? self.getter : self.name;
}

-(BOOL)canSetValue
{
    return !self.readonly || self.iVar;
}

-(BOOL)isAssign
{
    return self.kind == RDHPropertyAttributeAssign;
}

-(BOOL)isWeak
{
    return self.kind == RDHPropertyAttributeWeak;
}

-(BOOL)isStrong
{
    return self.kind == RDHPropertyAttributeStrong;
}

-(BOOL)isCopying
{
    return self.kind == RDHPropertyAttributeCopy;
}

-(Class)classForObjectsIfArray
{
    if ([self.declaingClass respondsToSelector:@selector(classForObjectsInArrayProperty:)]) {
        return [self.declaingClass classForObjectsInArrayProperty:self.name];
    } else {
        return nil;
    }
}

-(Class)classForObjectIfDictionaryPropertyWithKey:(NSString *)key
{
    if ([self.declaingClass respondsToSelector:@selector(classForObjectWithKey:forDictionaryProperty:)]) {
        return [self.declaingClass classForObjectWithKey:key forDictionaryProperty:self.name];
    } else {
        return nil;
    }
}

-(NSString *)debugDescription
{
    NSMutableString *s = [[super debugDescription] mutableCopy];
    
    [s appendString:@"[ \n\t"];
    
    [s appendFormat:@"name=%@, \n\t", self.name];
    [s appendFormat:@"declaringClass=%@, \n\t", self.declaingClass];
    [s appendFormat:@"derivedGetterName=%@, \n\t", self.getterName];
    [s appendFormat:@"derivedSetterName=%@, \n\t", self.setter ? self.setter : self.name];
    [s appendFormat:@"canSerialise=%d, \n\t", self.canSerialise];
    [s appendFormat:@"canDeserialise=%d, \n\t", self.canDeserialise];
    [s appendFormat:@"serialisationName=%@, \n\t", self.serialisationName];
    
    [s appendFormat:@"attributes=T%c", self.type];
    if (self.type == RDHPropertyTypeObject && self.typeClass) {
        [s appendFormat:@"\"%@\"", NSStringFromClass(self.typeClass)];
    }
    [s appendString:@","];
    
    if (self.readonly) {
        [s appendFormat:@"%c,", RDHPropertyAttributeReadonly];
    }
    if (!self.assign) {
        [s appendFormat:@"%c,", self.kind];
    }
    if (self.nonatomic) {
        [s appendFormat:@"%c,", RDHPropertyAttributeNonAtomic];
    }
    
    if (self.getter) {
        [s appendFormat:@"%c%@,", RDHPropertyAttributeGetter, self.getter];
    }
    if (self.setter) {
        [s appendFormat:@"%c%@,", RDHPropertyAttributeSetter, self.setter];
    }
    
    if (self.dynamic) {
        [s appendFormat:@"%c,", RDHPropertyAttributeDynamic];
    }
    if (self.eligibleForGarbageCollection) {
        [s appendFormat:@"%c,", RDHPropertyAttributeEligibleForGarbageCollection];
    }
    
    if (self.iVar) {
        [s appendFormat:@"%c%s", RDHPropertyAttributeIVar, ivar_getName(self.iVar)];
    }
    
    [s appendString:@"\n]"];
    
    return s;
}

+(RDHPropertyType)typeFromEncodedString:(NSString *)string
{
    NSParameterAssert([string length] > 0);
    NSParameterAssert([string canBeConvertedToEncoding:NSASCIIStringEncoding]);
    RDHPropertyType type = [string cStringUsingEncoding:NSASCIIStringEncoding][0];
    return type;
}

+(RDHPropertyType)subTypeFromEncodedString:(NSString *)string
{
    NSParameterAssert([string length] > 1);
    NSParameterAssert([string canBeConvertedToEncoding:NSASCIIStringEncoding]);
    RDHPropertyType subType = [string cStringUsingEncoding:NSASCIIStringEncoding][1];
    return subType;
}

+(Class)classFromEncodedClassString:(NSString *)classString
{
    NSAssert([classString rangeOfString:@"@"].location == 0, @"Object class string must start with @ as per encoding");
    
    if ([@"@" isEqualToString:classString]) {
        // id type
        return nil;
    } else if ([@"@?" isEqualToString:classString]) {
        // block type
        return NSClassFromString(@"NSBlock");
    } else {
        NSAssert([classString rangeOfString:@"@\".+\"" options:NSRegularExpressionSearch].location != NSNotFound, @"Invalid class name string: %@", classString);
        // Remove starting @ and enclosing ""
        NSString *className = [classString substringWithRange:NSMakeRange(2, [classString length] - 3)];
        return NSClassFromString(className);
    }
}

+(BOOL)typeImplmented:(RDHPropertyType)type
{
    switch (type) {
        case RDHPropertyTypeObject:
        case RDHPropertyTypeClass:
        case RDHPropertyTypeFloat:
        case RDHPropertyTypeDouble:
        case RDHPropertyTypeInt:
        case RDHPropertyTypeShort:
        case RDHPropertyTypeChar:
        case RDHPropertyTypeLong:
        case RDHPropertyTypeLongLong:
        case RDHPropertyTypeUnsignedInt:
        case RDHPropertyTypeUnsignedShort:
        case RDHPropertyTypeUnsignedChar:
        case RDHPropertyTypeUnsignedLong:
        case RDHPropertyTypeUnsignedLongLong:
        case RDHPropertyTypeCBool:
            return YES;
            
        case RDHPropertyTypeCharacterString:
        case RDHPropertyTypeSelector:
        case RDHPropertyTypeVoid:
        case RDHPropertyTypePointer:
        case RDHPropertyTypeUnknown:
        case RDHPropertyTypeArray:
        case RDHPropertyTypeStruct:
        case RDHPropertyTypeUnion:
        case RDHPropertyTypeBitField:
        case RDHPropertyTypeConst:
            return NO;
    }
}

+(NSString *)stringForType:(RDHPropertyType)type orClass:(Class)cls
{
    switch (type) {
        case RDHPropertyTypeObject:
            if (cls) {
                return NSStringFromClass(cls);
            } else {
                return @"id";
            }
            
        case RDHPropertyTypeClass:
            return @"Class";
            
        case RDHPropertyTypeFloat:
            return @"float";
            
        case RDHPropertyTypeDouble:
            return @"double";
            
        case RDHPropertyTypeInt:
            return @"int";
            
        case RDHPropertyTypeShort:
            return @"short";
            
        case RDHPropertyTypeChar:
            return @"char";
            
        case RDHPropertyTypeLong:
            return @"long";
            
        case RDHPropertyTypeLongLong:
            return @"longlong";
            
        case RDHPropertyTypeUnsignedInt:
            return @"uint";
            
        case RDHPropertyTypeUnsignedShort:
            return @"ushort";
            
        case RDHPropertyTypeUnsignedChar:
            return @"uchar";
            
        case RDHPropertyTypeUnsignedLong:
            return @"ulong";
            
        case RDHPropertyTypeUnsignedLongLong:
            return @"ulonglong";
            
        case RDHPropertyTypeVoid:
            return @"void";
            
        case RDHPropertyTypePointer:
            return @"ptr";
            
        case RDHPropertyTypeCharacterString:
            return @"cstring";
            
        case RDHPropertyTypeUnknown:
            return @"?";
            
        case RDHPropertyTypeArray:
            return @"[]";
            
        case RDHPropertyTypeStruct:
            return @"struct";
            
        case RDHPropertyTypeUnion:
            return @"union";
            
        case RDHPropertyTypeSelector:
            return @"SEL";
            
        case RDHPropertyTypeBitField:
            return @"bitfield";
            
        case RDHPropertyTypeCBool:
            return @"CBool";
            
        case RDHPropertyTypeConst:
            return @"const";
    }
}

+(BOOL)canAssignNumber:(RDHPropertyType)type
{
    switch (type) {
        case RDHPropertyTypeCBool:
        case RDHPropertyTypeChar:
        case RDHPropertyTypeShort:
        case RDHPropertyTypeInt:
        case RDHPropertyTypeLong:
        case RDHPropertyTypeLongLong:
        case RDHPropertyTypeUnsignedChar:
        case RDHPropertyTypeUnsignedShort:
        case RDHPropertyTypeUnsignedInt:
        case RDHPropertyTypeUnsignedLong:
        case RDHPropertyTypeUnsignedLongLong:
        case RDHPropertyTypeFloat:
        case RDHPropertyTypeDouble:
            return YES;
            
        default:
            return NO;
    }
}

+(BOOL)canAssignString:(RDHPropertyType)type
{
    return [self canAssignNumber:type] || type == RDHPropertyTypeClass;
}

@end
