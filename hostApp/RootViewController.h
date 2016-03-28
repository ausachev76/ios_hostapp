#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
    UIButton *_button;
    NSMutableDictionary *params;
}

// TODO: Method copied from iphpluginmanager.m of ios_core in appBuilder project
+(UIViewController *)controllerWithType:(NSString *)type
                               moduleID:(NSString *)moduleID;

// TODO: Method copied from iphpluginmanager.m of ios_core in appBuilder project
+(UIViewController *)createViewControllerWithName:(NSString *)moduleName_
                                          nibName:(NSString *)nibName_
                                           bundle:(NSString *)bundleName_;

@end
