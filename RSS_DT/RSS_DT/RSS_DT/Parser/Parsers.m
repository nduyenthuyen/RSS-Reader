
#import "Parsers.h"
@implementation Parsers

-(id) initWithRssUrl:(NSString*) rssURl controller:(MasterViewController*) controller databaseMn:(Dao*) dbManager
{
    if(self = [super init])
    {
        _rssUrl = rssURl;
        _controller = controller;
        self.dbManager = dbManager;
    }
    return self;
}

-(void) processLink
{
    NSURL *url = [NSURL URLWithString:_rssUrl];
    _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [_parser setDelegate:self];
    [_parser setShouldResolveExternalEntities:NO];
    [_parser parse];
}
//loop until facing element item
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    _element = elementName;
    
    if ([_element isEqualToString:@"item"]) {
        _entity  = [[RSSEntity alloc] init];
    }
    
}
//push data appropriate with entity contents
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([_element isEqualToString:@"title"]) {
        [_entity setArticleTitle:string];
    } else if ([_element isEqualToString:@"link"]) {
        [_entity setArticleUrl:string];
    } else if ([_element isEqualToString:@"description"]) {
        [_entity setSrcImage:string];
    } else if ([_element isEqualToString:@"pubDate"]) {
        [_entity setArticleDate:string];
    }
}
// out item block:  push entity into controller and database and also save html page in device local
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [_entity changeSrcImage:[self getSrcURL:[_entity srcImage]]];
        [_entity changeArticleUrl:[self getSrcURL:[_entity articleUrl]]];
        
        [self saveEntityIntoDB:_entity];
        [_controller  addNewEntityInToAllEntities:_entity];
        [self saveHtmlPage:[_entity articleUrl]];
        
        [_entity release];
        _entity = nil;

    }
    
}



//this method use to get src link of images from Description element
-(NSString*) getSrcURL:(NSString*) src
{
    NSString *srcImage = src;
    //get string after "src="
    NSRange rangeSrc =  [src rangeOfString:@"src="];
    if(rangeSrc.length!=0)
    {
        srcImage = [srcImage substringFromIndex:rangeSrc.location + rangeSrc.length];
    }
    //remove any character before http
    NSRange rangehttp =  [srcImage rangeOfString:@"http"];
    srcImage = [srcImage substringFromIndex:rangehttp.location];
    
    //take string in block src end with character '>'
    NSRange rangeEnd =  [srcImage rangeOfString:@">"];
    if(rangeEnd.length!=0)
    {
        srcImage = [srcImage substringWithRange:NSMakeRange(0, rangeEnd.location)];
    }
    //remove any character after "png"
    NSRange rangePng =  [srcImage rangeOfString:@".png"];
    if(rangePng.length!=0)
    {
        srcImage = [srcImage substringWithRange:NSMakeRange(0, rangePng.location + rangePng.length)];
    }
    //remove any character after "jpg"
    NSRange rangeJpg =  [srcImage rangeOfString:@".jpg"];
    if(rangeJpg.length!=0)
    {
        srcImage = [srcImage substringWithRange:NSMakeRange(0, rangeJpg.location + rangeJpg.length)];
    }
    //remove any character after "html"
    NSRange rangeHtml =  [srcImage rangeOfString:@".html"];
    if(rangeHtml.length!=0)
    {
        srcImage = [srcImage substringWithRange:NSMakeRange(0, rangeHtml.location + rangeHtml.length)];
    }
    return srcImage;
}


/*
 *  schema of table CREATE TABLE rssEntity(rssEntityID integer primary key, articleUrl text, articleTitle text, srcImage text, articleDate text)
 */
-(void)saveEntityIntoDB:(RSSEntity*) entity {

    NSString *query = [NSString stringWithFormat:@"insert into rssEntity values(null, '%@', '%@', '%@', '%@')",entity.articleUrl, entity.articleTitle, entity.srcImage ,entity.articleDate];
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

/*
 *   save html page in local deive to read office
 */
-(void)saveHtmlPage:(NSString*) url{
    NSURL *urlHtml = [NSURL URLWithString:url];
    
    // Determile cache file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"<>:/\?*"];
    NSString *fileName= [[url componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],fileName];
    
    // Download and write to file
    NSData *urlData = [NSData dataWithContentsOfURL:urlHtml];
    [urlData writeToFile:filePath atomically:YES];
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [_controller reloadTableView];
    
}

- (void)dealloc {
    [_parser release];
    _parser = nil;
    [_entity release];
    _entity = nil;
    [super dealloc];
}

@end
