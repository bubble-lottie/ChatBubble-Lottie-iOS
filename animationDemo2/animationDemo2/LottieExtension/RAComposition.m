//
//  RAComposition.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAComposition.h"
#import "LOTAssetGroup.h"
#import "RALayerGroup.h"

@implementation RAComposition

@synthesize assetGroup = _assetGroup;
@synthesize layerGroup = _layerGroup;

- (instancetype _Nonnull)initWithJSON:(NSMutableDictionary * _Nullable)jsonDictionary withAssetBundle:(NSBundle * _Nullable)bundle canvasSize:(CGSize)canvasSize {
    self = [super init];
    if (self) {
        //计算原画布大小
        NSNumber *width = jsonDictionary[@"w"];
        NSNumber *height = jsonDictionary[@"h"];
        if (width && height) {
            CGRect bounds = CGRectMake(0, 0, width.floatValue, height.floatValue);
            _originCompBounds = bounds;
        }
        //如果需要则调整画布大小
        if (jsonDictionary[@"raty"]) {
            [jsonDictionary setValue:@(canvasSize.width) forKey:@"w"];
            [jsonDictionary setValue:@(canvasSize.height) forKey:@"h"];
        }
        
        if (jsonDictionary) {
            [self performSelector:@selector(_mapFromJSON:withAssetBundle:) withObject:jsonDictionary withObject:bundle];
            _assetGroup = super.assetGroup;
            _layerGroup = super.layerGroup;
        }
        
        //重置asset数组
        [self _resetAssetGroup:jsonDictionary withAssetBundle:bundle canvasSize:canvasSize];
        //重置layer数组
        [self _resetLayerGroup:jsonDictionary withAssetBundle:bundle canvasSize:canvasSize];
//        [self _resetLayerGroup:jsonDictionary withAssetBundle:bundle canvasSize:_originCompBounds.size];
    }
    return self;
}

- (void)_resetAssetGroup:(NSMutableDictionary *)jsonDictionary withAssetBundle:(NSBundle * _Nullable)bundle canvasSize:(CGSize)canvasSize {
    //暂时不需要修改
    NSArray *assetArray = jsonDictionary[@"assets"];
    if (assetArray.count) {
        _assetGroup = [[LOTAssetGroup alloc] initWithJSON:assetArray withAssetBundle:bundle withFramerate:self.framerate];
    }

    [_assetGroup finalizeInitializationWithFramerate:self.framerate];
}

- (void)_resetLayerGroup:(NSMutableDictionary *)jsonDictionary withAssetBundle:(NSBundle * _Nullable)bundle canvasSize:(CGSize)canvasSize {
    NSArray *layersJSON = jsonDictionary[@"layers"];
    if (layersJSON) {
        _layerGroup = [[RALayerGroup alloc] initWithLayerJSON:layersJSON withAssetGroup:_assetGroup withFramerate:self.framerate orignSize:_originCompBounds.size canvasSize:canvasSize];
    }
}

@end
