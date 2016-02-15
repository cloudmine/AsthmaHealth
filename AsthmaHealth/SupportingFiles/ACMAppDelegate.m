#import "ACMAppDelegate.h"
#import <CMHealth/CMHealth.h>
#import "Secrets.h"

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
    [CMHealth setAppIdentifier:ACMAppIdentifier appSecret:ACMAppSecret];

    if ([CMHUser currentUser].isLoggedIn) {
        NSLog(@"Logged in as %@", [CMHUser currentUser].userData.email);
        [self loadMainPanel];
    } else {
        [self loadOnboarding];
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

- (void)loadMainPanel
{
    UIViewController *mainPanelVC = [UIStoryboard storyboardWithName:@"MainPanel" bundle:nil].instantiateInitialViewController;
    self.window.rootViewController = mainPanelVC;
    [self.window makeKeyAndVisible];
}

@end
