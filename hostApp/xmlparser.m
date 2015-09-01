#import "xmlparser.h"

#define XML_TAG_DATA      @"data"
#define XML_TAG_TITLE     @"title"
#define XML_TAG_CONTENT   @"content"
#define XML_TAG_URL       @"url"

@implementation TXMLParser

@synthesize entries;

- (BOOL)parse
{
  [super setDelegate:self];
  parserState = ST_NULL;
  entries = [NSMutableArray array];
  return [super parse];
}

/////////////////////////////////////////////////////////////////////////////////
/// XML parser delegates
/////////////////////////////////////////////////////////////////////////////////

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
  if (parserState == ST_NULL && [[elementName lowercaseString] isEqualToString:XML_TAG_DATA])
  {
    /// data found
    parserState = ST_DATA;
  } else if (parserState == ST_DATA && [[elementName lowercaseString] isEqualToString:XML_TAG_TITLE])
  {
    parserState = ST_TITLE;
    tagString = nil;
    tagString = [NSMutableString string]; 
  } else if (parserState == ST_DATA && [[elementName lowercaseString] isEqualToString:XML_TAG_CONTENT])
  {
    parserState = ST_CONTENT;
    tagString = nil;
    tagString = [NSMutableString string]; 
  } else if (parserState == ST_DATA && [[elementName lowercaseString] isEqualToString:XML_TAG_URL])
  {
      parserState = ST_URL;
      tagString = nil;
      tagString = [NSMutableString string]; 
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
  if (parserState == ST_TITLE || parserState == ST_CONTENT || parserState == ST_URL)
    [tagString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
  if (parserState == ST_TITLE && [[elementName lowercaseString] isEqualToString:XML_TAG_TITLE])
  {
    parserState = ST_DATA;
    [entries addObject:[NSDictionary dictionaryWithObjectsAndKeys:tagString,XML_TAG_TITLE, nil]];
  } else if (parserState == ST_CONTENT && [[elementName lowercaseString] isEqualToString:XML_TAG_CONTENT])
  {
    parserState = ST_DATA;
    [entries addObject:[NSDictionary dictionaryWithObjectsAndKeys:tagString,XML_TAG_CONTENT, nil]];
  } else if (parserState == ST_URL && [[elementName lowercaseString] isEqualToString:XML_TAG_URL])
  {
      parserState = ST_DATA;
      [entries addObject:[NSDictionary dictionaryWithObjectsAndKeys:tagString,XML_TAG_URL, nil]];
  } else if (parserState == ST_DATA && [[elementName lowercaseString] isEqualToString:XML_TAG_DATA]) 
  {
    parserState = ST_NULL;
  }
}

@end