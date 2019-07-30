#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RSSEntity.h"
#import "Parsers.h"
#import "CustomCell.h"

@implementation MasterViewController
@synthesize allEntities = _allEntities;

-(void) addNewEntityInToAllEntities:(RSSEntity *)entity
{
    [_allEntities addObject:entity];

}

-(void) reloadTableView
{
    [self.tableView reloadData];

}

//get all data from DB and fill into entity
-(void)loadData{
    NSString *query = @"select * from rssEntity";
    NSArray *dataFromBD = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
     NSInteger indexOfArticleTitle = [self.dbManager.arrColumnNames indexOfObject:@"articleTitle"];
     NSInteger indexOfArticleUrl = [self.dbManager.arrColumnNames indexOfObject:@"articleUrl"];
     NSInteger indexOfSrcImage = [self.dbManager.arrColumnNames indexOfObject:@"srcImage"];
     NSInteger indexOfArticleDate = [self.dbManager.arrColumnNames indexOfObject:@"articleDate"];
    
    for (id myArrayElement in dataFromBD) {
        RSSEntity *runEntity = [[RSSEntity alloc] init];
        
        [runEntity setArticleTitle:[myArrayElement objectAtIndex:indexOfArticleTitle]];
        [runEntity setArticleUrl:[myArrayElement objectAtIndex:indexOfArticleUrl]];
        [runEntity setSrcImage:[myArrayElement objectAtIndex:indexOfSrcImage]];
        [runEntity setArticleDate:[myArrayElement objectAtIndex:indexOfArticleDate]];
        
        [self addNewEntityInToAllEntities:runEntity];
        [runEntity release];
        runEntity = nil;
    }

}

//delete db and files already save
-(void)deleteAll
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"<>:/\?*"];
   
    for (RSSEntity* myArrayElement in _allEntities) {
        NSString *fileName= [[[myArrayElement articleUrl] componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],fileName];
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if(exists){
            NSError *error = [NSError new];
            [manager removeItemAtPath:filePath error:&error];
            [error release];
        }
        
    }

    NSString *query = @"delete from rssEntity";
    [self.dbManager deleAllDataFromTable:query];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *clearDBButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAllDB:)];
    self.navigationItem.leftBarButtonItem = clearDBButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController ];
    self.allEntities = [NSMutableArray array];
    self.dbManager = [[Dao alloc] initWithDatabaseFilename:@"rssDB.sqlite"];
    [self loadData];

}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearAllDB:(id)sender {
    // create a  alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Do you really want to clear all Data?"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

- (void)insertNewObject:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"RSS" message:@"enter your rss link" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *textF = [[alertView textFieldAtIndex:0] text];
    if (buttonIndex == 1) {
        [self deleteAll];
        _allEntities = nil;
        [self reloadTableView];
    } else if([textF length]>0){

        self.allEntities = [NSMutableArray array];
        //example  url https://vnexpress.net/rss/the-thao.rss
        Parsers *parser = [[Parsers alloc] initWithRssUrl:textF  controller:self databaseMn:self.dbManager];
        [parser processLink];
        [parser release];
    }
    
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSEntity *entity = _allEntities[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        
        [controller setUrl:entity.articleUrl];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allEntities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    RSSEntity *entity = [_allEntities objectAtIndex:indexPath.row];

    cell.titleItem.text = entity.articleTitle;
    cell.timeItem.text = entity.articleDate;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithString:entity.srcImage]];
    if(url)
    {
       NSData *data = [NSData dataWithContentsOfURL:url];
        if(data)
       {
           CGSize size = [cell.imageItem bounds].size;
           //format images to fit with cell images
           UIImage *image = [self imageWithImage:[UIImage imageWithData:data] scaledToFillSize:size];
           [cell.imageItem setImage:image];
       }
    }
    
    return cell;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.allEntities removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)dealloc {
    [_allEntities release];
    _allEntities = nil;
    [_dbManager release];
    _dbManager = nil;
    [super dealloc];
}

@end
