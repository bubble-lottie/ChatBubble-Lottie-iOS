//
//  RAShapeTransform.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeTransform.h"
#import "CGGeometry+LOTAdditions.h"

#import "LOTKeyframeGroup+RAKeyFrame.h"

@implementation RAShapeTransform

@synthesize keyname = _keyname;
@synthesize position = _position;
@synthesize anchor = _anchor;
@synthesize scale = _scale;
@synthesize rotation = _rotation;
@synthesize opacity = _opacity;

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
    
    if (jsonDictionary[@"pty"]) {
        _transformationMode = [jsonDictionary[@"pty"] copy];
    } else {
        _transformationMode = @0;
    }
    
    NSDictionary *position = jsonDictionary[@"p"];
    if (position) {
//        _position = [[LOTKeyframeGroup alloc] initWithData:position];
        NSInteger pType = _transformationMode.integerValue & 0x000fff;
        _position = [[LOTKeyframeGroup alloc] initWithData:position calculationType:pType orignSize:orignSize canvasSize:canvasSize];
    }
    
    NSDictionary *anchor = jsonDictionary[@"a"];
    if (anchor) {
        _anchor = [[LOTKeyframeGroup alloc] initWithData:anchor];
    }
    
    NSDictionary *scale = jsonDictionary[@"s"];
    if (scale) {
        NSInteger sType = (_transformationMode.integerValue & 0xfff000) >> 12;
        _scale = [[LOTKeyframeGroup alloc] initWithData:scale calculationType:sType orignSize:orignSize canvasSize:canvasSize];
        [_scale remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, -100, 100, -1, 1);
        }];
    }
    
    NSDictionary *rotation = jsonDictionary[@"r"];
    if (rotation) {
        _rotation = [[LOTKeyframeGroup alloc] initWithData:rotation];
        [_rotation remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_DegreesToRadians(inValue);
        }];
    }
    
    NSDictionary *opacity = jsonDictionary[@"o"];
    if (opacity) {
        _opacity = [[LOTKeyframeGroup alloc] initWithData:opacity];
        [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, 0, 100, 0, 1);
        }];
    }
    
    NSString *name = jsonDictionary[@"nm"];
    
    NSDictionary *skew = jsonDictionary[@"sk"];
    BOOL hasSkew = (skew && [skew[@"k"] isEqual:@0] == NO);
    NSDictionary *skewAxis = jsonDictionary[@"sa"];
    BOOL hasSkewAxis = (skewAxis && [skewAxis[@"k"] isEqual:@0] == NO);
    
    if (hasSkew || hasSkewAxis) {
        NSLog(@"%s: Warning: skew is not supported: %@", __PRETTY_FUNCTION__, name);
    }
}

@end
