//
//  RALayer.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RALayer.h"
#import "LOTAsset.h"
#import "LOTAssetGroup.h"
#import "UIColor+Expanded.h"
#import "CGGeometry+LOTAdditions.h"

#import "LOTKeyframeGroup+RAKeyFrame.h"

#import "LOTMask.h"

#import "RAShapeGroup.h"

@implementation RALayer

@synthesize layerName = _layerName;
@synthesize layerID = _layerID;
@synthesize layerType = _layerType;
@synthesize layerBounds = _layerBounds;
@synthesize layerWidth = _layerWidth;
@synthesize layerHeight = _layerHeight;
@synthesize startFrame = _startFrame;
@synthesize outFrame = _outFrame;
@synthesize inFrame = _inFrame;
@synthesize timeStretch = _timeStretch;
@synthesize parentID = _parentID;
@synthesize referenceID = _referenceID;

@synthesize shapes = _shapes;
@synthesize masks = _masks;

@synthesize solidColor = _solidColor;
@synthesize imageAsset = _imageAsset;

@synthesize opacity = _opacity;
@synthesize timeRemapping = _timeRemapping;

@synthesize rotation = _rotation;
@synthesize position = _position;
@synthesize positionX = _positionX;
@synthesize positionY = _positionY;

@synthesize anchor = _anchor;
@synthesize scale = _scale;

