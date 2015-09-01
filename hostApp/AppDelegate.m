#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    RootViewController *viewController = [[RootViewController alloc] init];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    [viewController release];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end