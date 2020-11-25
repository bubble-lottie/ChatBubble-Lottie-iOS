//
//  RAShapeGroup.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/17.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "RAShapeGroup.h"
#import "RAShapeStroke.h"
#import "RAShapeFill.h"
#import "RAShapeTransform.h"
#import "RAShapePath.h"
#import "RAShapeCircle.h"
#import "RAShapeRectangle.h"
#import "RAShapeTrimPath.h"
#import "RAShapeGradientFill.h"
#import "RAShapeStar.h"
#import "RAShapeRepeater.h"

@implementation RAShapeGroup

@synthesize keyname = _keyname;
@synthesize items = _items;

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
    
    NSArray *itemsJSON = jsonDictionary[@"it"];
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemJSON in itemsJSON) {
        id newItem = [RAShapeGroup shapeItemWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        if (newItem) {
            [items addObject:newItem];
        }
    }
    _items = items;
}

+ (id)shapeItemWithJSON:(NSDictionary *)itemJSON orignSize:(CGSize)orignSize canvasSize:(CGSize)canvasSize {
    NSString *type = itemJSON[@"ty"];
    if ([type isEqualToString:@"gr"]) {
        RAShapeGroup *group = [[RAShapeGroup alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return group;
    } else if ([type isEqualToString:@"st"]) {
        RAShapeStroke *stroke = [[RAShapeStroke alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return stroke;
    } else if ([type isEqualToString:@"fl"]) {
        RAShapeFill *fill = [[RAShapeFill alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return fill;
    } else if ([type isEqualToString:@"tr"]) {
        RAShapeTransform *transform = [[RAShapeTransform alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return transform;
    } else if ([type isEqualToString:@"sh"]) {
        RAShapePath *path = [[RAShapePath alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return path;
    } else if ([type isEqualToString:@"el"]) {
        RAShapeCircle *circle = [[RAShapeCircle alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return circle;
    } else if ([type isEqualToString:@"rc"]) {
        RAShapeRectangle *rectangle = [[RAShapeRectangle alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return rectangle;
    } else if ([type isEqualToString:@"tm"]) {
        RAShapeTrimPath *trim = [[RAShapeTrimPath alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return trim;
    } else  if ([type isEqualToString:@"gs"]) {
        NSLog(@"%s: Warning: gradient strokes are not supported", __PRETTY_FUNCTION__);
    } else  if ([type isEqualToString:@"gf"]) {
        RAShapeGradientFill *gradientFill = [[RAShapeGradientFill alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return gradientFill;
    } else if ([type isEqualToString:@"sr"]) {
        RAShapeStar *star = [[RAShapeStar alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return star;
    } else if ([type isEqualToString:@"mm"]) {
        NSString *name = itemJSON[@"nm"];
        NSLog(@"%s: Warning: merge shape is not supported. name: %@", __PRETTY_FUNCTION__, name);
    } else if ([type isEqualToString:@"rp"]) {
        RAShapeRepeater *repeater = [[RAShapeRepeater alloc] initWithJSON:itemJSON orignSize:orignSize canvasSize:canvasSize];
        return repeater;
    } else {
        NSString *name = itemJSON[@"nm"];
        NSLog(@"%s: Unsupported shape: %@ name: %@", __PRETTY_FUNCTION__, type, name);
    }
    
    return nil;
}

@end
