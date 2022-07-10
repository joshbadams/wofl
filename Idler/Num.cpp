#include "Num.h"


//static uint32_t UnitThreshold = 5;
static uint64_t Threshold = 1000ull * 1000 * 1000 * 1000 * 1000;
static uint64_t MaxValue = Threshold * 1000;

static uint32_t MaxScale = (int)(0xFFFFFFFFFFFFFFFFull / MaxValue);
static uint64_t MaximizeLimit = 0xFFFFFFFFFFFFFFFFull / 1000;


uint64_t SCALE_UP(uint64_t Val, int Units, int Target)
{
	for(int i=0;i<Target-Units;i++)
	{
		Val /= 1000;
	}
	return Val;
}

static int MatchUnits(const Num& InA, const Num& InB, Num& A, Num& B)
{
	if (InA.Units == InB.Units)
	{
		A = InA;
		B = InB;
		return InA.Units;
	}
	else if (InA.Units > InB.Units)
	{
		A = InA;
		B.Units = InA.Units;
		B.Value = SCALE_UP(InB.Value, InB.Units, InA.Units);
		return InA.Units;
	}
	else
	{
		B = InB;
		A.Units = InB.Units;
		A.Value = SCALE_UP(InA.Value, InA.Units, InB.Units);
		return InB.Units;
	}
}

#define Operator_Match() \
	Num A, B; \
	int Units = MatchUnits(*this, Other, A, B); \
	(void)Units;


Num::Num(uint64_t Int)
	: Units(0)
{
	Value = Int;
	
//	Normalize();
}

Num::Num(int Int)
	: Units(0)
{
	assert(Int >= 0);
	Value = Int;
	
//	Normalize();
}

Num::Num(uint64_t InValue, int InUnits)
	: Value(InValue)
	, Units(InUnits)
{
//	Normalize();
}

Num& Num::Normalize()
{
	while (Value > MaxValue)
	{
		Value /= 1000;
		Units++;
	}
	
	while (Value < Threshold)
	{
		Value *= 1000;
		Units--;
	}
	return *this;
}

void Num::Maximize()
{
	if (Value > 0)
	{
		while (Value * 1000 < MaximizeLimit)
		{
			Value *= 1000;
			Units--;
		}
	}
}


Num Num::operator+(Num Other) const
{
	Operator_Match();
	return Num(A.Value + B.Value, Units).Normalize();
	
//	Num New;
//	if (Other.Units == Units)
//	{
//		New.Units = Units;
//		New.Value = Value + Other.Value;
//	}
//	else if (Other.Units > Units)
//	{
//		if (Other.Units - Units > UnitThreshold)
//		{
//			return Other;
//		}
//
//		New.Units = Other.Units;
//		New.Value = Other.Value + SCALE_UP(Value, Units, Other.Units);
//	}
//	else
//	{
//		if (Units - Other.Units > UnitThreshold)
//		{
//			return *this;
//		}
//
//		New.Units = Units;
//		New.Value = Value + SCALE_UP(Other.Value, Other.Units, Units);
//	}
//
//	New.Normalize();
//	return New;
}

Num Num::operator+(int Other) const
{
	if (Other < 0)
	{
		return *this - Num(-Other);
	}
	
	return *this + Num(Other);
}

Num Num::operator-(Num Other) const
{
	Operator_Match();
	return A.Value > B.Value ? Num(A.Value - B.Value, Units).Normalize() : Num(0);
}


Num Num::operator*(Num Other) const
{
	Num New = *this;

	New.Normalize();
	Other.Normalize();
	
	New.Value *= Other.Value;
	New.Units += Other.Units;
	New.Normalize();
	
	return New;
}

Num Num::operator*(int Scale) const
{
	Num New;
	
	if (Scale < MaxScale)
	{
		New.Value = Value * Scale;
		New.Units = Units;
		return New.Normalize();
	}

	return *this * Num(Scale);
}

Num Num::operator*(double Scale) const
{
	Num New = *this;
	while (Scale > MaxScale)
	{
		New.Value *= MaxScale;
		Scale /= (MaxScale);
		New.Normalize();
	}
	New.Value *= Scale;
	New.Normalize();
	return New;
}

Num Num::operator/(Num Other) const
{
	Operator_Match();
	
	// if the divisor is greater than this, then the result is > 1, which means we just go to 0
	if (B.Value > A.Value)
	{
		return 0;
	}

	return Num(A.Value / B.Value, Units).Normalize();
}

Num Num::operator/(int Factor) const
{
	Num New = *this;
	New.Maximize();
	New.Value /= Factor;
	New.Normalize();
	
	return New;
}

