//
//  RDHPropertyInfo.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

typedef NS_ENUM(char, RDHPropertyType) {
    RDHPropertyTypeChar = _C_CHR,
    RDHPropertyTypeInt = _C_INT,
    RDHPropertyTypeShort = _C_SHT,
    RDHPropertyTypeLong = _C_LNG,
    RDHPropertyTypeLongLong = _C_LNG_LNG,
    RDHPropertyTypeUnsignedChar = _C_UCHR,
    RDHPropertyTypeUnsignedInt = _C_UINT,
    RDHPropertyTypeUnsignedShort = _C_USHT,
    RDHPropertyTypeUnsignedLong = _C_ULNG,
    RDHPropertyTypeUnsignedLongLong = _C_ULNG_LNG,
    RDHPropertyTypeFloat = _C_FLT,
    RDHPropertyTypeDouble = _C_DBL,
    RDHPropertyTypeCBool = _C_BOOL,
    RDHPropertyTypeVoid = _C_VOID,
    RDHPropertyTypeCharacterString = _C_CHARPTR,
    RDHPropertyTypeObject = _C_ID,
    RDHPropertyTypeClass = _C_CLASS,
    RDHPropertyTypeSelector = _C_SEL,
    RDHPropertyTypeArray = _C_ARY_B,
    RDHPropertyTypeStruct = _C_STRUCT_B,
    RDHPropertyTypeUnion = _C_UNION_B,
    RDHPropertyTypeBitField = _C_BFLD,
    RDHPropertyTypePointer = _C_PTR,
    RDHPropertyTypeConst = _C_CONST,
    RDHPropertyTypeUnknown = _C_UNDEF
};

@interface RDHPropertyInfo : NSObject

+(instancetype)infoForProperty:(objc_property_t)prop declaredInClass:(Class)declaringClass;

@property (nonatomic, assign, readonly) Class declaingClass;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *getterName;
@property (nonatomic, copy, readonly) NSString *setterName;

/// If this is RDHPropertyTypeObject then classType will be valid.
@property (nonatomic, assign, readonly) RDHPropertyType type;

/// Valid if type is RDHPropertyType. If the property is declared as `id`, this will return nil.
@property (nonatomic, assign, readonly) Class typeClass;

/// The property is read-only (readonly).
@property (nonatomic, assign, readonly, getter = isReadOnly) BOOL readonly;

/// The property is non-atomic (nonatomic).
@property (nonatomic, assign, readonly, getter = isNonAtomic) BOOL nonatomic;

/// The property is dynamic (@dynamic).
@property (nonatomic, assign, readonly, getter = isDynamic) BOOL dynamic;

/// The property is eligible for garbage collection.
@property (nonatomic, assign, readonly, getter = isEligibleForGarbageCollection) BOOL eligibleForGarbageCollection;

/// Whether or not this property should be included when serialising an object to JSON.
@property (nonatomic, assign, readonly) BOOL canSerialise;

/// Whether or not this property should be included when deserialising JSON to the object.
@property (nonatomic, assign, readonly) BOOL canDeserialise;

/// The name of the property when serialising or deserilaising JSON.
@property (nonatomic, assign, readonly) NSString *serialisationName;


/// The property is an assigned reference (assign) or no reference kind has been set (Note: the compiler warns: no 'assign', 'retain', or 'copy' attribute is specified - 'assign' is assumed")
@property (nonatomic, assign, readonly, getter = isAssign) BOOL assign;

/// The property is a weak reference (__weak).
@property (nonatomic, assign, readonly, getter = isWeak) BOOL weak;

@property (nonatomic, assign, readonly, getter = isStrong) BOOL strong;

/// The property is a copy of the value last assigned (copy).
@property (nonatomic, assign, readonly, getter = isCopying) BOOL copying;

-(BOOL)canSetValue;

-(id)getValueFromObject:(id)object;

-(BOOL)setValue:(id)value onObject:(id)object;

-(Class)classForObjectsIfArray;

-(Class)classForObjectIfDictionaryPropertyWithKey:(NSString *)key;

+(BOOL)typeImplmented:(RDHPropertyType)type;

+(NSString *)stringForType:(RDHPropertyType)type orClass:(Class)cls;

@end
