//
//  ColorfulCube.m
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

#import "ColorfulCube.h"
#define M_TAU (2*M_PI)
#define USE_DEPTH_BUFFER 1

const static int NUM_VERTS = 8;
const static int NUM_STRIPS = 4;
const static int NUM_COUNTS = 36;

static BOOL initialized = NO;
static GLKVector3 vertices[NUM_VERTS];
static GLKVector3 triangleVertices[NUM_COUNTS];
static GLKVector3 triangleNormals[NUM_COUNTS];
static GLKVector4 colors[NUM_VERTS];
static GLKVector4 triangleColors[NUM_COUNTS];
static GLKBaseEffect *effect;
static int texIndex = 0;
@implementation ColorfulCube

@synthesize position, rotation, scale, rps, _texture, _lighting;


- (id)init
{
    // both on by default
    _texture = 0;
    _lighting = 1;
    
    self = [super init];
    if (self) {
        position = GLKVector3Make(0,0,0);
        rotation = GLKVector3Make(0,0,0);
        scale =    GLKVector3Make(1,1,1);
        
        [self setTextureImage:[UIImage imageNamed:@"crate.jpg"]];
        
        // recall texture origin is top left, GL origin is bot left, have to map between the two
        // Front
        self.textureCoordinates[0] = GLKVector2Make(0,1);
        triangleNormals[0] = GLKVector3Make(0,0,1);
        self.textureCoordinates[1] = GLKVector2Make(1,1);
        triangleNormals[1] = GLKVector3Make(0,0,1);
        self.textureCoordinates[2] = GLKVector2Make(1,0);
        triangleNormals[2] = GLKVector3Make(0,0,1);
        
        self.textureCoordinates[3] = GLKVector2Make(0,1);
        triangleNormals[3] = GLKVector3Make(0,0,1);
        self.textureCoordinates[4] = GLKVector2Make(1,0);
        triangleNormals[4] = GLKVector3Make(0,0,1);
        self.textureCoordinates[5] = GLKVector2Make(0,0);
        triangleNormals[5] = GLKVector3Make(0,0,1);
        
        // Right
        self.textureCoordinates[6] = GLKVector2Make(0,1);
        triangleNormals[6] = GLKVector3Make(1,0,0);
        self.textureCoordinates[7] = GLKVector2Make(1,1);
        triangleNormals[7] = GLKVector3Make(1,0,0);
        self.textureCoordinates[8] = GLKVector2Make(1,0);
        triangleNormals[8] = GLKVector3Make(1,0,0);

        self.textureCoordinates[9] = GLKVector2Make(0,1);
        triangleNormals[9] = GLKVector3Make(1,0,0);
        self.textureCoordinates[10] = GLKVector2Make(1,0);
        triangleNormals[10] = GLKVector3Make(1,0,0);
        self.textureCoordinates[11] = GLKVector2Make(0,0);
        triangleNormals[11] = GLKVector3Make(1,0,0);

        // Back
        self.textureCoordinates[12] = GLKVector2Make(0,1);
        triangleNormals[12] = GLKVector3Make(0,0,1);
        self.textureCoordinates[13] = GLKVector2Make(1,1);
        triangleNormals[13] = GLKVector3Make(0,0,1);
        self.textureCoordinates[14] = GLKVector2Make(1,0);
        triangleNormals[14] = GLKVector3Make(0,0,1);
         
        self.textureCoordinates[15] = GLKVector2Make(0,1);
        triangleNormals[15] = GLKVector3Make(0,0,1);
        self.textureCoordinates[16] = GLKVector2Make(1,0);
        triangleNormals[16] = GLKVector3Make(0,0,1);
        self.textureCoordinates[17] = GLKVector2Make(0,0);
        triangleNormals[17] = GLKVector3Make(0,0,1);
         
        // Left
        self.textureCoordinates[18] = GLKVector2Make(0,1);         
        triangleNormals[18] = GLKVector3Make(1,0,0);
        self.textureCoordinates[19] = GLKVector2Make(1,1);
        triangleNormals[19] = GLKVector3Make(1,0,0);
        self.textureCoordinates[20] = GLKVector2Make(1,0);
        triangleNormals[20] = GLKVector3Make(1,0,0);
         
        self.textureCoordinates[21] = GLKVector2Make(0,1);
        triangleNormals[21] = GLKVector3Make(1,0,0);
        self.textureCoordinates[22] = GLKVector2Make(1,0);
        triangleNormals[22] = GLKVector3Make(1,0,0);
        self.textureCoordinates[23] = GLKVector2Make(0,0);
        triangleNormals[23] = GLKVector3Make(1,0,0);

        // Top
        self.textureCoordinates[24] = GLKVector2Make(0,1);
        triangleNormals[24] = GLKVector3Make(0,1,0);
        self.textureCoordinates[25] = GLKVector2Make(1,1);
        triangleNormals[25] = GLKVector3Make(0,1,0);
        self.textureCoordinates[26] = GLKVector2Make(1,0);
        triangleNormals[26] = GLKVector3Make(0,1,0);
         
        self.textureCoordinates[27] = GLKVector2Make(0,1);
        triangleNormals[27] = GLKVector3Make(0,1,0);
        self.textureCoordinates[28] = GLKVector2Make(1,0);
        triangleNormals[28] = GLKVector3Make(0,1,0);
        self.textureCoordinates[29] = GLKVector2Make(0,0);
        triangleNormals[29] = GLKVector3Make(0,1,0);
        
        // Bottom
        self.textureCoordinates[30] = GLKVector2Make(0,1);
        triangleNormals[30] = GLKVector3Make(0,-1,0);
        self.textureCoordinates[31] = GLKVector2Make(1,1);
        triangleNormals[31] = GLKVector3Make(0,-1,0);
        self.textureCoordinates[32] = GLKVector2Make(1,0);
        triangleNormals[32] = GLKVector3Make(0,-1,0);
         
        self.textureCoordinates[33] = GLKVector2Make(0,1);
        triangleNormals[33] = GLKVector3Make(0,-1,0);
        self.textureCoordinates[34] = GLKVector2Make(1,0);
        triangleNormals[34] = GLKVector3Make(0,-1,0);
        self.textureCoordinates[35] = GLKVector2Make(0,0);
        triangleNormals[35] = GLKVector3Make(0,-1,0);
    }
    
    return self;
}