Num Num::operator/(double Factor) const
{
	// turn divide by fractional into a multiply
	if (Factor >= 1.0f && Factor <= 1.0f)
	{
		return *this * 1.0 / Factor;
	}
	
	Num New = *this;
	while (Factor > MaxScale)
	{
		Factor /= MaxScale;
		New.Units--;
	}
	
	New.Value /= Factor;
	New.Normalize();
	return New;
}

double Num::Ratio(Num Other) const
{
	Operator_Match();
	return (double)A.Value / (double)B.Value;
}

bool Num::operator<(Num Other) const
{
	Operator_Match();
	return A.Units < B.Units || (A.Units == B.Units && A.Value < B.Value);
	
}

bool Num::operator>(Num Other) const
{
	Operator_Match();
	return A.Units > B.Units || (A.Units == B.Units && A.Value > B.Value);
}

bool Num::operator==(Num Other) const
{
	Operator_Match();
	return A.Units == B.Units && (A.Value == B.Value);
}



bool Num::ToInt(uint64_t& Out) const
{
	Num Max = *this;
	Max.Maximize();
	
	// if we have units leftover after maximizing, we can't represent as an int
	if (Units > 0)
	{
		Out = 0;
		return false;
	}

	Out = Value * pow(1000, Units);
	return true;
}

void Num::Print() const
{
	printf("%s\n", ToString().c_str());
}

string Num::ToString() const
{
	uint64_t Div = Threshold;
	char u1 = 0;
	char u2 = 0;
	
	uint64_t IntValue;
	// special formatting for units < aa
	if (ToInt(IntValue) && IntValue < 1000000000000000ull)
	{
		if (IntValue < 1000)
		{
			char Buf[20];
			snprintf(Buf, 19, "%d", (int)IntValue);
			return Buf;
		}
		else if (IntValue < 1000000)
		{
			Div = 1000;
			u1 = 'k';
		}
		else if (IntValue < 1000000000)
		{
			Div = 1000 * 1000;
			u1 = 'm';
		}
		else if (IntValue < 1000000000000ull)
		{
			Div = 1000 * 1000 * 1000;
			u1 = 'b';
		}
		else
		{
			Div = 1000ull * 1000 * 1000 * 1000;
			u1 = 't';
		}
	}
	else
	{
		Num Temp = *this;
		Temp.Normalize();
		Div = Threshold;
		u1 = u2 = 'a' + Temp.Units;
		IntValue = Temp.Value * pow(1000, Temp.Units);
	}
	
	int Int = (int)(IntValue / Div);
	int Dec;
	if (IntValue == 0 || Div < 1000)
	{
		Dec = (int)IntValue;
	}
	else
	{
		// get the next three decimal digits
		Dec = ((int)((IntValue % Div) / (Div / 1000)));
	}
	
	// [%lld / %d | %lld / %d],  Value, Units, IntValue, Units - (UnitThreshold - UnderUnits),
	char Buf[20];
	snprintf(Buf, 19, "%d.%03d%c%c", Int, Dec, u1, u2);
	return Buf;
}




#if 0


static uint32_t UnitThreshold = 5;
static uint64_t Threshold = 1000ull * 1000 * 1000 * 1000 * 1000;
static uint64_t MaxValue = Threshold * 1000;

static uint32_t MaxScale = (int)(0xFFFFFFFFFFFFFFFFull / MaxValue);
static uint64_t MaximizeLimit = 0xFFFFFFFFFFFFFFFFull / 1000;


uint64_t SCALE_UP(uint64_t Val, int Units, int Target)
{
	for(int i=0;i<Target-Units;i++)
	{
		Val /= 1000;
	}
	return Val;
}

Num::Num(uint64_t Int)
	: Units(0)
{
	Value = Int;
	// small numbers just use base unit
	Units = UnitThreshold;
	
	Normalize();
}

Num& Num::Normalize()
{
	while (Value > MaxValue)
	{
		Value /= 1000;
		Units++;
	}

	// if not under Threshod, UnderUnits is set to the thresholf
	UnderUnits = UnitThreshold;
	
	// figure out what units would be if we went under UnitThreshold
	if (Value < Threshold)
	{
		UnderUnits = 0;
		while (true)
		{
			if (Value < pow(1000, UnderUnits + 1))
			{
				break;
			}
			UnderUnits++;
		}
	}
	return &this;
}

void Num::Maximize()
{
	while (Value * 1000 < MaximizeLimit && Units > 0)
	{
		Value *= 1000;
		Units--;
	}
}


Num Num::operator+(Num Other) const
{
	Num New;
	if (Other.Units == Units)
	{
		New.Units = Units;
		New.Value = Value + Other.Value;
	}
	else if (Other.Units > Units)
	{
		if (Other.Units - Units > UnitThreshold)
		{
			return Other;
		}
		
		New.Units = Other.Units;
		New.Value = Other.Value + SCALE_UP(Value, Units, Other.Units);
	}
	else
	{
		if (Units - Other.Units > UnitThreshold)
		{
			return *this;
		}
		
		New.Units = Units;
		New.Value = Value + SCALE_UP(Other.Value, Other.Units, Units);
	}
	
	New.Normalize();
	return New;
}

