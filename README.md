RDHJSONObjectSerialisation
==========================

Simple JSON serialisation for any custom NSObject based on its declared properties.

This readme is a current work in progress and is being updated this week (05-08-2013).

Protocol
--------
The protocol must be adopted by custom objects, and gives you the options for custom serialisation and deserialisation.
[RDHJSONObjectSerialisationProtocol](RDHJSONObjectSerialisation/RDHJSONObjectSerialisationProtocol.h)

Example
-------
Custom objects defined as follows:
The `customDateProp` property has a custom serialiser and deserialiser which outputs and parses dates in the `yyyy-MM-dd` format.
``` objective-c
@interface TestObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, strong) NSString *strProp;
@property (nonatomic, strong) NSDecimalNumber *decNumProp;
@property (nonatomic, strong) NSNumber *numProp;

@property (nonatomic) short shortProp;
@property (nonatomic) int intProp;
@property (nonatomic) long longProp;

@property (nonatomic) BOOL boolPropYES;
@property (nonatomic) BOOL boolPropNO;

@property (nonatomic, strong) NSArray *arrayStringProp;
@property (nonatomic, strong) NSArray *arrayNumberProp;

@property (nonatomic, strong) TestObject *objectProp;

@property (nonatomic, strong) NSDate *dateProp;

@property (nonatomic, strong) NSData *dataProp;

@property (nonatomic, strong) NSDate *customDateProp;

@property (nonatomic, strong) NSString *nilStringProp;

@end

@interface AnotherTestObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, strong) NSString *anotherStrProp;
@property (nonatomic, strong) NSDecimalNumber *anotherDecNumProp;
@property (nonatomic, strong) NSNumber *anotherNumProp;

@end
```
### Serialisation
Populated with the following:
``` objective-c
TestObject->{
    arrayNumberProp =     (
        1,
        2,
        3,
        4
    );
    arrayStringProp =     (
        A1,
        A2,
        A3
    );
    boolPropNO = 0;
    boolPropYES = 1;
    customDateProp = "2018-02-21 02:21:36 +0000";
    dataProp = <42415345 20363420 454e434f 44454420 53545249 4e47>;
    dateProp = "2044-03-23 10:39:02 +0000";
    decNumProp = "23434234.2342342343232432";
    intProp = "-2343";
    longProp = "-234324324234324";
    nilStringProp = nil;
    numProp = "2324.003";
    objectProp = "AnotherTestObject->{
        anotherDecNumProp = "486768768.876488867867";
        anotherNumProp = 3547;
        anotherStrProp = "INNER_PROP";
    }";
    shortProp = "-133";
    strProp = "STR_PROP";
}
```
Running it through `+[RDHJSONObjectSerialisation JSONForObject:options:error:]` with `RDHJSONWritingOptionsNoOptions` produces the following JSON:
``` json
{
    "arrayNumberProp": [
        1,
        2,
        3,
        4
    ],
    "arrayStringProp": [
        "A1",
        "A2",
        "A3"
    ],
    "boolPropNO": 0,
    "boolPropYES": 1,
    "customDateProp": "2018-02-21",
    "dataProp": "QkFTRSA2NCBFTkNPREVEIFNUUklORw==",
    "dateProp": "2044-03-23T10:39:02+0000",
    "decNumProp": "2.343423E+007",
    "intProp": -2343,
    "numProp": "2.324003E+003",
    "longProp": -234324324234324,
    "objectProp": {
        "anotherDecNumProp": "4.867688E+008",
        "anotherStrProp": "INNER_PROP",
        "anotherNumProp": "3.547000E+003"
    },
    "shortProp": -133,
    "strProp": "STR_PROP"
}
```
Passing in `RDHJSONWritingOptionsConvertNilsToNSNulls` would add the extra field:
```
	"nilStringProp": null
```
Passing in `RDHJSONWritingOptionsConvertDatesToUnixTimestamps` would change the `dateProp`:
```
	"dateProp": 2342342342
```
