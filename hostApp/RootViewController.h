#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
    UIButton *_button;
    NSMutableDictionary *params;
}

-(void)_buttonClicked:(id)sender;

@end