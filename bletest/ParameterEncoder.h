//
//  ParameterEncoder.h
//  bletest
//
//  Created by Amelia Murphy on 2/9/22.
//

#ifndef ParameterEncoder_h
#define ParameterEncoder_h

@interface ParameterEncoder : NSObject

-(void)addParameterWithLabel:(NSString*)label andValue:(int)value andType:(NSString*)type;
-(void)printPsarameterTree;
-(NSData*)getParameterAsJSON:(int)index;
-(NSMutableDictionary*)getParameterTreeAsDictionary;
-(NSData*)getParameterTreeAsJSON;

-(NSData*)encodeValueWithType:(int)type andIndex:(int)index andValue:(int)value;
-(void)setParameterValue:(int)value withIndex:(int)index;

@end


#endif /* ParameterEncoder_h */
