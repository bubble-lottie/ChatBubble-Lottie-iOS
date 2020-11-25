//
//  RAShapeTrimPath.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeTrimPath.h"

@implementation RAShapeTrimPath

@synthesize keyname = _keyname;
@synthesize start = _start;
@synthesize end = _end;
@synthesize offset = _offset;

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
    
    NSDictionary *start = jsonDictionary[@"s"];
    if (start) {
        _start = [[LOTKeyframeGroup alloc] initWithData:start];
    }
    
    NSDictionary *end = jsonDictionary[@"e"];
    if (end) {
        _end = [[LOTKeyframeGroup alloc] initWithData:end];
    }
    
    NSDictionary *offset = jsonDictionary[@"o"];
    if (offset) {
        _offset = [[LOTKeyframeGroup alloc] initWithData:offset];
    }
}

@end
