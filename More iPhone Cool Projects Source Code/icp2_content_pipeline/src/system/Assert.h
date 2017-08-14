//          Copyright (c) Claus Hoefele.  All rights reserved.                //
//==============================================================================

#ifndef SYSTEM_ASSERT_H
#define SYSTEM_ASSERT_H

#include <cassert>

/** Run-time assert. */
#define ASSERT(expression) assert(expression)

/** Run-time assert with message. */
#define ASSERT_M(expression, message, ...) assert(expression)

#endif  // SYSTEM_ASSERT_H
