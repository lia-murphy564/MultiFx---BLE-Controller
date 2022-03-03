//
//  ParameterEncoder.m
//  bletest
//
//  Created by Amelia Murphy on 2/10/22.
//

#import <Foundation/Foundation.h>
#import "ParameterEncoder.h"

@interface ParameterEncoder ()

@property NSMutableDictionary* paramTree;
@property NSArray* keys;
@property NSMutableDictionary *paramStruct;
@property int numParams;
@property NSError *err;

@end

@implementation ParameterEncoder


-(id)init{
    self.paramTree = [NSMutableDictionary dictionary];
    self.keys = [[NSArray alloc] initWithObjects:@"label",@"type",@"value", nil];
    self.paramStruct = [NSMutableDictionary dictionaryWithSharedKeySet:[NSDictionary sharedKeySetForKeys:self.keys]];
    self.numParams = 1;
    return self;
}

-(void)addParameterWithLabel:(NSString*)label andValue:(int)value andType:(NSString*)type {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:self.paramStruct];
    [param setValue:label forKey:self.keys[0]];
    [param setValue:type forKey:self.keys[1]];
    [param setValue:[NSNumber numberWithInt:value] forKey:self.keys[2]];
    
    NSString* index = [NSString stringWithFormat:@"%i", self.numParams];
    
    [self.paramTree setObject:param forKey:index];
    
    self.numParams++;
    //NSLog(@"%i", self.numParams);


}

-(void)printParameterTree {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramTree options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}

-(void)printParameterAtIndex:(int)index {
    NSString* strIndex = [NSString stringWithFormat:@"%i", index];
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramTree[strIndex] options:NSJSONWritingWithoutEscapingSlashes error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}

-(NSData*)getParameterTreeAsJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramTree options:NSJSONWritingWithoutEscapingSlashes error:nil];
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);
    return data;
}

-(NSData*)getParameterTreeAsJSONWithUTF8 {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramTree options:NSJSONWritingWithoutEscapingSlashes error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *outd = [str dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);
    return outd;
}

-(NSMutableDictionary*)getParameterTreeAsDictionary {
    return self.paramTree;
}

-(NSData*)getParameterAsJSON:(int)index {
    NSString* strIndex = [NSString stringWithFormat:@"%i", index];
    NSData* curr = self.paramTree[strIndex];
    NSData* data = [NSJSONSerialization dataWithJSONObject:curr options:NSJSONWritingWithoutEscapingSlashes error:nil];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* outd = [str dataUsingEncoding:NSUTF8StringEncoding];
    //return data;
    return outd;
}

-(void)setParameterValue:(int)value withIndex:(int)index {
    NSString *path = [NSString stringWithFormat:@"%i.value", index];
    [self.paramTree setValue:[NSNumber numberWithInt:value] forKeyPath:path];
    
}

//-(NSData*)encodeValueWithType:(int)type andIndex:(int)index andValue:(int)value {
//    //NSMutableString* str = [[NSMutableString alloc] initWithCapacity:8];
//    //[str appendString:[NSString stringWithFormat:@"type=%d_", type]];
//    //[str appendString:[NSString stringWithFormat:@"index=%d_", index]];
//    //[str appendString:[NSString stringWithFormat:@"val=%d_", value]];
//
//    //NSArray* keys = [[NSArray alloc] initWithObjects:@"label",@"type",@"index",@"value", nil];
////    NSMutableDictionary *paramStruct = [NSMutableDictionary dictionaryWithSharedKeySet:[NSDictionary sharedKeySetForKeys:keys]];
////    [paramStruct setValue:[NSNumber numberWithInt:type] forKey:keys[1]];
////    [paramStruct setValue:[NSNumber numberWithInt:index] forKey:keys[2]];
////    [paramStruct setValue:[NSNumber numberWithInt:value] forKey:keys[3]];
//
//    //NSMutableDictionary *paramTree = [NSMutableDictionary dictionary];
//    //[self.paramTree setObject:paramStruct forKey:@"1"];
//
//    //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    //[dict setObject:@"My Title" forKey:@"Title"];
//    //[dict setObject:paramTree forKey:@"Parameters"];
//
//    //NSError *err;
//    //NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nili];
////
////    NSString *resultingString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////    NSLog(@"%@", resultingString);
//
//    //NSLog(str);
//    //`NSLog(@"Contents of type: @%u",);
//
//    //NSString* str = [NSString stringWithFormat:@"%@%@%@", type, index, val];
//
//    //NSData *dataOut = [resultingString dataUsingEncoding:NSUTF8StringEncoding];
//    return data;
//}

@end
