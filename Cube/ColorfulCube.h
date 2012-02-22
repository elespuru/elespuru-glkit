//
//  ColorfulCube.h
//  Cube
//
//  Modified by Peter R. Elespuru 2/12
//
//  Added multi-touch controls
//  Added texturing, w/changeable textures
//  Added lighting
//
//  Created by Ian Terrell on 7/19/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//
//  Texturing derived from lessons here:
//  http://games.ianterrell.com/how-to-texturize-objects-with-glkit/
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ColorfulCube : NSObject {
  GLKVector3 position, rotation, scale, rps;
  NSMutableData *textureCoordinateData;
  GLKTextureInfo *texture;
}

@property GLKVector3 position, rotation, scale, rps;
@property int _texture, _lighting;
@property(readonly) GLKVector2 *textureCoordinates;

- (void)draw;
- (void)toggleTextures;
- (void)toggleLighting;
- (void)rotateY:(int) deg;
- (void)rotateX:(int) deg;
- (BOOL)scale:(float) factor;
- (void)varyTexture;
- (void)updateRotations:(NSTimeInterval)dt;
- (void)setTextureFile:(NSString *)file;
- (void)setTextureImage:(UIImage *)image;

@end
