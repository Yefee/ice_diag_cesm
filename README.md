# ice_diag_cesm
Diagnosing delta 18O and delta D in sea ice in cesm

#### Steps to run the ice diagnostics package
 
1. copy all your ice history file (in my case is 999 and 1000) to /glade/scratch/$user/diags/ (if no diag direcotry, make one)

2. modify the ice_diag.csh file as I write in the end

3. ./ice_diag.csh

4. go to /glade/scratch/$user/web_plots/$casename; mkdir html; mv $casename.tar html/; cd html; tar -xf $casename.tar; cd ice/yrs(start-end); firefox index.html

####how to modify the ice_diag.csh
line 22: enter your case name;

line 37: change the first number to the start model year you want;

line 37: change the first number to the end model year you want;

In my example, the start year is 999, and end year is 1000, case is b.e13.Bi1850C5.f19_g16.21ka.05;

Note *CASE_TO_DIFF* is invalid;

line 88: set your ice diagnostics package root directory. The isotope version is at /glade/p/work/che43/tools/PWDG/ice_diag.

If your want to make a version of your own, please copy it from my directory. Or, you can leave it there.