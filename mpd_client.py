# vim: tabstop=3 shiftwidth=3 noexpandtab
# @author Sebastian Neuser
# @author Cedric Haase

########################################
#          C O N S T A N T S           #
########################################

HOST='localhost'
PORT='6600'

# include mpd module
import mpd

client = mpd.MPDClient();



########################################
#          F U N C T I O N S           #
########################################

###
### information retrieval
###

def addSearchResult(query, number):
	# connect and fetch data
	client.connect(HOST, PORT)

	number = int(number)

	result = client.search('any', query)[number]

	client.add(result['file'])

	client.close()
	client.disconnect()


def addSong(title, album, artist):
	# connect and fetch data
	client.connect(HOST, PORT)

	for song in client.find('title', title):
		if song['album'] == album and song['artist'] == artist:
			client.add(song['file'])

	client.close()
	client.disconnect()


def fetchSearchResults(query):
	# connect and fetch data
	client.connect(HOST, PORT)

	results = client.search('any', query)
	postlist = list()

	for song in results:
		try:
			title = song['title']
		except KeyError:
			title = "None"
			pass

		try:
			album = song['album']
		except KeyError:
			album = "None"
			pass

		try:
			artist = song['artist']
		except KeyError:
			artist = "None"
		
		songinfo = [ title, album, artist ]
		postlist.append(songinfo)

	# clean up and return result
	client.close()
	client.disconnect()
	import json
	return json.JSONEncoder().encode(postlist)
	

def fetchPlaylist():
	# connect and fetch data
	client.connect(HOST, PORT)
	try:
		playlist = [client.status()['song'], []]
	except KeyError:
		playlist = [-1, []]

	for song in client.playlistinfo():

		try:
			title = song['title']
		except KeyError:
			title = "None"
			pass

		try:
			album = song['album']
		except KeyError:
			album = "None"
			pass

		try:
			artist = song['artist']
		except KeyError:
			artist = "None"
			pass

		songinfo = [ title, album, artist ]
		playlist[1].append(songinfo)

	# clean up and return result
	client.close()
	client.disconnect()
	import json
	return json.JSONEncoder().encode(playlist)


def getCurrentAlbum():
	# connect and fetch data
	client.connect(HOST, PORT)

	try:
		album = client.currentsong()['album']
	except KeyError:
		album = "None"
		pass

	# clean up and return result
	client.close()
	client.disconnect()
	return album

def getCurrentArtist():
	# connect and fetch data
	client.connect(HOST, PORT)
	
	try:
		artist = client.currentsong()['artist']
	except KeyError:
		artist = "None"
		pass

	# clean up and return result
	client.close()
	client.disconnect()
	return artist

def getCurrentTitle():
	# connect and fetch data
	client.connect(HOST, PORT)
		
	try:
		title = client.currentsong()['title']
	except KeyError:
		title = "None"
		pass

	# clean up and return result
	client.close()
	client.disconnect()
	return title

def getTrackProgress():
	# connect and fetch data
	client.connect(HOST, PORT)
	song_length = float(client.currentsong()['time'])
	elapsed = float(client.status()['elapsed'])
	percentage = elapsed / song_length * 100

	# clean up and return result
	client.close()
	client.disconnect()
	return percentage


def listAlbums(artist):
	# connect and fetch data
	client.connect(HOST, PORT)

	albums = list()
	for element in client.lsinfo(artist):
		try:
			albums.append(element['directory'])
		except KeyError:
			pass

	# clean up and return result
	client.close()
	client.disconnect()
	import json
	return json.JSONEncoder().encode(albums)


def listArtists():
	# connect and fetch data
	client.connect(HOST, PORT)

	artists = list()
	for element in client.lsinfo():
		try:
			artists.append(element['directory'])
		except KeyError:
			pass

	# clean up and return result
	client.close()
	client.disconnect()
	import json
	return json.JSONEncoder().encode(artists)


def listSongs(album):
	# connect and fetch data
	client.connect(HOST, PORT)

	songs = list()
	for song in client.lsinfo(album):
		try:
			title = song['title']
		except KeyError:
			title = "None"
			pass

		try:
			album = song['album']
		except KeyError:
			album = "None"
			pass

		try:
			artist = song['artist']
		except KeyError:
			artist = "None"
			pass
		songinfo = [title, album, artist]
		songs.append(songinfo)

	# clean up and return result
	client.close()
	client.disconnect()
	import json
	return json.JSONEncoder().encode(songs)


###
### controls / actions
###

def lowerVolume():
	client.connect(HOST, PORT)

	# read, compute and set volume
	current_volume = int(client.status()['volume'])
	client.setvol(current_volume - 5)

	client.close()
	client.disconnect()

def next():
	client.connect(HOST, PORT)

	client.next()

	client.close()
	client.disconnect()

def playSong(number):
	client.connect(HOST, PORT)

	client.play(number)

	client.close()
	client.disconnect()

def prev():
	client.connect(HOST, PORT)

	client.previous()

	client.close()
	client.disconnect()

def raiseVolume():
	client.connect(HOST, PORT)

	# read, compute and set volume
	current_volume = int(client.status()['volume'])
	client.setvol(current_volume + 5)

	client.close()
	client.disconnect()

def setTrackProgress(factor):
	client.connect(HOST, PORT)

	# fetch current song id and length, compute new position and seek
	current_song = client.status()['songid']
	position  = int(client.currentsong()['time'])
	position *= float(factor)
	client.seek(current_song, int(position))

	client.close()
	client.disconnect()
	return factor

def toggle():
	client.connect(HOST, PORT)

	client.pause()

	client.close()
	client.disconnect()



########################################
#       M O D U L E   T E S T S        #
########################################

if __name__ == "__main__":
	import json
	print 'fetchPlaylist():'
	print fetchPlaylist()
	print
	print 'listArtists():'
	artists = listArtists()
	print artists
	print
	print 'listAlbums(\'' + json.JSONDecoder().decode(artists)[0] + '\'):'
	albums = listAlbums(json.JSONDecoder().decode(artists)[0])
	print albums
	print
	print 'listSongs(\'' + json.JSONDecoder().decode(albums)[0] + '\'):'
	print listSongs(json.JSONDecoder().decode(albums)[0])
