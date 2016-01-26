#import "ACMAppDelegate.h"
#import "Secrets.h"
#import <CloudMine/CloudMine.h>

@interface ACMAppDelegate ()

@end

@implementation ACMAppDelegate


-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CMAPICredentials *credentials = [CMAPICredentials sharedInstance];
    credentials.appIdentifier = ACMAppIdentifier;
    credentials.appSecret = ACMAppSecret;

    CMUser *currentUser = [CMUser currentUser];
    if (nil == currentUser) {
        [self loadOnboarding];
    } else {
        [self loadDashboard];
    }

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

- (void)loadOnboarding
{
    UIViewController *onboardingVC = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil].instantiateInitialViewController;
    self.window.rootViewController = onboardingVC;
    [self.window makeKeyAndVisible];
}

- (void)loadDashboard
{
    UIViewController *dashboardVC = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil].instantiateInitialViewController;
    self.window.rootViewController = dashboardVC;
    [self.window makeKeyAndVisible];
}

@end
