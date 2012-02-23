By Peter R. Elespuru

controls:
------------------------------------------------------------------------------
tap             = toggle texture
double tap      = toggle lighting
pinch i/o       = zoom in/out
2finger rotate  = cycle through available textures 
APPLE + ->      = rotate right
APPLE + <-      = rotate left

summary:
------------------------------------------------------------------------------
open the Xcode project, build and run

I uploaded a video of it in action here as well:
http://youtu.be/cC_kSiKNxLQ

I started with a simple 3rd party colored cube built using GLKit, attributions in the code
as well, but here's its GitHub project https://github.com/ianterrell/GLKit-Cube-Tutorial

I modified it to add multi-touch gesture support, lighting, textures, and texture
cycling.

The lighting isn't perfect, some of the normal calculations are off, but that's more
a model+normals issue than the actual use of GLKit for doing the lighting, so I
haven't gotten around to resolving the normal calculations so they're perfect. It's
close enough to get the point across.