+ (void)initialize {
    
    if (!initialized) {      
        
        vertices[0] = GLKVector3Make(-0.5, -0.5,  0.5); // Left  bottom front
        vertices[1] = GLKVector3Make( 0.5, -0.5,  0.5); // Right bottom front
        vertices[2] = GLKVector3Make( 0.5,  0.5,  0.5); // Right top    front
        vertices[3] = GLKVector3Make(-0.5,  0.5,  0.5); // Left  top    front
        vertices[4] = GLKVector3Make(-0.5, -0.5, -0.5); // Left  bottom back
        vertices[5] = GLKVector3Make( 0.5, -0.5, -0.5); // Right bottom back
        vertices[6] = GLKVector3Make( 0.5,  0.5, -0.5); // Right top    back
        vertices[7] = GLKVector3Make(-0.5,  0.5, -0.5); // Left  top    back
        
        colors[0] = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Red
        colors[1] = GLKVector4Make(0.0, 1.0, 0.0, 1.0); // Green
        colors[2] = GLKVector4Make(0.0, 0.0, 1.0, 1.0); // Blue
        colors[3] = GLKVector4Make(1.0, 1.0, 1.0, 1.0); // white
        colors[4] = GLKVector4Make(0.0, 0.0, 1.0, 1.0); // Blue
        colors[5] = GLKVector4Make(1.0, 1.0, 1.0, 1.0); // white
        colors[6] = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Red
        colors[7] = GLKVector4Make(0.0, 1.0, 0.0, 1.0); // Green
        
        int vertexIndices[NUM_COUNTS] = {
            // Front
            0, 1, 2,
            0, 2, 3,
            // Right
            1, 5, 6,
            1, 6, 2,
            // Back
            5, 4, 7,
            5, 7, 6,
            // Left
            4, 0, 3,
            4, 3, 7,
            // Top
            3, 2, 6,
            3, 6, 7,
            // Bottom
            4, 5, 1,
            4, 1, 0,
        };
        
        for (int i = 0; i < NUM_COUNTS; i++) {
            triangleVertices[i] = vertices[vertexIndices[i]];
            triangleColors[i] = colors[vertexIndices[i]];
        }
        
        effect = [[GLKBaseEffect alloc] init];
        initialized = YES;
    }
}

