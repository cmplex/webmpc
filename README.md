## A web-based MPD client. ##


#### Deployment ####
The service Makefile has a target `deploy`, which installs all necessary files to a destination
that is configured within the Makefile by two variables:
*   `PUBLIC_HTML_DIRECTORY` is the root directory of your HTTP server's web content
*   `TARGET` is the target directory for the app within the `PUBLIC_HTML_DIRECTORY`
The default configuration is suitable for the default configuration of the Apache webserver's
userdir module.



#### Apache userdir configuration ####
If you are using the Apache HTTP server and you want to use the `make deploy` target to install the
app, you can use Apache's userdir module.

As root:
*   enable the module: `a2enmod userdir`
*   comment-out the following block in the file `/etc/apache2/mods-enabled/php5.conf`:

    ```xml
    <IfModule mod_userdir.c>
    <Directory /home/*/public_html>
        php_admin_value engine Off
    </Directory>
    </IfModule>
    ```

*   restart the server: `service apache2 restart`

As normal user:
*   ensure the required permissions on your $HOME directory: `chmod +x $HOME`
*   create your public HTML folder: `install --mode=755 -d $HOME/public_html`

You should now be able to reach your public HTML directory via `http://localhost/~username`.

If you have the username module set up differently (e.g. you use a different name for users' pulic
HTML directories), you can simply modify the related variables in the Makefile.
