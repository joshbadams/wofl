
#pragma once

#include <string>

class Num
{
public:
	uint64_t Value = 0;
	int Units = 0;
	// this is the number of units it would be if we we didn't start at UnitThreshold
	// 0 for 0-999
	// 1 for 1,000-999,999
	// 2 for 1,000,000-999,999,999
	// etc
	int UnderUnits = 0;
	
	Num(uint64_t Int=0);
	Num(int Int);
	Num(uint64_t InValue, int InUnits);
	
	Num operator+(Num Other) const;
	Num operator+(int Other) const;
	Num operator-(Num Other) const;
	Num operator*(Num Other) const;
	Num operator*(int Scale) const;
	Num operator*(double Scale) const;
	
	Num operator/(Num Factor) const;
	Num operator/(int Factor) const;
	Num operator/(double Factor) const;
	double Ratio(Num Other) const;
	
	bool operator<(Num Other) const;
	bool operator<=(Num Other) const;
	bool operator>(Num Other) const;
	bool operator>=(Num Other) const;
	bool operator==(Num Other) const;
	
	bool ToInt(uint64_t& Out) const;
	void Print() const;
	string ToString() const;
	
private:
	Num& Normalize();
	void Maximize();
};

