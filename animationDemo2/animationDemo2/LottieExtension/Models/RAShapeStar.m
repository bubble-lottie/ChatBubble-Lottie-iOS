//
//  RAShapeStar.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeStar.h"

@implementation RAShapeStar

@synthesize keyname = _keyname;
@synthesize outerRadius = _outerRadius;
@synthesize outerRoundness = _outerRoundness;
@synthesize innerRadius = _innerRadius;
@synthesize innerRoundness = _innerRoundness;
@synthesize position = _position;
@synthesize numberOfPoints = _numberOfPoints;
@synthesize rotation = _rotation;
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
    
    if (jsonDictionary[@"pty"]) {
           _transformationMode = [jsonDictionary[@"pty"] copy];
       } else {
           _transformationMode = @0;
       }
    
    NSDictionary *outerRadius = jsonDictionary[@"or"];
    if (outerRadius) {
        _outerRadius = [[LOTKeyframeGroup alloc] initWithData:outerRadius];
    }
    
    NSDictionary *outerRoundness = jsonDictionary[@"os"];
    if (outerRoundness) {
        _outerRoundness = [[LOTKeyframeGroup alloc] initWithData:outerRoundness];
    }
    
    NSDictionary *innerRadius = jsonDictionary[@"ir"];
    if (innerRadius) {
        _innerRadius = [[LOTKeyframeGroup alloc] initWithData:innerRadius];
    }
    
    NSDictionary *innerRoundness = jsonDictionary[@"is"];
    if (innerRoundness) {
        _innerRoundness = [[LOTKeyframeGroup alloc] initWithData:innerRoundness];
    }
    
    NSDictionary *position = jsonDictionary[@"p"];
    if (position) {
        _position = [[LOTKeyframeGroup alloc] initWithData:position];
    }
    
    NSDictionary *numberOfPoints = jsonDictionary[@"pt"];
    if (numberOfPoints) {
        _numberOfPoints = [[LOTKeyframeGroup alloc] initWithData:numberOfPoints];
    }
    
    NSDictionary *rotation = jsonDictionary[@"r"];
    if (rotation) {
        _rotation = [[LOTKeyframeGroup alloc] initWithData:rotation];
    }
    
    NSNumber *type = jsonDictionary[@"sy"];
    _type = type.integerValue;
}

@end
