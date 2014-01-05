##!/usr/bin/perl
##
## SCHEMA supports the following keys: item, cat, begin_cat, end_cat,
##                                     exit, raw, sep, obgenmenu
##
## Modified by Carl Duff.

=for comment

item: add an item into the menu
{item => ["command", "label", "icon"]}

cat: add a category into the menu
{cat => ["name", "label", "icon"]}

begin_cat: begin of a category
{begin_cat => ["name", "icon"]}

end_cat: end of a category
{end_cat => undef}

sep: menu line separator
{sep => undef} or {sep => "label"}

exit: default "Exit" action
{exit => ["label", "icon"]}

raw: any valid Openbox XML string
{raw => q(xml string)},

obgenmenu: category provided by obmenu-generator
{obgenmenu => "label"}

scripts: executable scripts from a directory
{scripts => ["/my/dir", BOOL, "icon"]}
BOOL - can be either true or false (1 or 0)
0 == open the script in background
1 == open the script in a new terminal

wine_apps: windows applications installed via wine
{wine_apps => ["label", "icon"]}

=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to a icon or a valid icon name
#    * By default, category names are case insensitive. (e.g.: X-XFCE == x_xfce)

require '/home/taylor/.config/obmenu-generator/config.pl';

our $SCHEMA = [
#             COMMAND                 	LABEL          		ICON
   {item => ['thunar', 			'Files',		'thunar']},
   {item => ['urxvtc', 		 	'Terminal',		'urxvtc']},
   #{item => ['gnome-screenshot --interactive',  'Screenshot',	'gnome-screenshot']},
   {item => ['chromium',		'Web Browser',		'chromium']},
   #{item => ['chromium --incognito',	'Web Browser (incognito)','chromium']},
   {sep => undef},

    #          NAME			LABEL			ICON
    {cat => ['utility',			'Accessories', 		'applications-utilities']},
    {cat => ['development', 		'Development', 		'applications-development']},
	{begin_cat => ['Drivers and Support',  '/usr/share/icons/Faenza/apps/48/dconf-editor.png']},
		{item => ['urxvtc -e sudo ~/.config/executables/updatedriver.sh','Detect and install graphics drivers','urxvtc']},
		{item => ['urxvtc -e sudo ~/.config/executables/multimedia.sh','Install full multimedia support','urxvtc']},
		{item => ['urxvtc -e sudo ~/.config/executables/aur.sh','Install full Arch User Repository support','urxvtc']},
		{item => ['urxvtc -e sudo ~/.config/executables/printing.sh','Install full printing support','urxvtc']},
		{item => ['urxvtc -e sudo ~/.config/executables/install-octopi.sh','Install graphical software manager','urxvtc']},
		{item => ['urxvtc -e sudo ~/.config/executables/install-msm.sh','Install Manjaro Settings Manager','urxvtc']},
	{end_cat   => undef},
    {cat => ['education',		'Education',		'applications-science']},
    {cat => ['game',			'Games',		'applications-games']},
    {cat => ['graphics',		'Graphics', 		'applications-graphics']},
    {cat => ['audiovideo',		'Multimedia', 		'applications-multimedia']},
    {cat => ['network',			'Network', 		'applications-internet']},
    {cat => ['office', 			'Office', 		'applications-office']},
    {cat => ['settings', 		'Settings', 		'applications-accessories']},

## Custom "Advanced Menu"

   {begin_cat => ['Advanced Settings',  'gnome-settings']},
   {begin_cat => ['Desktop and Login',  '/usr/share/icons/Faenza/apps/48/dconf-editor.png']},
   {item => ['subl3 -m ~/.config/tint2/tint2rc','Tint2 Panel',	'subl3']},
   {item => ['gksu subl3 /etc/slim.conf','Slim Configuration',	'subl3']},
   {item => ['nitrogen', 	 	'Nitrogen',		'nitrogen']},
   {item => ['subl3 -m ~/.xinitrc',	'.xinitrc',		'subl3']},
   {item => ['subl3 -m ~/.xprofile',	'.xprofile',		'subl3']},
   {end_cat   => undef},
   {begin_cat => ['Obmenu-Generator', '/usr/share/icons/Faenza/apps/48/menu-editor.png']},
		{item => ['subl3 -m ~/.config/obmenu-generator/schema.pl','Pipe Menu Schema','subl3']},
		{item => ['subl3 -m ~/.config/obmenu-generator/config.pl','Pipe Menu Config','subl3']},
		{item => ['obmenu-generator -d','Refresh Icon Set','/usr/share/icons/Faenza/apps/48/application-default-icon.png']},
   {end_cat   => undef},
   {begin_cat => ['Openbox',  'openbox']},
		{item => ['openbox --reconfigure','Reconfigure Openbox','openbox']},
		{item => ['subl3 -m ~/.config/openbox/autostart','Openbox Autostart','subl3']},
		{item => ['subl3 -m ~/.config/openbox/rc.xml','Openbox RC','subl3']},
		{item => ['subl3 -m ~/.config/openbox/menu.xml','Openbox Menu','subl3']},
		{item => ['gksu subl3 /etc/oblogout.conf','Openbox Logout','subl3']},
   {end_cat   => undef},
   {begin_cat => ['Pacman / Servers', '/usr/share/icons/Faenza/apps/48/package-manager-icon.png']},
		{item => ['urxvtc -e sudo ~/.config/executables/change-repo.sh','Switch stable, testing and unstable repos','urxvtc']},
		{item => ['gksu subl3 /etc/pacman.conf','Pacman Config','subl3']},
		{item => ['gksu subl3 /etc/pacman.d/mirrorlist','Pacman Mirrorlist','subl3']},
   {end_cat   => undef},
   {end_cat   => undef},

## Back to standard pipe-menu

   {cat => ['system', 			'System', 		'applications-system']},
   {sep => undef},


## Use Oblogout script instead of simple exit command

   {item => ['xlock -mode blank', 	'Lock Screen', '	lock']},
   {item => ['oblogout',        	'Logout...',      	'exit']},

    #{cat => ['qt', 			'QT Applications', 	'qtlogo']},
    #{cat => ['gtk', 			'GTK Applications', 	'gnome-applications']},
    #{cat => ['x_xfce', 		'XFCE Applications', 	'applications-other']},
    #{cat => ['gnome', 			'GNOME Applications', 	'gnome-applications']},
    #{cat => ['consoleonly', 		'CLI Applications', 	'applications-utilities']},

    #                  LABEL             ICON
    #{wine_apps => ['Wine apps', 	'applications-other']},

]
