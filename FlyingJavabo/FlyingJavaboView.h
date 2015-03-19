//
//  FlyingJavaboView.h
//  FlyingJavabo
//

#import <ScreenSaver/ScreenSaver.h>
#import "JavaboGLView.h"

@interface FlyingJavaboView : ScreenSaverView
{
	JavaboGLView *glView;
	NSDate *startTime;
}
@end
