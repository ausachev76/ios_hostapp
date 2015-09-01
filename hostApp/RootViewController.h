#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
    UIButton *_button;
    NSMutableDictionary *params;
}

-(IBAction)_buttonClicked:(id)sender;

@end