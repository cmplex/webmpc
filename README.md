## A web-based MPD client. ##


#### Features to be added ####

**Views:**

* Song view
* Playlist view
* Search view
* Browse view

**Additional pages:**

* Login
* Configuration Interface


**Song view:**

* admin functions:
	+ start / stop
	+ pause
	+ previous / next
	+ volume control (+ / -)
	+ song progress control (progress bar)
* privileged functions:
	+ pause
	+ volume control
* guest functions:
	+ wish (search/browse database & add to playlist, limit nr of additions)
	+ dislike (next) / like


**Playlist view:**

* admin functions:
	+ skip to song
	+ remove song
* privileged functions:
	+ skip to song
	+ remove song
* guest functions:
	+ view title information


**Search view:**

* admin functions:
	+ search for tracks and add to playlist
* privileged functions:
	+ search for tracks and add to playlist
* guest functions:
	+ search for track and add to playlist (1 per time interval)


**Browse view:**
* admin functions:
	+ search for tracks and add to playlist
* privileged functions:
	+ search for tracks and add to playlist
* guest functions:
	+ search for tracks and add to playlist (1 per time interval)


**Configuration interface:**
* admin functions:
	+ set shuffle / repeat
	+ set guest wish timeout
	+ set 'next'-vote trigger (relative)
* privileged functions:
	+ set shuffle / repeat


**Additional features:**
* user management (control permission assignment)
	+ admin group
	+ privileged group
	+ guests
* enabling users to broadcast their local music to the server
* vote statistics evaluation



#### Requirements ####

###### Server ######
The WebMPC server-side runs on top of the following daemons and libraries:
*	MPD (&ge; 0.16.7)
*	python-mpd (&ge; 0.3.0)
*	Apache (&ge; 2.2.22)
*	libapache2-mod-python (&ge; 3.3.1)

###### Client ######
WebMPC is optimized for Firefox (&ge; 10.0.12) and Android (&ge; 4.0) browsers. Other browsers should
work as well, but you may have to be ready for some weird behaviour / looks.



#### Deployment ####
The service Makefile has a target `deploy`, which installs all necessary files to a destination
that is configured within the Makefile by two variables:
*	`PUBLIC_HTML_DIRECTORY` is the root directory of your HTTP server's web content
*	`TARGET` is the target directory for the app within the `PUBLIC_HTML_DIRECTORY`
The default configuration is suitable for the default configuration of the Apache webserver's
userdir module.



#### Apache configuration ####

###### Userdir module #######
If you are using the Apache HTTP server and you want to use the `make deploy` target to install the
app, you can use Apache's userdir module.

As root:
*	enable the module: `a2enmod userdir`
*	restart the server: `service apache2 restart`

As normal user:
*	ensure the required permissions on your $HOME directory: `chmod +x $HOME`
*	create your public HTML folder: `install --mode=755 -d $HOME/public_html`

You should now be able to reach your public HTML directory via `http://localhost/~username`.

If you have the username module set up differently (e.g. you use a different name for users' pulic
HTML directories), you can simply modify the related variables in the Makefile.

###### Python module #######
WebMPC needs Apache's Python module to work. You can set it up in a few simple steps (as root):
*	install the module (on Debian GNU/Linux: `aptitude install libapache2-mod-python`)
*	enable the module: `a2enmod python`
*	add the following two lines to your `/etc/apache2/sites-enabled/000-default.conf` (or whatever
	site you want your WebMPC to run on):

    ```xml
    <Directory />
		<!-- [...] -->

        AddHandler mod_python .py
		PythonHandler mod_python.publisher

		<!-- [...] -->
    </Directory>
    ```

*	restart the server: `service apache2 restart`
