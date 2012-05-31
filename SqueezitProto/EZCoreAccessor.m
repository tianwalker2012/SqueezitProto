//
//  EZCoreAccessor.m
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZCoreAccessor.h"
#import "Constants.h"

@interface EZCoreAccessor(private)

- (NSManagedObjectContext*) createContext:(NSPersistentStoreCoordinator*)coordinator;

- (NSManagedObjectModel*) createModel:(NSURL*)modelURL;

- (NSPersistentStoreCoordinator*) createCoordinator:(NSURL*)storeURL model:(NSManagedObjectModel*)model;

@end


@implementation EZCoreAccessor
@synthesize model, context, coordinator;

+ (EZCoreAccessor*) getInstance
{
    static EZCoreAccessor* accessor = nil;
    //EZAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    if(accessor == nil){
        accessor = [[EZCoreAccessor alloc] initWithDBName:CoreDBName modelName:CoreModelName];
    }
    return accessor; 
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (id) initWithDBName:(NSString*)dbName modelName:(NSString*)modelName
{
    self = [super init];
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL* dbURL = [[EZCoreAccessor applicationDocumentsDirectory] URLByAppendingPathComponent:dbName];
    self.coordinator = [self createCoordinator:dbURL model:self.model];
    self.context = [self createContext:coordinator];
    return self;
}

+ (void) cleanDefaultDB
{
    [EZCoreAccessor cleanDB:CoreDBName];
}

+ (void) cleanDB:(NSString*)fileName
{
    
    NSURL *storeURL = [[EZCoreAccessor applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}

- (NSManagedObjectContext*) createContext:(NSPersistentStoreCoordinator*)coord
{
    NSManagedObjectContext* res = [[NSManagedObjectContext alloc] init];
    [res setPersistentStoreCoordinator:coord];
    return res;
}


- (NSPersistentStoreCoordinator*) createCoordinator:(NSURL*)storeURL model:(NSManagedObjectModel *)mod
{
    NSError* error = nil;
    NSPersistentStoreCoordinator* res = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mod];
    if(![res addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        EZDEBUG(@"Failed to initialize database, error:%@, userinfo:%@", error, error.userInfo);
        //TODO call cleanData() for possible fix
        abort();
    }
    return res;
}

- (void)saveContext
{
    NSError *error = nil;
    //NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            EZDEBUG(@"Unresolved error %@, userInfo:%@", error, [error userInfo]);
            abort();
    }
}

//All NSManagedObject should be instantiated from here
- (NSManagedObject*) create:(Class)classType
{
    NSString* className = [classType description];
    NSManagedObject* res = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:context];
    return res;
    
}

//po for persistent object
- (BOOL) store:(NSManagedObject*)po
{
    NSError* error = nil;
    BOOL res = false;
    res = [po.managedObjectContext save:&error];
    if(!res){
        EZDEBUG(@"Error at save, error:%@, userinfo:%@",error, error.userInfo);
    }
    return res;
}

//Will remove it from storage
- (BOOL) remove:(NSManagedObject*)po
{
    [po.managedObjectContext deleteObject:po];
    return TRUE;
}

//If passing nil, System will use "name" to sort the result.
- (NSArray*) fetchAll:(Class)classType sortField:(NSString*)fieldName
{
    EZDEBUG(@"Fetch %@, sortField:%@",classType, fieldName);
    NSString* sortField = fieldName?fieldName:@"name";
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[classType description]];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortField ascending:YES];
    NSArray* descriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:descriptors];
    NSFetchedResultsController* fetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:CoreFetchResultCache];
    NSError* error = nil;
    if(![fetcher performFetch:&error]){
        EZDEBUG(@"Error fetch %@, sortField:%@, error:%@, userinfo:%@",classType,sortField,error,error.userInfo);
    }
    return fetcher.fetchedObjects;
}

@end
