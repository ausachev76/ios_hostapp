#import "RootViewController.h"
#import "ModuleDataReceiverProtocol.h"
#import "TBXML.h"
#import "appConfig.h"

#import "iphviewcontrollerlist.h"
#import "auth_Share.h"
#import "appbuilderappconfig.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MODULE_VIEW_CONTROLLER : UIViewController <ModuleDataReceiverProtocol>
+ (void)parseXML:(NSValue *)xmlElement withParams:(NSMutableDictionary *)paramsOut;
@end

@implementation RootViewController

- (id)createModuleViewControllerWithParent:(UIViewController *)parent
{
   // MODULE_VIEW_CONTROLLER *viewController = [[[MODULE_VIEW_CONTROLLER alloc] init] autorelease];
   //------
   [params setValue:@"AppTitle" forKey:@"title"];
   [params setValue:@"catalogue" forKey:@"type"];
   [params setValue:@"0" forKey:@"module_id"];
  
   MODULE_VIEW_CONTROLLER *viewController = (MODULE_VIEW_CONTROLLER *)[RootViewController controllerWithType:[params objectForKey:@"type"]
                                                                                                   moduleID:[params objectForKey:@"module_id"]];
   //------
  
    [viewController setParams:params];

    id retActionValue = nil;
    SEL selector = @selector(performAction);
    if ( [viewController respondsToSelector:selector] )
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                     [[viewController class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:viewController];
        [invocation invoke];
        [invocation getReturnValue:&retActionValue];
    } else {
        selector = @selector(performActionWithViewController:);
        if ( [viewController respondsToSelector:selector] )
        {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                         [[viewController class] instanceMethodSignatureForSelector:selector]];
            [invocation setArgument:&parent atIndex:2];
            [invocation setSelector:selector];
            [invocation setTarget:viewController];
            [invocation invoke];
            [invocation getReturnValue:&retActionValue];
            if ( !retActionValue )
                return nil;
        }
    }

    if ( retActionValue )
        return retActionValue;

    // @todo: temporarily commented out to avoid causing the unknown method exception
    //
    // [viewController setModuleName:[params objectForKey:@"title"]];

    return viewController;
}

-(void)buttonClicked:(id)sender
{
    id obj = [self createModuleViewControllerWithParent:self];

    if ( !obj )
        return;

    if ( [obj isKindOfClass:[UIViewController class]] )
    {
        UIViewController *vc = obj;
        [self.navigationController pushViewController:vc animated:YES];
    }
};

- (void)loadModuleParams
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:filePath options: 0 error:&error];

    if (error)
    {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
        return;
    }

    TBXML *tbxml = [TBXML newTBXMLWithXMLData:xmlData error:&error];
    [tbxml autorelease];

    if (error)
    {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
        return;
    }

    TBXMLElement *xmlElement = tbxml.rootXMLElement;
    NSValue *xmlElementWrapper =
      [NSValue valueWithBytes:xmlElement objCType:@encode(TBXMLElement)];

    params = [[NSMutableDictionary alloc] init];
    [MODULE_VIEW_CONTROLLER parseXML:xmlElementWrapper withParams:params];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //----- TODO: Right way for Facebook Session in appHost
    NSString *currentFBAppID = appIBuildAppFacebookAppID();
    [FBSettings setDefaultAppID:currentFBAppID];
    //-----
    [self loadModuleParams];

    self.view.backgroundColor = [UIColor whiteColor];

    /// prepare user interface with single button to load module
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:32];

    [_button setTitle:@"Run Module" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_button addTarget:self
                action:@selector(buttonClicked:)
      forControlEvents:UIControlEventTouchUpInside];

    [_button sizeToFit];
    _button.center = self.view.center;

    [self.view addSubview:_button];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// TODO: Method copied from iphpluginmanager.m of ios_core in appBuilder project
+(UIViewController *)controllerWithType:(NSString *)type
                               moduleID:(NSString *)moduleID
{
  const TIphoneVCdescriptor *vcd = viewControllerByType(type);
  if ( !vcd )
    return nil;
  
  if ( vcd->className )
  {    UIViewController *vc = [self createViewControllerWithName:vcd->className
                                                                         nibName:vcd->nibName
                                                                          bundle:nil];
    //[vc setModuleType:type];
    return vc;
  }
  
  return [self createViewControllerWithName:[moduleID stringByAppendingString:@"ViewController"]
                                                    nibName:nil
                                                     bundle:nil];
}

// TODO: Method copied from iphpluginmanager.m of ios_core in appBuilder project
+(UIViewController *)createViewControllerWithName:(NSString *)moduleName_
                                          nibName:(NSString *)nibName_
                                           bundle:(NSString *)bundleName_
{
  if ( !( moduleName_ &&
         [moduleName_ length] ) )
    return nil;
  
  Class theModuleClass = NSClassFromString( moduleName_ );
  
  if ( !theModuleClass )
    return nil;
  
  if ( [theModuleClass isSubclassOfClass:[UIViewController class]] )
  {
    NSBundle *bundle = nil;
    if ( bundleName_ )
    {
      NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:bundleName_];
      bundle = [NSBundle bundleWithPath:bundlePath];
      if (!bundle)
        NSLog(@"no bundle found at: %@", bundlePath );
    }
    
    return [[[theModuleClass alloc] initWithNibName:nibName_ bundle:bundle] autorelease];
  }
  return nil;
}

@end
