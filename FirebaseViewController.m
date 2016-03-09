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
@implementation FirebaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get a reference to our posts
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts"];
    // Attach a block to read the data at our posts reference
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
       // NSLog(@"%@", snapshot.value);
        fireData = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
        [self.tableView reloadData];

    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
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
    NSArray *values = [fireData allValues];
    //NSString *value = [fireData object];
    //cell.textLabel.text =[d valueForKey:@"callName"];
    
    cell.textLabel.text=[[values objectAtIndex:indexPath.row] valueForKey:@"author"];
    cell.detailTextLabel.text=[[values objectAtIndex:indexPath.row] valueForKey:@"title"];

   // NSLog(@"%@ ",values);
    return cell;
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
