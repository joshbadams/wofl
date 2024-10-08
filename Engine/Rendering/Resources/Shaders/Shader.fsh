varying vec2 UVVarying;

uniform sampler2D SpriteTexture;
uniform vec4 Color;

void main()
{
//	highp vec2 DistVec = UVVarying - vec2(0.5, 0.5);
//	highp float Dist = sqrt(DistVec.x * DistVec.x + DistVec.y * DistVec.y);
//	if (Dist < 0.6 && Dist > 0.5)
//	{
//		gl_FragColor = vec4(0, 1, 0, 1);
//		return;
//	}
    gl_FragColor = vec4(1,1,1,1);//Color * texture2D(SpriteTexture, UVVarying);
}
