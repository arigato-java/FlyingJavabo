//
//  JavaButton.h
//  FlyingJavabo
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface JavaButton : NSObject
+ (GLuint)loadTexOfName:(NSString*)name ofType:(NSString*)type;
- (GLuint)prepareJavaboDispList;
@end
