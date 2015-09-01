#import <Foundation/Foundation.h>

@interface TXMLParser : NSXMLParser <NSXMLParserDelegate>
{
@private enum
    {
        ST_NULL = 0,
        ST_DATA,
        ST_TITLE,
        ST_CONTENT,
        ST_URL,
    } parserState;
    
@private NSMutableString *tagString;
    NSMutableArray *entries;
}

@property (nonatomic, retain) NSMutableArray *entries;

@end