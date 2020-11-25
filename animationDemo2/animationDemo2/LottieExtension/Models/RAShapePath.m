//
//  RAShapePath.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapePath.h"
#import "LOTKeyframeGroup+RAKeyFrame.h"

@implementation RAShapePath

@synthesize keyname = _keyname;
@synthesize closed = _closed;
@synthesize index = _index;
@synthesize shapePath = _shapePath;

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
    
    _index = jsonDictionary[@"ind"];
    _closed = [jsonDictionary[@"closed"] boolValue];
    NSDictionary *shape = jsonDictionary[@"ks"];
    if (shape) {
        _shapePath = [[LOTKeyframeGroup alloc] initWithData:shape calculationType:_transformationMode.integerValue orignSize:orignSize canvasSize:canvasSize];
    }
}

@end
