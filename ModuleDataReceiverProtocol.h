#import <Foundation/Foundation.h>

@protocol ModuleDataReceiverProtocol <NSObject>

@required
- (void)setParams:(NSMutableDictionary *)inputParams;

@optional
- (NSString*)getWidgetTitle;

@end
