//
//  Duke.m
//  FlyingDUKE
//
#import "Duke.h"
#import "JavaButton.h"

@implementation Duke
- (GLuint)prepareDukeDispList {
	GLuint dukeTexName=[JavaButton loadTexOfName:@"duke" ofType:@"png"];
	GLuint dukeDispListName=glGenLists(1);
	glNewList(dukeDispListName,GL_COMPILE);

	#define DUKE_LEFT		-.2f
	#define DUKE_RIGHT	.2f
	#define DUKE_TOP		-1.18f
	#define DUKE_BOTTOM	-.78f
	#define DUKE_Z		0.f
	static const GLfloat vertices[]={
		DUKE_LEFT, DUKE_TOP, DUKE_Z,
		DUKE_LEFT, DUKE_BOTTOM, DUKE_Z,
		DUKE_RIGHT, DUKE_BOTTOM, DUKE_Z,
		DUKE_RIGHT, DUKE_TOP, DUKE_Z
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
	glBindTexture(GL_TEXTURE_2D,dukeTexName);
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
	return dukeDispListName;
}
- (GLuint)dispListWithShadow:(GLuint)shadow {
	static const long nDuke=64;
	GLuint dukeDispList=[self prepareDukeDispList];
	GLuint dukeCageDispListName=glGenLists(1);
	glNewList(dukeCageDispListName,GL_COMPILE);
	
	for(long i=0; i<nDuke; i++) {
		double x=-5+[JavaButton random:10.];
		double z=[JavaButton random:64.];
		glPushMatrix();
		glTranslated(x,0.,z);
		glCallList(dukeDispList);
		glScalef(.12f,1.f,.2f);
		glCallList(shadow);
		glPopMatrix();
	}
	
	glEndList();
	return dukeCageDispListName;
}
@end
