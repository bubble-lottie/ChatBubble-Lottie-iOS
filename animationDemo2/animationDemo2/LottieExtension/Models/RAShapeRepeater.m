//
//  RAShapeRepeater.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeRepeater.h"
#import "CGGeometry+LOTAdditions.h"

@implementation RAShapeRepeater

@synthesize keyname = _keyname;
@synthesize copies = _copies;
@synthesize offset = _offset;
@synthesize anchorPoint = _anchorPoint;
@synthesize scale = _scale;
@synthesize position = _position;
@synthesize rotation = _rotation;
@synthesize startOpacity = _startOpacity;
@synthesize endOpacity = _endOpacity;

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
    
    NSDictionary *copies = jsonDictionary[@"c"];
    if (copies) {
        _copies = [[LOTKeyframeGroup alloc] initWithData:copies];
    }
    
    NSDictionary *offset = jsonDictionary[@"o"];
    if (offset) {
        _offset = [[LOTKeyframeGroup alloc] initWithData:offset];
    }
    
    NSDictionary *transform = jsonDictionary[@"tr"];
    
    NSDictionary *rotation = transform[@"r"];
    if (rotation) {
        _rotation = [[LOTKeyframeGroup alloc] initWithData:rotation];
        [_rotation remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_DegreesToRadians(inValue);
        }];
    }
    
    NSDictionary *startOpacity = transform[@"so"];
    if (startOpacity) {
        _startOpacity = [[LOTKeyframeGroup alloc] initWithData:startOpacity];
        [_startOpacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, 0, 100, 0, 1);
        }];
    }
    
    NSDictionary *endOpacity = transform[@"eo"];
    if (endOpacity) {
        _endOpacity = [[LOTKeyframeGroup alloc] initWithData:endOpacity];
        [_endOpacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, 0, 100, 0, 1);
        }];
    }
    
    NSDictionary *anchorPoint = transform[@"a"];
    if (anchorPoint) {
        _anchorPoint = [[LOTKeyframeGroup alloc] initWithData:anchorPoint];
    }
    
    NSDictionary *position = transform[@"p"];
    if (position) {
        _position = [[LOTKeyframeGroup alloc] initWithData:position];
    }
    
    NSDictionary *scale = transform[@"s"];
    if (scale) {
        _scale = [[LOTKeyframeGroup alloc] initWithData:scale];
        [_scale remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, -100, 100, -1, 1);
        }];
    }
}

@end
