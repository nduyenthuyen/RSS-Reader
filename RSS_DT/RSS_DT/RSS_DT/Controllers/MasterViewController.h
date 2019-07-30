
#import <UIKit/UIKit.h>
#import "RSSEntity.h"
#import "DetailViewController.h"
#import "Dao.h"
@interface MasterViewController : UITableViewController
{
    NSMutableArray *_allEntities;
}
@property (retain) NSMutableArray *allEntities;
-(void) addNewEntityInToAllEntities:(RSSEntity*) entity;
-(void) reloadTableView;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (retain) Dao *dbManager;

@end

