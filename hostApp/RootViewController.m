#import "RootViewController.h"
#import "xmlparser.h"
#import "ModuleDataReceiverProtocol.h"
#import "TBXML.h"
#import "appConfig.h"

@interface MODULE_VIEW_CONTROLLER : UIViewController
@end

@implementation RootViewController

-(void)buttonClicked:(id)sender
{
    MODULE_VIEW_CONTROLLER *viewController = [[MODULE_VIEW_CONTROLLER alloc] init];
    [((UIViewController<ModuleDataReceiverProtocol> *)viewController) setParams:params];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
};

- (void)viewDidLoad
{
    [super viewDidLoad];

    /// get contents of user configuration xml file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:filePath];
    /// check whether data loaded ?
    if (!xmlData)
    return;

    /// init xml parser
    TXMLParser *parser = [[TXMLParser alloc] initWithData:xmlData];
    /// parse document
    [parser parse];

    /// store parsed data into userdefaults database
    /// NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    /// [defaults setObject:[parser entries] forKey:@"__REPLACE_MODULE_NAME__"];

    /// push all properties to NSMutableDicitionary "params"
    params = [[NSMutableDictionary alloc] init];
    [params setValue:[parser entries] forKey:@"data"];

    [parser release];

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
