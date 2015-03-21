//
//  JavaButton.m
//

#import <openssl/rand.h>
#import "JavaButton.h"

@implementation JavaButton
+ (GLuint)loadTexOfName:(NSString*)name ofType:(NSString*)type {
	GLuint javaboTexName;
	NSString *javabuttonPath=[[NSBundle bundleWithIdentifier:@"es.esy.arigato-java.FlyingJavabo"]
							  pathForResource:name ofType:type];
	NSImage *jbImg=[[NSImage alloc] initWithContentsOfFile:javabuttonPath];
	if(jbImg==nil) {
		return -1;
	}
	CGImageRef image=[jbImg CGImageForProposedRect:nil context:[NSGraphicsContext currentContext] hints:nil];
	NSInteger width=CGImageGetWidth(image);
	NSInteger height=CGImageGetHeight(image);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef context=CGBitmapContextCreate(NULL,width,height,8,4*width,colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
	if(!context) { return -2; }
	CGContextDrawImage(context,CGRectMake(0.f,0.f,(float)width,(float)height),image);
	
	glPixelStorei(GL_UNPACK_ALIGNMENT,1);
	glGenTextures(1,&javaboTexName);
	glBindTexture(GL_TEXTURE_2D,javaboTexName);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
					GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
					GL_NEAREST);
	void *jbbuf=CGBitmapContextGetData(context);
	glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,
				 (GLsizei)width,(GLsizei)height,0,
				 GL_RGBA,GL_UNSIGNED_BYTE,
				 jbbuf);
	CGContextRelease(context);
	return javaboTexName;
}
- (GLuint)prepareSingleJavaboDispList {
	GLuint javaboTexName=[[self class] loadTexOfName:@"javabutton" ofType:@"png"];
	if(javaboTexName==-1) {
		NSLog(@"javabo texture load failed.");
	}
	GLuint javaboDispListName=glGenLists(1);
	glNewList(javaboDispListName,GL_COMPILE);
	
	#define JAVABO_LEFT		-.8f
	#define JAVABO_RIGHT	.8f
	#define JAVABO_TOP		-.2f
	#define JAVABO_BOTTOM	.2f
	#define JAVABO_Z		0.f
	static const GLfloat vertices[]={
		JAVABO_LEFT, JAVABO_TOP, JAVABO_Z,
		JAVABO_LEFT, JAVABO_BOTTOM, JAVABO_Z,
		JAVABO_RIGHT, JAVABO_BOTTOM, JAVABO_Z,
		JAVABO_RIGHT, JAVABO_TOP, JAVABO_Z
	};
	static const GLfloat norm[] = {
		0.f, 0.f, -1.f,
		0.f, 0.f, -1.f,
		0.f, 0.f, -1.f,
		0.f, 0.f, -1.f
	};
	static const GLfloat texcoords[]={
		1.f,1.f,
		1.f,0.f,
		0.f,0.f,
		0.f,1.f
	};
	glEnable(GL_TEXTURE_2D);
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	glBindTexture(GL_TEXTURE_2D,javaboTexName);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, texcoords);

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	glNormalPointer(GL_FLOAT, 0, norm);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_QUADS, 0, 4);

	glDisableClientState(GL_NORMAL_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	

	glEndList();
	
	return javaboDispListName;
}
+ (double)random: (double)max {
	uint32_t randombits;
	RAND_bytes((void *)&randombits,sizeof(randombits));
	return max*((double)randombits/(double)UINT32_MAX);
}
- (GLuint)dispListWithShadow:(GLuint)shadow {
	static const long numJavaBo=96;
	
	GLuint singleJavabo=[self prepareSingleJavaboDispList];
	GLuint javaboCageDispListName=glGenLists(1);
	glNewList(javaboCageDispListName,GL_COMPILE);
	
	for(long i=0; i<numJavaBo; i++) {
		double x,y,z;
		x=-10.+[[self class] random:20.];
		y=-1.+[[self class] random:6.];
		z=-1.+[[self class] random:64.];
		glPushMatrix();
		glTranslated(x,y,z);
		glCallList(singleJavabo);
		glPopMatrix();
		
		glPushMatrix();
		glTranslated(x,0.,z);
		glScalef(.8f,1.f,.05f);
		glCallList(shadow);
		glPopMatrix();
	}
	
	glEndList();
	return javaboCageDispListName;
}

@end
