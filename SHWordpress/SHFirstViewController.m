//
//  SHFirstViewController.m
//  SHWordpress
//
//  Created by Seraphin Hochart on 2013-02-01.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "SHFirstViewController.h"
#import "SHDetailViewController.h"

@interface SHFirstViewController ()
    @property (nonatomic, weak) IBOutlet UITableView *tv_table;
@end

@implementation SHFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // BOOM. DONE.
    a_posts = [SHWordpress getPosts];
}


#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [a_posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        //Set Up Basic UITableView Styling
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor lightGrayColor]];
        [cell setSelectedBackgroundView:bgColorView];
    }

    SHPost *sh_post = [a_posts objectAtIndex:indexPath.row];
    cell.textLabel.text = sh_post.title;
    cell.detailTextLabel.text = sh_post.excerpt;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tv_table indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        SHDetailViewController *sh_detail = [segue destinationViewController];
        SHPost *sh_post = [a_posts objectAtIndex:indexPath.row];
        
        // Push Content
        sh_detail.s_content = sh_post.content;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
