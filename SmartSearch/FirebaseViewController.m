//
//  FirebaseViewController.m
//  SmartSearch
//
//  Created by Appmonkeyz on 3/9/16.
//  Copyright © 2016 Appmonkeyz. All rights reserved.
//

#import "FirebaseViewController.h"
#import <Firebase/Firebase.h>


@interface FirebaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
NSMutableDictionary *fireData;
NSArray *values;
NSArray *keys;

NSString *usersURL;
NSString *removeValueURL;

@implementation FirebaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    usersURL = [NSString stringWithFormat:@"https://firetestapp123.firebaseio.com/users"];
    // Get a reference to our posts
    Firebase *ref = [[Firebase alloc] initWithUrl: usersURL];
    
    
    // Attach a block to read the data at our posts reference
    
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        fireData = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
        
        values = [fireData allValues];
        keys = [fireData allKeys];
        [self.tableView reloadData];

    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    
    [ref observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"The updated name is %@", snapshot.key);
        
        [fireData setObject:snapshot.value forKey:snapshot.key];
        //fireData = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
        
        values = [fireData allValues];
        keys = [fireData allKeys];
        [self.tableView reloadData];
    }];
    
    [ref  observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"The blog post titled %@ has been deleted", snapshot.value[@"full_name"]);
        //fireData = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
        [fireData removeObjectForKey:snapshot.key];
        
        values = [fireData allValues];
        keys = [fireData allKeys];
        [self.tableView reloadData];
    }];
    
    
    

    // Do any additional setup after loading the view.
}
- (IBAction)btnReload:(id)sender {
    [self.tableView reloadData];

}


#pragma mark - UITableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%lu",(unsigned long)fireData.count);
    return fireData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //NSLog(@"aaaaaa%@",values);
    //NSLog(@"aaaaaa%@",fireData);

    //NSString *value = [fireData object];
    //cell.textLabel.text =[d valueForKey:@"callName"];
    
    cell.textLabel.text=[[values objectAtIndex:indexPath.row] valueForKey:@"date_of_birth"];
    cell.detailTextLabel.text=[[values objectAtIndex:indexPath.row] valueForKey:@"full_name"];

   // NSLog(@"%@ ",values);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Test"
                                          message:@"lol"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.text = [[values objectAtIndex:indexPath.row] valueForKey:@"full_name"];
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.text = [[values objectAtIndex:indexPath.row] valueForKey:@"date_of_birth"];
     }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *name = alertController.textFields.firstObject;
                                   UITextField *dob = alertController.textFields.lastObject;
                                   
                                   //alertController.textFields.firstObject.text = [[values objectAtIndex:indexPath.row] valueForKey:@"full_name"];
                                   //alertController.textFields.lastObject.text = [[values objectAtIndex:indexPath.row] valueForKey:@"date_of_birth"];
                                   
                                   
                                   removeValueURL = [NSString stringWithFormat:@"%@/%@",usersURL,[keys objectAtIndex:indexPath.row]];
                                   Firebase *remove = [[Firebase alloc] initWithUrl: removeValueURL];
                                   NSDictionary *newValues = @{
                                                              @"full_name": name.text,
                                                              @"date_of_birth": dob.text
                                                              };
                                   
                                   [remove updateChildValues: newValues];
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    removeValueURL = [NSString stringWithFormat:@"%@/%@",usersURL,[keys objectAtIndex:indexPath.row]];
    
    NSLog(@"remove url : %@",removeValueURL);
    Firebase *remove = [[Firebase alloc] initWithUrl: removeValueURL];
    [remove removeValue];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
