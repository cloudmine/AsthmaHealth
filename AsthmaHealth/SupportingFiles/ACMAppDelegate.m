#import "ACMAppDelegate.h"
#import "Secrets.h"
#import <CloudMine/CloudMine.h>

@interface ACMAppDelegate ()

@end

@implementation ACMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CMAPICredentials *credentials = [CMAPICredentials sharedInstance];
    credentials.appIdentifier = ACMAppIdentifier;
    credentials.appSecret = ACMAppSecret;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
