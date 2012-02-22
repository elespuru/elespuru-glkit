//
//  CubeAppDelegate.h
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

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface CubeAppDelegate : UIResponder <UIApplicationDelegate, GLKViewDelegate, GLKViewControllerDelegate> {
  NSMutableArray *cubes;
}

@property (strong, nonatomic) UIWindow *window;

@end
