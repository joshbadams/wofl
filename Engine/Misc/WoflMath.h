//
//  WoflMath.h
//  Wofl
//
//  Created by Josh on 7/6/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

class Vector
{
public:
	float X, Y;
	
	Vector()
	: X(0), Y(0)
	{
	}
	
	Vector(float InX, float InY)
	: X(InX), Y(InY)
	{
	}

	Vector(const Vector& Other)
	: X(Other.X), Y(Other.Y)
	{
	}

	// negation
	inline Vector operator-()
	{
		return Vector(-X, -Y);
	}

	inline Vector operator+=(const Vector& Other)
	{
		X += Other.X;
		Y += Other.Y;
		return *this;
	}
	friend inline Vector operator+(Vector A, Vector B)
	{
		return A += B;
	}
	
	inline Vector operator-=(const Vector& Other)
	{
		X -= Other.X;
		Y -= Other.Y;
		return *this;
	}
	friend inline Vector operator-(Vector A, Vector B)
	{
		return A -= B;
	}
	
	inline Vector operator*=(float Scalar)
	{
		X *= Scalar;
		Y *= Scalar;
		return *this;
	}
	friend inline Vector operator*(Vector A, float Scalar)
	{
		return A *= Scalar;
	}
	
	inline Vector operator*=(const Vector& Other)
	{
		X *= Other.X;
		Y *= Other.Y;
		return *this;
	}
	friend inline Vector operator*(Vector A, Vector B)
	{
		return A *= B;
	}

	inline Vector operator/=(float Scalar)
	{
		float Denom = Scalar ? (1.0f / Scalar) : (1.0f / 0.000001f);
		return *this *= Denom;
	}
	friend inline Vector operator/(Vector A, float Scalar)
	{
		return A /= Scalar;
	}
	
	inline Vector operator/=(const Vector& Other)
	{
		X = Other.X ? (X / Other.X) : (1.0f / 0.000001f);
		Y = Other.Y ? (Y / Other.Y) : (1.0f / 0.000001f);
		return *this;
	}
	friend inline Vector operator/(Vector A, Vector B)
	{
		return A /= B;
	}
	

	
	inline float LengthSquared()
	{
		return X * X + Y * Y;
	}
	
	inline float Length()
	{
		return sqrt(LengthSquared());
	}
	
	/** Safe normal */
	inline Vector Normal()
	{
		float Len = Length();
		
		// make sure we can divide
		if (Len == 0.0f)
		{
			return Vector(0.0f, 0.0f);
		}
		
		return *this / Len;
	}
	
	inline float Dot(const Vector& Other)
	{
		return X * Other.X + Y * Other.Y;
	}
};


struct WColor
{
	WColor(float _R, float _G, float _B, float _A)
			: R(_R), G(_G), B(_B), A(_A)
	{ }
	WColor()
			: R(0), G(0), B(0), A(0)
	{ }

	float R, G, B, A;
	
	static WColor Black;
	static WColor White;
};

