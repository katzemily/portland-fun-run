# portland-fun-run
All things related to organizing [Portland Fun Run](https://www.meetup.com/portland-fun-run/), a local running meetup I organize in Portland, OR.  

## Run Club Text  
This parameterized quarto file is used weekly to create text for both the Meetup event and the weekly Meetup email to members that is customized based on which bar or brewery the run starts at. It automatically pulls in the correct route length, address, wording, etc. to reduce the possibility of error and speed up the process.     

### Data Sources  
Run Club Venues: Googlesheets file that lists all venues, route links, route lengths, venue addresses, etc. 

## Instructions:  
1.  Update the `bar_abbr` arguement within the `params` arguement in the YAML header to the bar that the meetup will be at this week.
2.  Render the document.
3.  Copy and paste the text under the **Event Text** header in the rendered Quarto document into this week's Meetup event.
4.  Copy the Map My Run link into the browser, duplicate the route, rename with today's date, and save.
5.  Replace **[UPDATE LINK]** and the original link with the new Map My Run link.
6.  Go to Portland Fun Run homepage and click **"Contact Members"**.
7.  Copy and paste the text under **Email Text** header in the rendered Quarto document.
8.  Use the Google Maps link provided after **UPDATE** to make the address into a hyperlink.
9.  Replace **[UPDATE LINK]** with the new Map My Run link you just created.
10.  Send email.
