#import "RootViewController.h"
#import "ModuleDataReceiverProtocol.h"
#import "TBXML.h"
#import "appConfig.h"

@interface MODULE_VIEW_CONTROLLER : UIViewController <ModuleDataReceiverProtocol>
+ (void)parseXML:(NSValue *)xmlElement withParams:(NSMutableDictionary *)paramsOut;
@end

@implementation RootViewController

- (id)createModuleViewControllerWithParent:(UIViewController *)parent
{
    MODULE_VIEW_CONTROLLER *viewController = [[[MODULE_VIEW_CONTROLLER alloc] init] autorelease];
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

    [viewController setModuleName:[params objectForKey:@"title"]];

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

@end
