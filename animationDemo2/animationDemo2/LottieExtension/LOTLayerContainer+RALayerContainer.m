//
//  LOTLayerContainer+RALayerContainer.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/23.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTLayerContainer+RALayerContainer.h"
#import "LOTTransformInterpolator.h"
#import "LOTNumberInterpolator.h"
#import "CGGeometry+LOTAdditions.h"
#import "LOTRenderGroup.h"
#import "LOTHelpers.h"
#import "LOTMaskContainer.h"
#import "LOTAsset.h"
#import "LOTCacheProvider.h"

@implementation LOTLayerContainer (RALayerContainer)

#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

- (void)_setImageForAsset:(LOTAsset *)asset {
    if (asset.imageName) {
        UIImage *image;
        if ([asset.imageName hasPrefix:@"data:"]) {
            // Contents look like a data: URL. Ignore asset.imageDirectory and simply load the image directly.
            NSURL *imageUrl = [NSURL URLWithString:asset.imageName];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            image = [UIImage imageWithData:imageData];
        } else if ([asset.imageName hasPrefix:@"http://"] || [asset.imageName hasPrefix:@"https://"]) {
            NSURL *imageUrl = [NSURL URLWithString:asset.imageName];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            image = [UIImage imageWithData:imageData];
        } else if (asset.rootDirectory.length > 0) {
            NSString *rootDirectory  = asset.rootDirectory;
            if (asset.imageDirectory.length > 0) {
                rootDirectory = [rootDirectory stringByAppendingPathComponent:asset.imageDirectory];
            }
            NSString *imagePath = [rootDirectory stringByAppendingPathComponent:asset.imageName];
            
            id<LOTImageCache> imageCache = [LOTCacheProvider imageCache];
            if (imageCache) {
                image = [imageCache imageForKey:imagePath];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:imagePath];
                    [imageCache setImage:image forKey:imagePath];
                }
            } else {
                image = [UIImage imageWithContentsOfFile:imagePath];
            }
        } else {
            NSString *imagePath = [asset.assetBundle pathForResource:asset.imageName ofType:nil];
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        
        //try loading from asset catalogue instead if all else fails
        if (!image) {
            image = [UIImage imageNamed:asset.imageName inBundle: asset.assetBundle compatibleWithTraitCollection:nil];
        }
        
        if (image) {
            self.wrapperLayer.contents = (__bridge id _Nullable)(image.CGImage);
        } else {
            NSLog(@"%s: Warn: image not found: %@", __PRETTY_FUNCTION__, asset.imageName);
        }
    }
}

#endif


@end
