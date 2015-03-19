// sky
#include <OpenGL/gl.h>
extern GLuint prepareSkyDispList() {
	GLuint skyDispListName=glGenLists(1);
	glNewList(skyDispListName, GL_COMPILE);
	
	#define SKY_HIGH 5.f
	#define SKY_W 1024.f
	#define SKY_NEAR 0.f
	#define SKY_FAR 64.f
	static const GLfloat vertices[] = {
		SKY_W, SKY_HIGH, SKY_NEAR,
		SKY_W, SKY_HIGH, SKY_FAR,
		-SKY_W, SKY_HIGH, SKY_FAR,
		-SKY_W, SKY_HIGH, SKY_NEAR };
	static const GLfloat colors[] = {
		1.f,.5f,.5f, 1.f,
		.8f,.6f,.6f, 1.f,
		.8f,.6f,.6f, 1.f,
		1.f,.5f,.5f, 1.f };
	static const GLfloat norm[]={
		0.f, -1.f, 0.f,
		0.f, -1.f, 0.f,
		0.f, -1.f, 0.f,
		0.f, -1.f, 0.f };
	glEnable(GL_FOG);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	glNormalPointer(GL_FLOAT, 0, norm);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glDrawArrays(GL_QUADS,0,4);
	glDisableClientState(GL_NORMAL_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisable(GL_FOG);
	
	glEndList();
	
	return skyDispListName;
}

