//
//  RAShapeFill.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeFill.h"
#import "CGGeometry+LOTAdditions.h"

@implementation RAShapeFill

@synthesize keyname = _keyname;
@synthesize fillEnabled = _fillEnabled;
@synthesize color = _color;
@synthesize opacity = _opacity;
@synthesize evenOddFillRule = _evenOddFillRule;

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
    
    NSDictionary *color = jsonDictionary[@"c"];
    if (color) {
        _color = [[LOTKeyframeGroup alloc] initWithData:color];
    }
    
    NSDictionary *opacity = jsonDictionary[@"o"];
    if (opacity) {
        _opacity = [[LOTKeyframeGroup alloc] initWithData:opacity];
        [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, 0, 100, 0, 1);
        }];
    }
    
    if (jsonDictionary[@"pty"]) {
        _transformationMode = [jsonDictionary[@"pty"] copy];
    } else {
        _transformationMode = @0;
    }
    
    NSNumber *evenOdd = jsonDictionary[@"r"];
    if (evenOdd.integerValue == 2) {
        _evenOddFillRule = YES;
    } else {
        _evenOddFillRule = NO;
    }
    
    NSNumber *fillEnabled = jsonDictionary[@"fillEnabled"];
    _fillEnabled = fillEnabled.boolValue;
}

@end