@synthesize matteType = _matteType;

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary
              withAssetGroup:(LOTAssetGroup *)assetGroup
               withFramerate:(NSNumber *)framerate
                   orignSize:(CGSize)orignSize
                  canvasSize:(CGSize)canvasSize {
    self = [super init];
    if (self) {
        [self _mapFromJSON:jsonDictionary withAssetGroup:assetGroup withFramerate:framerate orignSize:orignSize canvasSize:canvasSize];
    }
    return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary
      withAssetGroup:(LOTAssetGroup *)assetGroup
       withFramerate:(NSNumber *)framerate
           orignSize:(CGSize)orignSize
          canvasSize:(CGSize)canvasSize {
    
    _layerName = [jsonDictionary[@"nm"] copy];
    _layerID = [jsonDictionary[@"ind"] copy];
    
    if ([_layerName isEqualToString:@"Controller"]) {
        NSLog(@"123");
    }
    
    NSNumber *layerType = jsonDictionary[@"ty"];
    _layerType = layerType.integerValue;
    
    if (jsonDictionary[@"refId"]) {
        _referenceID = [jsonDictionary[@"refId"] copy];
    }
    
    _parentID = [jsonDictionary[@"parent"] copy];
    
    if (jsonDictionary[@"st"]) {
        _startFrame = [jsonDictionary[@"st"] copy];
    }
    _inFrame = [jsonDictionary[@"ip"] copy];
    _outFrame = [jsonDictionary[@"op"] copy];
    
    if (jsonDictionary[@"sr"]) {
        _timeStretch = [jsonDictionary[@"sr"] copy];
    } else {
        _timeStretch = @1;
    }
    
    if (jsonDictionary[@"pty"]) {
        _transformationMode = [jsonDictionary[@"pty"] copy];
    } else {
        _transformationMode = @0;
    }
    
    if (_layerType == LOTLayerTypePrecomp) {
        //原尺寸
        NSNumber *orignHeight = [jsonDictionary[@"h"] copy];
        NSNumber *orignWidth = [jsonDictionary[@"w"] copy];
        
//        _layerHeight = [jsonDictionary[@"h"] copy];
//        _layerWidth = [jsonDictionary[@"w"] copy];
        _layerHeight = @(orignHeight.floatValue+(canvasSize.height-orignSize.height));
        _layerWidth = @(orignWidth.floatValue+(canvasSize.width-orignSize.width));
        
        [assetGroup buildAssetNamed:_referenceID withFramerate:framerate];
    } else if (_layerType == LOTLayerTypeImage) {
        //图片暂不修改宽高
        [assetGroup buildAssetNamed:_referenceID withFramerate:framerate];
        _imageAsset = [assetGroup assetModelForID:_referenceID];
        _layerWidth = [_imageAsset.assetWidth copy];
        _layerHeight = [_imageAsset.assetHeight copy];
    } else if (_layerType == LOTLayerTypeSolid) {
        //图形填充
        
        NSNumber *orignHeight = jsonDictionary[@"sh"];
        NSNumber *orignWidth = jsonDictionary[@"sw"];
        
        _layerHeight = @(orignHeight.floatValue+(canvasSize.height-orignSize.height));
        _layerWidth = @(orignWidth.floatValue+(canvasSize.width-orignSize.width));
//        _layerWidth = jsonDictionary[@"sw"];
//        _layerHeight = jsonDictionary[@"sh"];
        
        NSString *solidColor = jsonDictionary[@"sc"];
        _solidColor = [UIColor LOT_colorWithHexString:solidColor];
    }
    
    _layerBounds = CGRectMake(0, 0, _layerWidth.floatValue, _layerHeight.floatValue);
    
    NSDictionary *ks = jsonDictionary[@"ks"];
    
    NSDictionary *opacity = ks[@"o"];
    if (opacity) {
        _opacity = [[LOTKeyframeGroup alloc] initWithData:opacity];
        [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, 0, 100, 0, 1);
        }];
    }
    
    NSDictionary *timeRemap = jsonDictionary[@"tm"];
    if (timeRemap) {
        _timeRemapping = [[LOTKeyframeGroup alloc] initWithData:timeRemap];
        [_timeRemapping remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return inValue * framerate.doubleValue;
        }];
    }
    
    NSDictionary *rotation = ks[@"r"];
    if (rotation == nil) {
        rotation = ks[@"rz"];
    }
    if (rotation) {
        _rotation = [[LOTKeyframeGroup alloc] initWithData:rotation];
        [_rotation remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_DegreesToRadians(inValue);
        }];
    }
    
    //位置信息，需要单独做
    NSDictionary *position = ks[@"p"];
    if ([position[@"s"] boolValue]) {
        // Separate dimensions
        NSInteger pType = _transformationMode.integerValue & 0x000fff;
        _positionX = [[LOTKeyframeGroup alloc] initWithData:position[@"x"] calculationType:pType orignSize:orignSize canvasSize:canvasSize];
        
        _positionY = [[LOTKeyframeGroup alloc] initWithData:position[@"y"] calculationType:pType orignSize:orignSize canvasSize:canvasSize];
    } else {
        NSInteger pType = _transformationMode.integerValue & 0x000fff;
//        _position = [[LOTKeyframeGroup alloc] initWithData:position];
        _position = [[LOTKeyframeGroup alloc] initWithData:position calculationType:pType orignSize:orignSize canvasSize:canvasSize];
    }
    
    NSDictionary *anchor = ks[@"a"];
    if (anchor) {
        _anchor = [[LOTKeyframeGroup alloc] initWithData:anchor];
    }
    
    NSDictionary *scale = ks[@"s"];
    if (scale) {
        NSInteger sType = (_transformationMode.integerValue & 0xfff000) >> 12;
        _scale = [[LOTKeyframeGroup alloc] initWithData:scale calculationType:sType orignSize:orignSize canvasSize:canvasSize layerSize:_layerBounds.size];
        
        [_scale remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
            return LOT_RemapValue(inValue, -100, 100, -1, 1);
        }];
    }
    
    _matteType = [jsonDictionary[@"tt"] integerValue];
    
    NSMutableArray *masks = [NSMutableArray array];
    for (NSDictionary *maskJSON in jsonDictionary[@"masksProperties"]) {
        LOTMask *mask = [[LOTMask alloc] initWithJSON:maskJSON];
        [masks addObject:mask];
    }
    _masks = masks.count ? masks : nil;
    
    NSMutableArray *shapes = [NSMutableArray array];
    for (NSDictionary *shapeJSON in jsonDictionary[@"shapes"]) {
//        id shapeItem = [RAShapeGroup shapeItemWithJSON:shapeJSON];
        id shapeItem = [RAShapeGroup shapeItemWithJSON:shapeJSON orignSize:orignSize canvasSize:canvasSize];
        if (shapeItem) {
            [shapes addObject:shapeItem];
        }
    }
    _shapes = shapes;
    
    NSArray *effects = jsonDictionary[@"ef"];
    if (effects.count > 0) {
        
        NSDictionary *effectNames = @{ @0: @"slider",
                                       @1: @"angle",
                                       @2: @"color",
                                       @3: @"point",
                                       @4: @"checkbox",
                                       @5: @"group",
                                       @6: @"noValue",
                                       @7: @"dropDown",
                                       @9: @"customValue",
                                       @10: @"layerIndex",
                                       @20: @"tint",
                                       @21: @"fill" };
        
        for (NSDictionary *effect in effects) {
            NSNumber *typeNumber = effect[@"ty"];
            NSString *name = effect[@"nm"];
            NSString *internalName = effect[@"mn"];
            NSString *typeString = effectNames[typeNumber];
            if (typeString) {
                NSLog(@"%s: Warning: %@ effect not supported: %@ / %@", __PRETTY_FUNCTION__, typeString, internalName, name);
            }
        }
    }
    
    if ([_layerName isEqualToString:@"Controller"]) {
        NSLog(@"layer:%@", self);
    }
    
}

@end
