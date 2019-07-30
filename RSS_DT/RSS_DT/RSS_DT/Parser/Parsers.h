/*
*
*    Parsers using for reading content of "http://***.rss" url and write "item" into database
*
*/
#import <Foundation/Foundation.h>
#import "RSSEntity.h"
#import "MasterViewController.h"
#import "Dao.h"
@interface Parsers : NSObject
{
    NSXMLParser *_parser;
    RSSEntity *_entity;
    NSString *_element;
    NSString *_rssUrl;
    MasterViewController *_controller;

}
-(void) processLink;
/*
*    Input param rssUrl: "http://***.rss"
*    Input param controller: MasterViewController which using this parser
*    Input param dbManager: dbManager which is using by this parser to save item into Db
*/
-(id) initWithRssUrl:(NSString*) rssURl controller:(MasterViewController*) controller databaseMn:(Dao*) dbManager;
@property (nonatomic, strong) Dao *dbManager;


@end
