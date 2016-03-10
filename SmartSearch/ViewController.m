//
//  ViewController.m
//  SmartSearch
//
//  Created by Appmonkeyz on 3/9/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataStack.h"
#import "School.h"
#import <Firebase/Firebase.h>


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end
NSMutableArray *schoolListArray;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSchoolList];
    [self.tableView reloadData];
    
    // Get a reference to our posts
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts"];
    // Attach a block to read the data at our posts reference
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnFirebase:(id)sender {
    [self performSegueWithIdentifier:@"FIREBASE" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSave:(id)sender {
    CoreDataStack *defaultStack = [CoreDataStack defaultCoreDataStack];
        // Add new school
    School *school = [NSEntityDescription insertNewObjectForEntityForName:@"School" inManagedObjectContext:defaultStack.managedObjectContext];
    
    [school setName:self.txtName.text];
    [school setAddress:self.txtAddress.text];
    [defaultStack saveContext];
    [self fetchSchoolList];
    [self.tableView reloadData];

}

- (void)fetchSchoolList {
    
    NSError *error;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"School"];
    
    //schoolListArray = [NSMutableArray arrayWithArray:[[[CoreDataStack defaultCoreDataStack] managedObjectContext] executeFetchRequest:fetchRequest error:&error]];
    
    schoolListArray = [NSMutableArray arrayWithArray:[[[CoreDataStack defaultCoreDataStack] managedObjectContext] executeFetchRequest:fetchRequest error:&error]];
    
    //NSLog(@"%@",schoolListArray);
}

#pragma mark - hide keyboard

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark - UITableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%lu",(unsigned long)schoolListArray.count);
    return schoolListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    School *school = [schoolListArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[school name];
    cell.detailTextLabel.text=[school address];
    
    //NSLog(@"%@ ",[school name]);
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        School *school = [schoolListArray objectAtIndex:indexPath.row];
        
        [schoolListArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[[CoreDataStack defaultCoreDataStack] managedObjectContext] deleteObject:school];
        [[CoreDataStack defaultCoreDataStack] saveContext];
    }
}



@end
