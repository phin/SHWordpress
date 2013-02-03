//
//  SHDetailViewController.m
//  SHWordpress
//
//  Created by Seraphin Hochart on 2013-02-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "SHDetailViewController.h"

@interface SHDetailViewController ()
    @property (nonatomic, strong) IBOutlet UIWebView *wv_content;
@end

@implementation SHDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.wv_content.delegate = self;
    [self.wv_content loadHTMLString:self.s_content baseURL:nil];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	av.frame=CGRectMake(webView.frame.size.width/2-25, webView.frame.size.height/2-25, 50, 50);
	av.tag  = 1;
	[webView addSubview:av];
	[av startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[webView viewWithTag:1];
	[tmpimg removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error loading view");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
