//
//  Utils.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

class Utils
{
public:
	
	static class WoflFile* File;
	static class WoflInput* Input;
	static class WoflPlatform* Platform;
};

// now that the Utils class is defined, we can include the classes it uses that may use it
#include WOFL_INC(File)
#include WOFL_INC(Input)
#include WOFL_INC(Platform)



#define ARRAY_COUNT(x) (sizeof(x) / sizeof(x[0]))
#define GLCHECK(x) x; { GLenum E = glGetError(); if (E) printf("Error %d with '%s'\n", E, #x); }


template<typename E>
struct enable_bitmask_operators{
	static constexpr bool enable=false;
};

template<typename E>
typename std::enable_if<enable_bitmask_operators<E>::enable,E>::type
operator|(E lhs,E rhs)
{
  typedef typename std::underlying_type<E>::type underlying;
  return static_cast<E>(static_cast<underlying>(lhs) | static_cast<underlying>(rhs));
}

template<typename E>
typename std::enable_if<enable_bitmask_operators<E>::enable,E>::type
operator|=(E& lhs,E rhs)
{
  typedef typename std::underlying_type<E>::type underlying;
  lhs = static_cast<E>(static_cast<underlying>(lhs) | static_cast<underlying>(rhs));
  return lhs;
}

template<typename E>
typename std::enable_if<enable_bitmask_operators<E>::enable,E>::type
operator&(E lhs,E rhs)
{
  typedef typename std::underlying_type<E>::type underlying;
  return static_cast<E>(static_cast<underlying>(lhs) & static_cast<underlying>(rhs));
}

#define ENABLE_ENUM_OPS(x) template<> struct enable_bitmask_operators<x>{ static constexpr bool enable=true; };