- (void)toggleTextures {
    
    if (_texture) {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0); 
    }
    
    _texture = !_texture;
    
    [self draw];
}

- (void)toggleLighting {
    
    if (_lighting) {
        glDisableVertexAttribArray(GLKVertexAttribNormal); 
    }
    
    _lighting = !_lighting;
    
    [self draw];
}

-(void)setTextureImage:(UIImage *)image {
    NSError *error;
    
    texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
    if (error) {
        NSLog(@"Error loading texture from image: %@",error);
    }
}

- (void)setTextureFile:(NSString *)file {
    
    NSError *error;
    
    texture = [GLKTextureLoader textureWithContentsOfFile:file options:nil error:&error];  
    
    if (error) {
        NSLog(@"Error loading texture from file: %@",error);
    }
}

- (GLKVector2 *)textureCoordinates {
    if (textureCoordinateData == nil) {
        textureCoordinateData = [NSMutableData dataWithLength:sizeof(GLKVector2) * NUM_COUNTS];
    }
    return [textureCoordinateData mutableBytes];
}

- (void)rotateY:(int) deg {
    rotation.y += GLKMathDegreesToRadians(deg);
}

- (void)rotateX:(int) deg {
    rotation.x += GLKMathDegreesToRadians(deg);
}

- (void)varyTexture {
    
    NSString* texs[] = 
    {
        @"crate.jpg",
        @"alien.png",
        @"cave.png",
        @"colorful.png",
        @"funky.png",
        @"lmetal.png",
        @"metal.png",
        @"stones.jpg",
        @"water.jpg"
    };
    
    texIndex = ((texIndex+1)%9);
    [self setTextureImage:[UIImage imageNamed:texs[texIndex]]];
}

- (BOOL)scale:(float) factor {
    
    if (scale.x + factor >= 1.2) { return NO; }
    
    scale.x += factor;
    scale.y += factor;
    scale.z += factor;
    
    return YES;
}

- (void)draw
{
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(rotation.x);
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(rotation.y);
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(rotation.z);
    GLKMatrix4 scaleMatrix     = GLKMatrix4MakeScale(scale.x, scale.y, scale.z);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply
    (
     translateMatrix,
     GLKMatrix4Multiply(scaleMatrix, GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix)))
     );
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
    effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 2.0/3.0, 2, -1);
    
    // add lighting
    if (_lighting) {
        effect.light0.enabled = GL_TRUE; 
        effect.light0.diffuseColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);
        effect.light0.position = GLKVector4Make(1.0f, 1.0f, 0.5f, 0.0f);
        effect.lightingType = GLKLightingTypePerPixel;        
        effect.material.shininess = 5.0;
        effect.material.specularColor = GLKVector4Make(0.5, 0.5, 0.5, 1);
    } else {
        effect.light0.enabled = GL_FALSE;         
    }

    // add texture
    if (texture != nil && _texture) {
        effect.texture2d0.enabled = GL_TRUE;
        effect.texture2d0.envMode = GLKTextureEnvModeReplace;
        effect.texture2d0.target = GLKTextureTarget2D;
        effect.texture2d0.name = texture.name;
    } else {
        effect.texture2d0.enabled = GL_FALSE;
    }
    
    [effect prepareToDraw];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);    
    
    // still do something by default in case the texturing bombs
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, triangleColors);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, triangleVertices);

    if (_lighting) {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, triangleNormals);
    }
    
    if (texture != nil && _texture) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.textureCoordinates);
    }
    
    glDrawArrays(GL_TRIANGLES, 0, NUM_COUNTS);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    if (texture != nil && _texture) { 
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0); 
    }
    
    if (_lighting) {
        glDisableVertexAttribArray(GLKVertexAttribNormal); 
    }
}

- (void)updateRotations:(NSTimeInterval)dt {
    rotation = GLKVector3Add(rotation, GLKVector3MultiplyScalar(rps, dt));
}

@end
