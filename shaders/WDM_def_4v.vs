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
in vec2 TextureSize;
in float PixelationAmount;
in vec3 ClipPlane;

out vec4 Color0;
out vec2 TexCoord0;
out vec4 ColorizeOut;
out vec3 ColorOffsetOut;
out vec2 TextureSizeOut;
out float PixelationAmountOut;
out vec3 ClipPlaneOut;

#else

attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute vec4 ColorizeIn;
attribute vec3 ColorOffsetIn;
attribute vec2 TextureSize;
attribute float PixelationAmount;
attribute vec3 ClipPlane;

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 ColorizeOut;
varying vec3 ColorOffsetOut;
varying vec2 TextureSizeOut;
varying float PixelationAmountOut;
varying vec3 ClipPlaneOut;

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

float cp = 2048.0;
vec2 unpackQual(float packed) {
    float dy = floor(packed / cp);
    float dx = mod(packed, cp);
    return vec2(dy, dx);
}


void main(void) {
    vec3 main_position = Position;
    main_position.z = Color.a;

    vec3 end_position = vec3(  //right down edge
        Color.r / Color.a ,
        Color.g / Color.a ,
        Color.b / Color.a
    );

    vec3 angle_position = vec3(  //right up edge
        ColorizeIn.r,
        ColorizeIn.g,
        ColorizeIn.b
    );

    vec3 dr_position = vec3(  //left down edge
        ColorOffsetIn.r,
        ColorOffsetIn.g,
        ColorOffsetIn.b
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


    mat4 projection = perspectiveMat(fov, aspect, 0.1, 100.);
	mat4 view = translateMat(vec3(0.0, 0.0, -1.0));

    vec2 upcakedColorize = unpackQual(ColorizeIn.a);
    float prcision = upcakedColorize.x;
    float ZOffset = upcakedColorize.y;
    float prcisionofffset = mod(1.0/prcision, 1.0);
    if (prcision > 0.5 && prcision < 1.1) prcisionofffset = 0.5;
    else if (prcision > 1.7 && prcision < 2.1) prcisionofffset = 0.25;
    else if (prcision > 2.7)  {
        prcision = 3.;
        prcisionofffset = 1./6.;
    }

    vec3 newPos;
    int VertexId = gl_VertexID % 4; // mod(gl_VertexID, 4);
    if (VertexId == 0) newPos = main_position;
    else if (VertexId == 1) newPos = angle_position;
    else if (VertexId == 2) newPos = dr_position;
    else if (VertexId == 3) newPos = end_position;


    newPos = floor( (newPos + vec3(prcisionofffset, prcisionofffset, 0.0)) * prcision ) / prcision;


    vec3 noZPos = vec3(newPos.xy, 0);

    vec4 proje_trans = projection * view * (trans2 * translateMat(newPos) * vec4(noZPos, 1.0)); //
    vec4 clear_trans = (trans2 * vec4(newPos, 1.0)); //
    vec4 defGLPosition = Transform * vec4(Position.xyz, 1.0);

    vec4 refGl = defGLPosition;
    refGl.z = refGl.z + clear_trans.z * 0.00001 + ZOffset * -0.00001 + 0.001;
    refGl.xy = clear_trans.xy;
    refGl.w = defGLPosition.w + proje_trans.w * 0.005;

    gl_Position = refGl;

    TexCoord0 = TexCoord;
    TextureSizeOut = TextureSize;
    ClipPlaneOut = ClipPlane;

   // ZClipFarOut = min(main_position.z, min(end_position.z, min(angle_position.z, dr_position.z)));
    //ZClipNearOut = max(main_position.z, max(end_position.z, max(angle_position.z, dr_position.z)));

    //ZClipOut = ZClipFarOut;
}

