//
//  CubeAppDelegate.m
//  Cube
//
//  Modified by Peter R. Elespuru 2/12
// 
//  Added touch controls
//
//  Created by Ian Terrell on 7/19/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//
//  Texturing derived from lessons here:
//  http://games.ianterrell.com/how-to-texturize-objects-with-glkit/
//

#import "CubeAppDelegate.h"
#import "ColorfulCube.h"

#define M_TAU (2*M_PI)
#define USE_DEPTH_BUFFER 1

float _prevScale = 0.0;

@implementation CubeAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:context];
  
  GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
  view.delegate = self;
 
  GLKViewController *controller = [[GLKViewController alloc] init];
  controller.delegate = self;
  controller.view = view;
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = controller;
  [self.window makeKeyAndVisible];
    
  UITapGestureRecognizer *dtr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  dtr.numberOfTapsRequired = 2;    

  UIGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  [tr requireGestureRecognizerToFail:dtr];
    
  UIPinchGestureRecognizer *twoFingerPinch = 
  [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];

  UIRotationGestureRecognizer *swipe =
  [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    
  [view addGestureRecognizer:twoFingerPinch];     
  [view addGestureRecognizer:swipe];     
  [view addGestureRecognizer:tr];
  [view addGestureRecognizer:dtr];
       
  cubes = [[NSMutableArray alloc] init];
  
  ColorfulCube *cube = [[ColorfulCube alloc] init];
  cube.position = GLKVector3Make(0.0, 0.0, 0.0);
  cube.scale = GLKVector3Make(0.3, 0.3, 0.3);
  cube.rotation = GLKVector3Make(GLKMathDegreesToRadians(25.0f), 0, 0);
  cube.rps = GLKVector3Make(0.0, 0.3, 0.0);
  [cubes addObject:cube];
  
  return YES;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
  NSTimeInterval dt = [controller timeSinceLastDraw];
  for (id cube in cubes)
    [((ColorfulCube *)cube) updateRotations:dt];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.0, 0.0, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  [cubes makeObjectsPerformSelector:@selector(draw)];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

#pragma mark UIResponder Methods
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch* touch in touches)
    {
        CGPoint lastPoint = [touch previousLocationInView:_window];
        CGPoint newPoint = [touch locationInView:_window];
        
        for (id cube in cubes) {
            [((ColorfulCube *)cube) rotateY:(newPoint.x - lastPoint.x)];
            [((ColorfulCube *)cube) rotateX:(newPoint.y - lastPoint.y)];
        }
    }
    
}

//- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
- (void)handleTap:(UIGestureRecognizer*)gr {
    
    for (id cube in cubes) { 
        [((ColorfulCube *)cube) toggleTextures];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer*)gr {

    for (id cube in cubes) { 
        [((ColorfulCube *)cube) toggleLighting];
    }
    
}

-(void)swipe:(UIRotationGestureRecognizer *)recognizer 
{
    for (id cube in cubes) { 
        [((ColorfulCube *)cube) varyTexture];
    }
}

-(void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer 
{
    float factor = (recognizer.scale - _prevScale) / 10.0;

    // this will need to be fixed for multiple objects if any are added
    for (id cube in cubes) { 
        if ([((ColorfulCube *)cube) scale:factor]) {
            _prevScale = recognizer.scale;   
        }
    }
}

- (void) touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
}


@end
