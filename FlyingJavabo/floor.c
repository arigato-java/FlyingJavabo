// floor
#include <OpenGL/gl.h>

static GLuint floorTexName;
static void setupFloorTex(void);

static void setupFloorTex() {
	static const GLubyte boxes[]={
		0x40,0xcc,0xcc,0x40
	};
	glPixelStorei(GL_UNPACK_ALIGNMENT,1);
	glGenTextures(1,&floorTexName);
	glBindTexture(GL_TEXTURE_2D,floorTexName);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
					GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
					GL_NEAREST);
	glTexImage2D(GL_TEXTURE_2D,0,GL_LUMINANCE,
				 2,2,0,
				 GL_LUMINANCE,GL_UNSIGNED_BYTE,
				 boxes);
}

extern GLuint prepareFloorDispList() {
	setupFloorTex();
	
	GLuint floorDispList=glGenLists(1);
	glNewList(floorDispList, GL_COMPILE);
	
	#define FLOOR_W 128.f
	#define FLOOR_NEAR -1.f
	#define FLOOR_DEPTH 127.f
	#define FLOOR_Y -1.2f
	static const GLfloat vertices[]={
		-FLOOR_W, FLOOR_Y, FLOOR_DEPTH,
		FLOOR_W, FLOOR_Y, FLOOR_DEPTH,
		FLOOR_W, FLOOR_Y, FLOOR_NEAR,
		-FLOOR_W, FLOOR_Y, FLOOR_NEAR };
	static const GLfloat colors[]={
		0.f,1.f,0.f,1.f,
		0.f,1.f,0.f,1.f,
		0.f,1.f,0.f,1.f,
		0.f,1.f,0.f,1.f };
	static const GLfloat norm[]={
		0.f,1.f,0.f,
		0.f,1.f,0.f,
		0.f,1.f,0.f,
		0.f,1.f,0.f };
	glEnable(GL_FOG);

	#define FLOORTEXREPCNT_Y 256.f
	#define FLOORTEXREPCNT_X 256.f
	static const GLfloat texcoords[]={
		0.f, 0.f,
		0.f, FLOORTEXREPCNT_Y,
		FLOORTEXREPCNT_X, FLOORTEXREPCNT_Y,
		FLOORTEXREPCNT_X, 0.f };
	static const float texenv_white[]={1.f,1.f,1.f,1.f};
	glEnable(GL_TEXTURE_2D);
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_BLEND);
	glTexEnvfv(GL_TEXTURE_ENV,GL_TEXTURE_ENV_COLOR,texenv_white);
	glBindTexture(GL_TEXTURE_2D,floorTexName);
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

	glDisable(GL_FOG);
	
	glEndList();
	
	return floorDispList;
}

