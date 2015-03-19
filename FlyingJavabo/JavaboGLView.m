//
//  JavaboGLView.m
//  FlyingJavabo
//

#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLKit/GLKit.h>
#import "JavaboGLView.h"
#import "JavaButton.h"

extern GLuint prepareFloorDispList(void);
extern GLuint prepareSkyDispList(void);

@implementation JavaboGLView
- (instancetype)initWithFrame:(NSRect)frameRect {
	static const NSOpenGLPixelFormatAttribute attribs[] = {
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersionLegacy,
		0
	};
	__autoreleasing NSOpenGLPixelFormat *pixelFormat=[[NSOpenGLPixelFormat alloc] initWithAttributes: attribs];
	self=[super initWithFrame:frameRect pixelFormat:pixelFormat];
	return self;
}
- (void)prepareOpenGL {
	[super prepareOpenGL];
	// Initialize Matrices
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	CGRect bounds=[self bounds];
	gluPerspective(89.f,bounds.size.width/bounds.size.height,.01,64.);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(0.f,0.f,0.f,		// eye
			  0.,0.,5.,			// center
			  0.0,1.0,0.0);		// up

	glClearColor(0.5f,0.5f,1.0f,1.0f);
	
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_ALPHA_TEST);
	glAlphaFunc(GL_GREATER,0.f);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	glEnable(GL_CULL_FACE);
	glFrontFace(GL_CCW);
	glCullFace(GL_BACK);

	static const GLfloat fogColor[]={1.f,1.f,1.f,1.f};
	glFogi(GL_FOG_MODE,GL_EXP2);
	glFogfv(GL_FOG_COLOR, fogColor);
	glFogf(GL_FOG_DENSITY, 0.05f);
	glHint(GL_FOG_HINT, GL_NICEST);
	glFogf(GL_FOG_START,1.f);
	glFogf(GL_FOG_END, 64.f);

	floorDispList=prepareFloorDispList();
	skyDispList=prepareSkyDispList();
	javaboDispList=[[[JavaButton alloc] init] prepareJavaboDispList];
}
- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	
	static const uint32_t floor_speed=0xf;
	glPushMatrix();
	glCallList(skyDispList);
	glTranslatef(.01f,.01f,((float)((t&floor_speed)+1))/-(float)floor_speed);
	glCallList(floorDispList);
	glPopMatrix();

	static const uint32_t javabo_speed=0x1ff;
	glPushMatrix();
	glTranslatef(.01f,.01f,-64.f*(float)(t&javabo_speed)/(float)javabo_speed);
	glCallList(javaboDispList);
	glTranslatef(0.f,0.f,64.f);
	glCallList(javaboDispList);
	glPopMatrix();
	
	[[self openGLContext] flushBuffer];
}
- (void)setElapsedTime: (double)seconds {
	t=seconds*60.;
}
@end
