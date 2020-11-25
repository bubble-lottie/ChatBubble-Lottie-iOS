//
//  RALayerGroup.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/15.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RALayerGroup.h"
#import "RALayer.h"

@implementation RALayerGroup {
    NSDictionary *_modelMap;
    NSDictionary *_referenceIDMap;
}

@synthesize layers = _layers;

- (instancetype)initWithLayerJSON:(NSArray *)layersJSON withAssetGroup:(LOTAssetGroup * _Nullable)assetGroup withFramerate:(NSNumber *)framerate orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    self = [super init];
    if (self) {
        [self _mapFromJSON:layersJSON withAssetGroup:assetGroup withFramerate:framerate orignSize:orignSize canvasSize:canvasSize];
    }
    return self;
}

- (void)_mapFromJSON:(NSArray *)layersJSON
      withAssetGroup:(LOTAssetGroup * _Nullable)assetGroup
       withFramerate:(NSNumber *)framerate
           orignSize:(CGSize)orignSize
          canvasSize:(CGSize)canvasSize {
    
    NSMutableArray *layers = [NSMutableArray array];
    NSMutableDictionary *modelMap = [NSMutableDictionary dictionary];
    NSMutableDictionary *referenceMap = [NSMutableDictionary dictionary];
    
    for (int i = 0; i<layersJSON.count; i++) {
        NSDictionary *layerJSON = layersJSON[i];
//        if (i==7) {
            RALayer *layer = [[RALayer alloc] initWithJSON:layerJSON withAssetGroup:assetGroup withFramerate:framerate orignSize:orignSize canvasSize:canvasSize];
            [layers addObject:layer];
            if(layer.layerID) {
                modelMap[layer.layerID] = layer;
            }
            if (layer.referenceID) {
                referenceMap[layer.referenceID] = layer;
            }
//        }
    }
    
//    for (NSDictionary *layerJSON in layersJSON) {
//        RALayer *layer = [[RALayer alloc] initWithJSON:layerJSON withAssetGroup:assetGroup withFramerate:framerate orignSize:orignSize canvasSize:canvasSize];
//        [layers addObject:layer];
//        if(layer.layerID) {
//            modelMap[layer.layerID] = layer;
//        }
//        if (layer.referenceID) {
//            referenceMap[layer.referenceID] = layer;
//        }
//    }
    
    _referenceIDMap = referenceMap;
    _modelMap = modelMap;
    _layers = layers;
}

- (LOTLayer *)layerModelForID:(NSNumber *)layerID {
  return _modelMap[layerID];
}

- (LOTLayer *)layerForReferenceID:(NSString *)referenceID {
  return _referenceIDMap[referenceID];
}

@end