Num Num::operator*(Num Other) const
{
	Num New;
	Num A = *this;
	Num B = Other;

	while (A.UnderUnits + B.UnderUnits >= UnitThreshold)
	{
		if (A.UnderUnits > B.UnderUnits ||
			(A.UnderUnits == B.UnderUnits && A.Units > B.Units) ||
			(A.UnderUnits == B.UnderUnits && A.Units == B.Units && A.Value > B.Value))
		{
			A.Value /= 1000;
			A.Units++;
			A.UnderUnits--;
			
		}
		else
		{
			B.Value /= 1000;
			B.Units++;
			B.UnderUnits--;
		}
	}
	
	A.Normalize();
	B.Normalize();
	
	New.Value = A.Value * B.Value;
	New.Units = A.Units + B.Units - UnitThreshold;// - (UnitThreshold - A.UnderUnits) - (UnitThreshold - B.UnderUnits);
	while (New.Value < Threshold)
	{
		New.Value *= 1000;
		New.Units--;
	}
	New.Normalize();
	
	return New;
}

Num Num::operator*(int Scale) const
{
	Num New;
	
	if (Scale < MaxScale)
	{
		New.Value = Value * Scale;
		New.Units = Units;
		while (New.Value > MaxValue)
		{
			New.Value /= 1000;
			New.Units++;
		}
		return New;
	}

	return *this * Num(Scale);
}

Num Num::operator*(double Scale) const
{
	Num New = *this;
	while (Scale > MaxScale)
	{
		New.Value *= MaxScale;
		Scale /= (MaxScale);
		New.Normalize();
	}
	New.Value *= Scale;
	New.Normalize();
	return New;
}

Num Num::operator/(Num Factor) const
{
	Num New = *this;
	
	// get as many digits as possible
	New.Maximize();
	Factor.Maximize();
	
	// if Factor > New, then this is > 1, which means we just go to 0
	if (Factor.Units > New.Units || (Factor.Units == New.Units && Factor.Value > New.Value))
	{
		return 0;
	}

	// at this point Factor must have Units of 0, and we just divide value
	New.Value /= Factor.Value;
	New.Normalize();

	return New;
}

Num Num::operator/(int Factor) const
{
	Num New = *this;
	New.Maximize();
	New.Value /= Factor;
	New.Normalize();
	
	return New;
}

Num Num::operator/(double Factor) const
{
	if (Factor >= 1.0f && Factor <= 1.0f)
	{
		return *this * 1.0 / Factor;
	}
	
	
	while (Factor > MaxScale)
	{
		
	}
}

double Num::Ratio(Num Other) const
{
	
}


bool Num::ToInt(uint64_t& Out) const
{
	if (Units - (UnitThreshold - UnderUnits) <= UnitThreshold)
	{
		Out = Value * pow(1000, Units - UnitThreshold);
		return true;
	}
	Out = 0;
	return false;
}

void Num::Print() const
{
	printf("%s\n", ToString().c_str());
}

string Num::ToString() const
{
	uint64_t Div = Threshold;
	char u1 = 0;
	char u2 = 0;
	
	uint64_t IntValue;
	// special formatting for units < aa
	if (ToInt(IntValue) && IntValue < 1000000000000000ull)
	{
		if (IntValue < 1000)
		{
			char Buf[20];
			snprintf(Buf, 19, "%d", (int)IntValue);
			return Buf;
		}
		else if (IntValue < 1000000)
		{
			Div = 1000;
			u1 = 'k';
		}
		else if (IntValue < 1000000000)
		{
			Div = 1000 * 1000;
			u1 = 'm';
		}
		else if (IntValue < 1000000000000ull)
		{
			Div = 1000 * 1000 * 1000;
			u1 = 'b';
		}
		else
		{
			Div = 1000ull * 1000 * 1000 * 1000;
			u1 = 't';
		}
	}
	else
	{
		Div = Threshold;
		u1 = u2 = 'a' + (Units - (UnitThreshold - UnderUnits)) - 5;
		IntValue = Value * pow(1000, UnitThreshold - UnderUnits);
	}
	
	int Int = (int)(IntValue / Div);
	int Dec;
	if (IntValue == 0 || Div < 1000)
	{
		Dec = (int)IntValue;
	}
	else
	{
		// get the next three decimal digits
		Dec = ((int)((IntValue % Div) / (Div / 1000)));
	}
	
	// [%lld / %d | %lld / %d],  Value, Units, IntValue, Units - (UnitThreshold - UnderUnits),
	char Buf[20];
	snprintf(Buf, 19, "%d.%03d%c%c", Int, Dec, u1, u2);
	return Buf;
}

#endif
