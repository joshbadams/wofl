//
//  Shader.fsh
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

varying lowp vec2 UVVarying;

uniform sampler2D SpriteTexture;
uniform lowp vec4 Color;

void main()
{
//	highp vec2 DistVec = UVVarying - vec2(0.5, 0.5);
//	highp float Dist = sqrt(DistVec.x * DistVec.x + DistVec.y * DistVec.y);
//	if (Dist < 0.6 && Dist > 0.5)
//	{
//		gl_FragColor = vec4(0, 1, 0, 1);
//		return;
//	}
    gl_FragColor = Color * texture2D(SpriteTexture, UVVarying);
}
