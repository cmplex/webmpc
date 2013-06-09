# vim: tabstop=3 shiftwidth=3 noexpandtab
# Copyright 2013 Sebastian Neuser
#
# This file is part of webmpc.
#
# webmpc is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# webmpc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with webmpc.  If not, see <http://www.gnu.org/licenses/>.

 # database connection manager
 # @author Sebastian Neuser

import psycopg2



################################################################
##                     V A R I A B L E S                      ##
################################################################

CONNECTION_PARAMETERS = 'host=localhost dbname=webmpc user=webmpc password=webmpc'
connection = None;
cursor = None;



################################################################
##      F U N C T I O N S   A N D   P R O C E D U R E S       ##
################################################################

def _close():
	cursor.close()
	connection.close()


def _commitAndClose():
	try:
		connection.commit()
		_close()
	except:
		print 'Could not commit the transaction!'


def _connect():
	try:
		global connection
		global cursor
		connection = psycopg2.connect(CONNECTION_PARAMETERS)
		cursor = connection.cursor()
	except:
		print 'Error connecting to the database!'


def checkCredentials(username, password):
	try:
		# fetch password hash from the database
		_connect()
		cursor.execute('SELECT passwd FROM users WHERE name=%s;', [username])
		passwordHash = cursor.fetchone()[0]
		_close()

		# check if the supplied password matches the stored one
		import hashlib
		if hashlib.md5(password).hexdigest() == passwordHash:
			return True
		else:
			return False
	except:
		print 'Error checking credentials for user ' + username + '!'
		return False


def checkPermissions(username, mask):
	try:
		# fetch password hash from the database
		_connect()
		cursor.execute('SELECT permissions FROM users WHERE name=%s;', [username])
		permissions = cursor.fetchone()[0]
		_close()
		if mask <= long(permissions):
			return True
		else:
			print str(mask), '>', permissions
			return False
	except:
		print 'Error checking permissions for user', username, 'and permission mask', mask, '!'
		return False


def getDatabaseVersion():
	try:
		_connect()
		cursor.execute('SELECT dbversion FROM settings;')
		version = cursor.fetchone()[0]
		_close()
		return version
	except:
		return None


def initializeDatabase():
	try:
		_connect()
		cursor.execute("CREATE TABLE settings (dbversion integer);")
		cursor.execute("CREATE TABLE users (id          SERIAL PRIMARY KEY, \
		                                    name        text, \
														passwd      text, \
														permissions integer);")
		cursor.execute("INSERT INTO settings VALUES (1);")
		cursor.execute("INSERT INTO users (name, passwd, permissions) VALUES ('admin', MD5('webmpc'), X'7FFFFFFF'::integer);")
		_commitAndClose()
	except:
		print 'Error initializing the database!'



########################################
#       M O D U L E   T E S T S        #
########################################

if __name__ == "__main__":
	print 'initialization:'
	#print initializeDatabase()
	print
	print 'database schema version:'
	print getDatabaseVersion()
	print
	print 'checking admin\'s credentials:'
	print checkCredentials('admin', 'webmpc')
	print
	print 'checking admin\'s permissions:'
	print checkPermissions('admin', 0x7fffffff)
