#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140
in int gl_VertexID;
in vec3 Position;
in vec4 Color;
in vec2 TexCoord;
in vec4 ColorizeIn;
in vec3 ColorOffsetIn;
in vec3 ClipPlane;
in vec2 Ratio;
in vec4 ScreenSize;
out vec2 TexCoord0;
#else
attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute vec4 ColorizeIn;
attribute vec3 ColorOffsetIn;
attribute vec2 Ratio;
attribute vec3 ClipPlane;
attribute vec4 ScreenSize;
varying vec2 TexCoord0;
#endif


uniform mat4 Transform;

#define DEG2RAD 0.01745329251

mat4 translateMat(vec3 t) {
    return mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        t.x, t.y, t.z, 1.0
    );
}

mat4 perspectiveMat(float fov, float aspect, float near, float far) {
    float f = 1.0 / tan(fov * 0.5);
    return mat4(
        f/aspect, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (far+near)/(near-far), -1.0,
        0.0, 0.0, (2.0*far*near)/(near-far), 0.0
    );
}


void main(void) {
    vec3 main_position = Position;
    main_position.z = Color.a;

    vec3 angle_position = vec3(  //right up edge
        Color.r / Color.a ,
        Color.g / Color.a ,
        Color.b / Color.a
    );

    vec3 dl_position = vec3(  //left down edge
        ColorizeIn.r,
        ColorizeIn.g,
        ColorizeIn.b
    );

    mat4 trans2 = mat4(
		Transform[0].x , Transform[0].y , 0. ,  0. ,
		Transform[1].x , Transform[1].y , 0. ,  0. ,
		Transform[2].x , Transform[2].y , 1.0 , 0. ,
		Transform[3].x , Transform[3].y , 0. , 1. 
	);

    vec3 center = vec3(0.5, 0.5, 0.0);
	float fov = 50.0 * DEG2RAD;
	float aspect = 1. ;


    mat4 projection = perspectiveMat(fov, aspect, 0.1, 100);
	mat4 view = translateMat(vec3(0.0, 0.0, -1.0));

    vec3 newPos;
    if (gl_VertexID == 0) newPos = main_position;
    else if (gl_VertexID == 1) newPos = angle_position;
    else if (gl_VertexID == 2) newPos = dl_position;
    else if (gl_VertexID == 3) newPos = dl_position;

    mat4 model = 
        translateMat(newPos) *
		translateMat(center) *
		translateMat(-center);

    vec3 noZPos = vec3(newPos.xy, 0);

    vec4 proje_trans = projection * view *  (trans2 * model * vec4(noZPos, 1.0)); //
    vec4 clear_trans = (trans2 * vec4(newPos, 1.0)); //
    vec4 defGLPosition = Transform * vec4(Position.xyz, 1.0);

    vec4 refGl = defGLPosition;
    refGl.z = refGl.z - clear_trans.z * 0.00001 + ColorizeIn.a;
    refGl.xy = clear_trans.xy;
    refGl.w = defGLPosition.w + proje_trans.w * 0.01;

    gl_Position = refGl;

    TexCoord0 = TexCoord;
}

