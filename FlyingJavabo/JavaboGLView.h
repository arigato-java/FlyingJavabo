//
//  JavaboGLView.h
//  FlyingJavabo
//

#import <Cocoa/Cocoa.h>

@interface JavaboGLView : NSOpenGLView
{
	GLuint floorDispList;
	GLuint skyDispList;
	GLuint javaboDispList;
	uint64_t t;
}
- (instancetype)initWithFrame:(NSRect)frameRect;
- (void)prepareOpenGL;
- (void)setElapsedTime: (NSTimeInterval)seconds;
@end
