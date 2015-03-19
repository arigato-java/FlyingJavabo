//
//  FlyingJavaboView.m
//  FlyingJavabo
//

#import "FlyingJavaboView.h"

@implementation FlyingJavaboView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	self = [super initWithFrame:frame isPreview:isPreview];
	if (self) {
		glView=[[JavaboGLView alloc] initWithFrame:[self bounds]];
		[self addSubview:glView];
		[self setAnimationTimeInterval:1/60.0];
	}
	return self;
}

- (void)startAnimation
{
	[super startAnimation];
	startTime=[NSDate date];
}

- (void)stopAnimation
{
	[super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
}

- (void)animateOneFrame
{
	NSTimeInterval seconds=-[startTime timeIntervalSinceNow];
	[glView setElapsedTime:seconds];
	[glView setNeedsDisplay:YES];
	return;
}

- (BOOL)hasConfigureSheet
{
	return NO;
}

- (NSWindow*)configureSheet
{
	return nil;
}

@end
