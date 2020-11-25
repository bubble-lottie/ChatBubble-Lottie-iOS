//
//  RAShapeGradientFill.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeGradientFill.h"
#import "CGGeometry+LOTAdditions.h"

@implementation RAShapeGradientFill

@synthesize keyname = _keyname;
@synthesize numberOfColors = _numberOfColors;
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize gradient = _gradient;
@synthesize opacity = _opacity;
@synthesize evenOddFillRule = _evenOddFillRule;
@synthesize type = _type;


- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    self = [super init];
    if (self) {
        [self _mapFromJSON:jsonDictionary orignSize:orignSize canvasSize:canvasSize];
    }
    return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    if (jsonDictionary[@"nm"] ) {
        _keyname = [jsonDictionary[@"nm"] copy];
    }
    
    NSNumber *type = jsonDictionary[@"t"];
    
    if (type.integerValue != 1) {
        _type = LOTGradientTypeRadial;
    } else {
        _type = LOTGradientTypeLinear;
    }
    
    if (jsonDictionary[@"pty"]) {
           _transformationMode = [jsonDictionary[@"pty"] copy];
       } else {
           _transformationMode = @0;
       }
    
    NSDictionary *start = jsonDictionary[@"s"];
    if (start) {
        _startPoint = [[LOTKeyframeGroup alloc] initWithData:start];
    }
    
    NSDictionary *end = jsonDictionary[@"e"];
    if (end) {
        _endPoint = [[LOTKeyframeGroup alloc] initWithData:end];
    }
    
    NSDictionary *gradient = jsonDictionary[@"g"];
    if (gradient) {
        NSDictionary *unwrappedGradient = gradient[@"k"];
        _numberOfColors = gradient[@"p"];
        _gradient = [[LOTKeyframeGroup alloc] initWithData:unwrappedGradient];
    }
    
    NSDictionary *opacity = jsonDictionary[@"o"];
    if (opacity) {
        _opacity = [[LOTKeyframeGroup alloc] initWithData:opacity];
        [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, 0, 100, 0, 1);
        }];
    }
    
    NSNumber *evenOdd = jsonDictionary[@"r"];
    if (evenOdd.integerValue == 2) {
        _evenOddFillRule = YES;
    } else {
        _evenOddFillRule = NO;
    }
}

@end
