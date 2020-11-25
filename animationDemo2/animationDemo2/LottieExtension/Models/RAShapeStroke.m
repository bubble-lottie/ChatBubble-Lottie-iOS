//
//  RAShapeStroke.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeStroke.h"
#import "CGGeometry+LOTAdditions.h"

#import "LOTKeyframeGroup+RAKeyFrame.h"

@implementation RAShapeStroke

@synthesize  keyname = _keyname;
@synthesize  fillEnabled = _fillEnabled;
@synthesize  color = _color;
@synthesize  opacity = _opacity;
@synthesize  width = _width;
@synthesize  dashOffset = _dashOffset;
@synthesize  capType = _capType;
@synthesize  joinType = _joinType;
@synthesize  lineDashPattern = _lineDashPattern;

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
    
    NSDictionary *width = jsonDictionary[@"w"];
    if (width) {
        _width = [[LOTKeyframeGroup alloc] initWithData:width];
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
    
    _capType = [jsonDictionary[@"lc"] integerValue] - 1;
    _joinType = [jsonDictionary[@"lj"] integerValue] - 1;
    
    NSNumber *fillEnabled = jsonDictionary[@"fillEnabled"];
    _fillEnabled = fillEnabled.boolValue;
    
    NSDictionary *dashOffset = nil;
    NSArray *dashes = jsonDictionary[@"d"];
    if (dashes) {
        NSMutableArray *dashPattern = [NSMutableArray array];
        for (NSDictionary *dash in dashes) {
            if ([dash[@"n"] isEqualToString:@"o"]) {
                dashOffset = dash[@"v"];
                continue;
            }
            // TODO DASH PATTERNS
            NSDictionary *value = dash[@"v"];
            LOTKeyframeGroup *keyframeGroup = [[LOTKeyframeGroup alloc] initWithData:value];
            [dashPattern addObject:keyframeGroup];
        }
        _lineDashPattern = dashPattern;
    }
    if (dashOffset) {
        _dashOffset = [[LOTKeyframeGroup alloc] initWithData:dashOffset];
    }
}

@end
