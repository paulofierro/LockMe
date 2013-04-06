//
//  JHAppDelegate.m
//  LockMe
//
//  Created by Paulo Fierro on 05/04/2013.
//  Copyright (c) 2013 jadehopper. All rights reserved.
//

#import "JHAppDelegate.h"
#include <dlfcn.h>

@implementation JHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
	
	// Get a reference to the private framework where the screen locking function resides
	char *framework = "/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices";
	void *handle	= dlopen(framework, RTLD_NOW);
	if (handle)
	{
		// Get the symbol address for the screen locking function
		void (*GSEventLockDevice)() = dlsym(handle, "GSEventLockDevice");
		if (GSEventLockDevice)
		{
			// Lock the screen
			GSEventLockDevice();
		}
		dlclose(handle);
	}
	// Once the screen is locked, we quit because otherwise unlocking
	// the screen would bring us back to the app, which would lock the screen...
	exit(0);
    return YES;
}

@end