# EpicPing
*Written back in 2011, my first script!*

## Backstory:
I had received a ticket for a Windows host that was inaccessible. I had found the host to be powered down and so proceeded to power it up, check logs, and found no issues. By the time I had walked back to my desk the host was down again. So I head back out and power it back on. I double checked things and waited several minutes at the host to see if it went down again. Satisfied the issue was resolved I went back to my desk to find that during my walk back the host was down again. I went back to the host a few more times and it seemed that the host refused to go down until I had walked all the way back to my desk. I wanted to have a clear timestamp of when it went down and at first I thought of ping. I had a few problems with ping:
* 'ping -t' output felt like spam
* I didn't want to poll the device, I wanted something more like push

My quick solution was to mount a network share via commandline on the host and run an echo loop to a file on the share. I didn't care what the file content was as I just needed "date last modified" to get when exactly the host went down. Unfortunately I don't recall what the root cause was but long story short is: it made me want a cleaner ping. 

Slowly I added more things to the script to help solve more frustrations and what you see now (with the exception of use-log/removed) is the end result!

### tl;dr

Wanted cleaner ping with up/down timestamps without spam and later added more functionality to it in order to gather all necessary information for anything I would need to do.


Here is an old screenshot of the output & options:

![alt text](https://media.licdn.com/media-proxy/ext?w=800&h=800&f=n&hash=XbMtLCfHzHs8qsN2EAW1WD6FDaQ%3D&ora=1%2CaFBCTXdkRmpGL2lvQUFBPQ%2CxAVta9Er0Vinkhwfjw8177yE41y87UNCVordEGXyD3u0qYrdfyPsLcLZebehuQgUeSgckQVnffL5STbjD5G-K4rvLI10ipXscY24ZxUBbFImi24)
