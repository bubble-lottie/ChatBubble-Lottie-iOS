//
//  RAShapeRectangle.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeRectangle.h"
#import "LOTKeyframeGroup+RAKeyFrame.h"

@implementation RAShapeRectangle

@synthesize keyname = _keyname;
@synthesize position = _position;
@synthesize size = _size;
@synthesize cornerRadius = _cornerRadius;
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
//        _position = [[LOTKeyframeGroup alloc] initWithData:position];
        NSInteger pType = _transformationMode.integerValue & 0x000fff;
        _position = [[LOTKeyframeGroup alloc] initWithData:position calculationType:pType orignSize:orignSize canvasSize:canvasSize];
    }
    
    NSDictionary *cornerRadius = jsonDictionary[@"r"];
    if (cornerRadius) {
        _cornerRadius = [[LOTKeyframeGroup alloc] initWithData:cornerRadius];
    }
    
    NSDictionary *size = jsonDictionary[@"s"];
    if (size) {
//        _size = [[LOTKeyframeGroup alloc] initWithData:size];
         NSInteger sizeType = (_transformationMode.integerValue & 0xfff000) >> 12;
        _size = [[LOTKeyframeGroup alloc] initWithData:size calculationType:sizeType orignSize:orignSize canvasSize:canvasSize];
    }
    NSNumber *reversed = jsonDictionary[@"d"];
    _reversed = (reversed.integerValue == 3);
}

@end
