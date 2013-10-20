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
The only requirement for the server is Ruby (&ge; 1.9.3).

###### Client ######
WebMPC is optimized for Firefox (&ge; 10.0.12) and Android (&ge; 4.0) browsers. Other browsers should
work as well, but you may have to be ready for some weird behaviour / looks.



#### Configuration &amp; Deployment ####
* Clone the repository:

    ```
    git clone https://github.com/cmplex/webmpc.git
    cd webmpc
    ```

* Install necessary gems (requires root priviledges):

    ```
    gem install rails
    bundle install
    ```

* Configure the mailer:

    * Edit `config.mailer_sender` in `config/initializers/devise.rb`.
    * Edit `config/environments/development.rb`:
        * Enter your hostname in `config.action_mailer.default_url_options`.
        * Adjust the SMTP settings in `config.action_mailer.smtp_settings`.

* Initialize the database and run the server:

    ```
    rake db:migrate
    rails server
    ```
