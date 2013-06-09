# vim: tabstop=3 shiftwidth=3 noexpandtab
# Makefile for the webmpc project.
# @author Sebastian Neuser

# target directory within your public HTTP directory
TARGET = webmpc

# your public HTTP directory
PUBLIC_HTTP_DIRECTORY = $(HOME)/public_html
#PUBLIC_HTTP_DIRECTORY = /var/www


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# normally you should not need to change the following settings
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# define Messages
MSG_BYE           = make: *** have a nice day!
MSG_CLEANING      = make: *** cleaning project...
MSG_DEPLOY        = make: *** deploying the app to your public HTML directory...
MSG_HELLO         = make: *** hi there!
MSG_INITDB        = make: *** initializing database...
MSG_PACKAGE       = make: *** packaging...
MSG_UNDEPLOY      = make: *** deleting the app from your public HTML directory...


# default target: help message
help:
	@echo "#------------------------------------------------------------------------------#"
	@echo "Hello and welcome to webmpc's service-Makefile!"
	@echo
	@echo "This Makefile is merely a collection of shortcuts for frequently occurring"
	@echo "tasks, nothing is actually being compiled in here (yet)."
	@echo
	@echo "Here are the available targets:"
	@echo "\tdeploy           = (re-)deploy the webapp to your public HTTP directory"
	@echo "\tpackage          = bundle a .tar.bz2 archive of the webapp"
	@echo "\tundeploy         = delete the webapp from your public HTTP directory"
	@echo
	@echo "#------------------------------------------------------------------------------#"

# greetings
_hello:
	$(info $(MSG_HELLO))
_bye:
	$(info $(MSG_BYE))


# target: copy the relevant parts to the public_html directory
deploy: _hello _undeploy _deploy _bye
_deploy:
	$(info $(MSG_DEPLOY))
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)
	install --mode=644 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET) $(wildcard *.html)
	install --mode=755 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET) $(wildcard *.py)
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/covers
	install --mode=644 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/covers $(wildcard covers/*)
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/lib
	install --mode=644 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/lib $(wildcard lib/*)
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/style
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/style/desktop
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/style/mobile
	install --mode=644 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/style/desktop $(wildcard style/desktop/*)
	install --mode=644 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/style/mobile $(wildcard style/mobile/*)
	install --mode=755 -d $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/frontend
	install --mode=644 -t $(PUBLIC_HTTP_DIRECTORY)/$(TARGET)/frontend $(wildcard frontend/*)

# target: initialize PostgreSQL user and database for webmpc
initdb: _hello _initdb _bye
_initdb:
	$(info $(MSG_INITDB))
	$(info Please set the password for the new PostgreSQL user to 'webmpc')
	sudo -u postgres createuser -DEPRS webmpc
	sudo -u postgres createdb -O webmpc webmpc

# target: bundle an archive of the webapp
package: _hello _package _bye
_package:
	$(info $(MSG_PACKAGE))
	git archive HEAD | bzip2 > webmpc-`git describe --always --dirty=SNAPSHOT`.tar.bz2

# target: bundle an archive of the webapp
undeploy: _hello _undeploy _bye
_undeploy:
	$(info $(MSG_UNDEPLOY))
	ls $(PUBLIC_HTTP_DIRECTORY)/$(TARGET) | egrep -v covers | rm -rf


# phony targets.
.PHONY: deploy initdb package undeploy _bye _deploy _hello _initdb _package _undeploy
.NOTPARALLEL:
