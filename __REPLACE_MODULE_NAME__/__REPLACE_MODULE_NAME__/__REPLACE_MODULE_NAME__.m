#import "__REPLACE_MODULE_NAME__.h"

@implementation __REPLACE_MODULE_NAME__ViewController
@synthesize array;

- (void)viewDidLoad
{
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    /// show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    /// set module title in navigation bar
    [self.navigationItem setTitle:@"Example Module"];
    
    /// set background for view to black
    self.view.backgroundColor = [UIColor grayColor];
    
    /// set logo from resources
    UIImage *logoImage = [UIImage imageNamed:@"__REPLACE_MODULE_NAME__logo_small.png"];
    CGRect logoImageViewRect = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width - [logoImage size].width) / 2.f,
                                           10.0f,
                                           [logoImage size].width,
                                           [logoImage size].height);
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:logoImageViewRect]; 
    logoImageView.image = logoImage;
    [self.view addSubview:logoImageView];
    
    /// create WebView to store data from config
    CGRect viewFrame = CGRectMake(0.0f,
                                  [logoImage size].height + 20,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - [logoImage size].height);
  
    UIWebView *webView = [[UIWebView alloc] initWithFrame:viewFrame];
    [webView setBackgroundColor:[UIColor grayColor]];
    
    /// access to user configuration data via NSUserDefaults key-value database
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *content = [[NSMutableString alloc] init];
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// To get access to the user data we must get and handle NSArray *array from NSMutableDictionary *params.
    /// The user data stored as array of objects.
    /// Each object in the array is NSDictionary object:
    ///
    /// NSArray(NSDictionary(...),
    ///         NSDictionary(...),
    ///         NSDictionary(...),
    ///         ...,
    ///         nil)
    /// 
    /// User part of xml configuration file could be look like this:
    /// 
    ///  <data>
    ///    <title>Services</title>
    ///    <content>
    ///      some text data 1
    ///    </content>
    ///    <content>
    ///      some text data 2
    ///    </content>
    ///    ...
    ///  </data>
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    //NSArray *array = [userDefaults objectForKey:@"__REPLACE_MODULE_NAME__"];
    
    /// if this data actualy was stored here we get access to user data
    if (array)
    {
        for(NSDictionary *dictionary in array)
        {
            id obj = nil;

            /// set module title in navigation bar
            if ((obj = [dictionary objectForKey:@"title"]) != nil) [self.navigationItem setTitle:obj];

            if ((obj = [dictionary objectForKey:@"content"]) != nil) [content appendString:obj];
        }
    } else {
        /// if no config section found for this module - insert default string
        [content appendString:@"<html><head></head><body>hello module</body></html>\n"];
    }
    
    /// loading result string as html content
    [webView loadHTMLString:content baseURL:nil];
    
    /// append webView to the UIViewController's view
    [self.view addSubview:webView];
    
    /// release unused objects
    [logoImageView release];
    [content       release];
    [webView       release];
}

- (void)setParams:(NSMutableDictionary *)inputParams
{
    if (inputParams != nil)
    {             
        array = [inputParams objectForKey:@"data"];
    }
}

@end