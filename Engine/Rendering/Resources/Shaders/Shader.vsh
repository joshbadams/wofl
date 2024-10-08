attribute vec2 Corner;

varying vec2 UVVarying;
varying vec4 ColorVarying;

uniform vec4 UVScaleBias;
uniform mat4 SpriteMatrix;

uniform mat4 ViewMatrix;

void main()
{
	gl_Position = /* ViewMatrix * SpriteMatrix * */ vec4(Corner.x, Corner.y, 0.0, 1.0);
//	gl_Position = SpriteMatrix * ViewMatrix * vec4(Corner.x, Corner.y, 0.0, 1.0);

	UVVarying = vec2(Corner.x, 1.0 - Corner.y) * UVScaleBias.xy + UVScaleBias.zw;
}
