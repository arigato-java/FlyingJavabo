//
//  shadow.c
//  FlyingJavabo
//
#include <OpenGL/gl.h>
#define SHADOWTEX_DIM 16
static GLubyte *generateShadowTex(void);
static GLuint prepareShadowTex(void);

static GLubyte *generateShadowTex(void) {
	static GLubyte shadow[SHADOWTEX_DIM*SHADOWTEX_DIM];
	long r=SHADOWTEX_DIM/2;
	long r2=r*r;
	for(long y=0; y<SHADOWTEX_DIM; y++) {
		for(long x=0; x<SHADOWTEX_DIM; x++) {
			long dx=x-r;
			long dy=y-r;
			long d2=dx*dx+dy*dy;
			shadow[y*SHADOWTEX_DIM+x]=(d2<r2)?0x77:0x00;
		}
	}
	return shadow;
}
static GLuint prepareShadowTex(void) {
	GLubyte *shadowTex=generateShadowTex();
	GLuint shadowTexName;
	glPixelStorei(GL_UNPACK_ALIGNMENT,1);
	glGenTextures(1,&shadowTexName);
	glBindTexture(GL_TEXTURE_2D,shadowTexName);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
					GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
					GL_NEAREST);
	glTexImage2D(GL_TEXTURE_2D,0,GL_ALPHA,
				 SHADOWTEX_DIM,SHADOWTEX_DIM,0,
				 GL_ALPHA,GL_UNSIGNED_BYTE,
				 shadowTex);
	return shadowTexName;
}
extern GLuint shadowDispList(void) {
	GLuint shadowTexName=prepareShadowTex();;
	
	GLuint shadow=glGenLists(1);
	glNewList(shadow, GL_COMPILE);

	#define SHADOW_W 1.f
	#define SHADOW_NEAR -1.f
	#define SHADOW_FAR 1.f
	#define SHADOW_Y -1.18f
	static const GLfloat vertices[]={
		-SHADOW_W, SHADOW_Y, SHADOW_FAR,
		SHADOW_W, SHADOW_Y, SHADOW_FAR,
		SHADOW_W, SHADOW_Y, SHADOW_NEAR,
		-SHADOW_W, SHADOW_Y, SHADOW_NEAR };
	static const GLfloat colors[]={
		0.f,0.f,0.f,1.f,
		0.f,0.f,0.f,1.f,
		0.f,0.f,0.f,1.f,
		0.f,0.f,0.f,1.f };
	static const GLfloat norm[]={
		0.f,1.f,0.f,
		0.f,1.f,0.f,
		0.f,1.f,0.f,
		0.f,1.f,0.f };
	
	static const GLfloat texcoords[]={
		0.f, 0.f,
		0.f, 1.f,
		1.f, 1.f,
		1.f, 0.f };
	static const float texenv_black[]={0.f,0.f,0.f,1.f};
	glEnable(GL_TEXTURE_2D);
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
	glTexEnvfv(GL_TEXTURE_ENV,GL_TEXTURE_ENV_COLOR,texenv_black);
	glBindTexture(GL_TEXTURE_2D,shadowTexName);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	glNormalPointer(GL_FLOAT, 0, norm);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glDrawArrays(GL_QUADS, 0, 4);
	glDisableClientState(GL_NORMAL_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	
	glEndList();
	
	return shadow;

}
