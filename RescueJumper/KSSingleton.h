//
//  KSSingleton.h
//
//  Created by Florent Morin on 27/03/10.
//  Copyright 2010 Kaeli Soft.
//
//  http://www.kaelisoft.fr
//


/*
 * __ Integration __ (minimal)
 *
 * #import "KSSingleton.h"
 * 
 * @interface MySingleton {
 * ...
 * }
 *
 * KS_SINGLETON_INTERFACE(MySingleton)
 *
 * ...
 *
 * @end
 *
 *
 * @implementation MySingleton
 *
 * KS_SINGLETON_IMPLEMENTATION(MySingleton)
 *
 * ...
 *
 * @end
 *
 */

/*
 * __ Initialization __ (optional)
 *
 * @interface MySingleton {
 * }
 *
 * ...
 *
 * - (void)initialization;
 *
 * @ end
 *
 * @implementation MySingleton
 *
 * - (void)initialization {
 * }
 *
 * @end
 *
 */

/*
 * __ Usage __
 *
 * MySingleton *s = [MySingleton sharedMySingleton];
 *
 */

#define KS_SINGLETON_INTERFACE(singletonclass) \
+ (singletonclass *)shared##singletonclass;

#define KS_SINGLETON_IMPLEMENTATION(singletonclass) \
\
static singletonclass *shared##singletonclass = nil; \
\
+ (singletonclass *)shared##singletonclass { \
@synchronized(self) { \
if (shared##singletonclass == nil) { \
shared##singletonclass = [[super allocWithZone:NULL] init]; \
if ([shared##singletonclass respondsToSelector:@selector(initialization)]) { \
[shared##singletonclass performSelector:@selector(initialization)]; \
} \
} \
} \
\
return shared##singletonclass; \
} \
\
+ (id)allocWithZone:(NSZone *)zone { \
return [[self shared##singletonclass] retain]; \
} \
\
- (id)copyWithZone:(NSZone *)zone { \
return self; \
} \
\
- (id)retain { \
return self; \
} \
\
- (NSUInteger)retainCount { \
return NSUIntegerMax; \
} \
\
- (oneway void)release { \
} \
\
- (id)autorelease { \
return self; \
}
