#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModuleDataReceiverProtocol.h"

@interface __REPLACE_MODULE_NAME__ViewController : UIViewController <ModuleDataReceiverProtocol>
{
    NSArray *array;
}

@property(nonatomic,copy) NSArray *array;

- (void)setParams:(NSMutableDictionary *)inputParams;

@end