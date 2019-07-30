
#import <Foundation/Foundation.h>
/*
 *
 *    Database manager with SQLite database
 *
 */@interface Dao : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;
-(void)deleAllDataFromTable:(NSString *)query;
@end
