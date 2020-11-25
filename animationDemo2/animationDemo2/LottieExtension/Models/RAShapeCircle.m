//
//  RAShapeCircle.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeCircle.h"

@implementation RAShapeCircle

@synthesize keyname = _keyname;
@synthesize position = _position;
@synthesize size = _size;
@synthesize reversed = _reversed;

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
        _position = [[LOTKeyframeGroup alloc] initWithData:position];
    }
    
    NSDictionary *size= jsonDictionary[@"s"];
    if (size) {
        _size = [[LOTKeyframeGroup alloc] initWithData:size];
    }
    NSNumber *reversed = jsonDictionary[@"d"];
    _reversed = (reversed.integerValue == 3);
}

@end
