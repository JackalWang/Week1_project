//
//  MoviesViewController.m
//  RottenFruit
//
//  Created by Jackal Wang on 2015/6/15.
//  Copyright (c) 2015年 Jackal Wang. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "ViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Reachability.h"
#import "MMProgressHUD.h"



@interface MoviesViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *movies;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    NSLog(@"viewDidLoad......");
    [super viewDidLoad];
    
    
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyMovieCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self firstLoadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    

    
    // Do any additional setup after loading the view.
}

- (void)firstLoadData{
    [MMProgressHUD showWithTitle:@"Loading..."];
    [self loadData];
    
    [MMProgressHUD dismissWithSuccess:@"Completed!"];
}

- (void)loadData{
    
    NSString *apiURLString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiURLString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = dict[@"movies"];
        [self.tableView reloadData];
    }];

}

- (void)onRefresh:(id)sender{
    NSLog(@"Refreshing");
    [self.refreshControl endRefreshing];
    [self loadData];
    
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:reachability];
    }
    
    if (reachability == self.wifiReachability)
    {
        [self configureTextField:reachability];
    }
}

- (void)configureTextField:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        
        case NotReachable:        {
            [self generateErrorView];
            NSLog(@"NotReachable.............");
            break;
        }
            
        case ReachableViaWWAN:        {
            [self removeErrorView];
            NSLog(@"ReachableViaWWAN.............");
            break;
        }
        case ReachableViaWiFi:        {
            [self removeErrorView];
            NSLog(@"ReachableViaWiFi.............");
            break;
        }
    }
}

-(void)generateErrorView{
    NSLog(@"ReachableConnection.............");
    
    UIView *netWorkError = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 27)];
    netWorkError.tag = 123;
    [netWorkError setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(107, 3, 107, 21)];
    messageLabel.text = @"Network Error";
    [netWorkError addSubview:messageLabel];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:netWorkError];

}

-(void)removeErrorView{
    UIView *netWorkError = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:123];
    //netWorkError.hidden = YES;
    [netWorkError removeFromSuperview];
    [MMProgressHUD showWithTitle:@"Loading..."];
    [MMProgressHUD dismissWithSuccess:@"Completed!"];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    //NSDictionary *movie = self.movies[indexPath.row];
    //NSString *title = movie[@"title"];
    //cell.textLabel.text = [NSString stringWithFormat:@"Row %ld",(long)indexPath.row];
    //NSLog(@"Row %ld",(long)indexPath.row);

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    //NSDictionary *movie = self.movies[indexPath.row];
    //NSString *title = movie[@"title"];
    //cell.textLabel.text = title;
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];;
    cell.synopsisLabel.text = movie[@"synopsis"];;

    NSString *posterURLString = [movie valueForKeyPath:@"posters.thumbnail"];
    //NSLog(@"%@",posterURLString);
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURLString]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *movie = self.movies[indexPath.row];
    ViewController *destnationVC = segue.destinationViewController;
    destnationVC.movie = movie;
}


@end
