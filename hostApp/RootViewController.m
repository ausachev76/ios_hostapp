#import "RootViewController.h"
#import "ModuleDataReceiverProtocol.h"
#import "TBXML.h"
#import "appConfig.h"

@interface MODULE_VIEW_CONTROLLER : UIViewController <ModuleDataReceiverProtocol>
+ (void)parseXML:(NSValue *)xmlElement withParams:(NSMutableDictionary *)paramsOut;
@end

@implementation RootViewController

-(void)buttonClicked:(id)sender
{
    MODULE_VIEW_CONTROLLER *viewController = [[MODULE_VIEW_CONTROLLER alloc] init];
    [viewController setParams:params];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
};

- (void)loadModuleParams
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
    NSString *xmlData = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    if (error)
    {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
        return;
    }

    TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlData error:&error];
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
