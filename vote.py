# vim: tabstop=3 shiftwidth=3 noexpandtab
# @author Cedric Haase

import math
import mpd

HOST='localhost'
PORT='6600'

MAX_VOL_PERC = 70
CLIENTS_CONNECTED = 3

client = mpd.MPDClient();

def getThreshold():
	# TODO: get number of currently connected clients
	clients_connected = CLIENTS_CONNECTED

	# scale relative vote threshold according to number of connected clients
	if(clients_connected > 1):
		rel_threshold = 1 / math.log(clients_connected, 2)
	else:
		rel_threshold = 1

	# compute absolute vote threshold (round to nearest integer)
	abs_threshold = int(round((clients_connected * rel_threshold),0))

	return abs_threshold



def checkVotes(path):
	abs_vote_threshold = getThreshold()

	client.connect(HOST, PORT)

	stickers = client.sticker_list("song", path)

	# count total amount of next/hype votes
	nextvotes=0
	hypevotes=0
	for sticker in stickers:
		if sticker.split("=")[1] == "next":
			nextvotes+=1
		if sticker.split("=")[1] == "hype":
			hypevotes+=1

	# skip song on skipvote threshold
	if(nextvotes >= abs_vote_threshold):
		client.sticker_delete("song", path)
		client.next()

	# raise volume according to number of hype votes
	# TODO get volume cap from database or config file
	# cap volume at MAX_VOL_PERC
	if(hypevotes < abs_vote_threshold):
		hype_volume = (float(hypevotes)/float(abs_vote_threshold)) * MAX_VOL_PERC
		hype_volume = int(round(hype_volume,0))
	else:
		hype_volume = MAX_VOL_PERC
	print hype_volume
	cur_volume	= int(client.status()['volume'])
	if(hype_volume > cur_volume):
		# TODO remember original value & reset on next track
		# increase volume
		client.setvol(hype_volume)

	client.close()
	client.disconnect()


def voteNext(clientid):
	client.connect(HOST, PORT)
	
	# get path of current song
	path = client.currentsong()['file']

	# set 'next' vote for current clientID and song
	client.sticker_set("song", path, clientid, "next")

	client.close()
	client.disconnect()

	checkVotes(path)


def voteHype(clientid):
	client.connect(HOST, PORT)

	# get path of current song
	path = client.currentsong()['file']

	# set 'hype' vote for current clientID and song
	client.sticker_set("song", path, clientid, "hype")

	client.close()
	client.disconnect()

	checkVotes(path)

##################################
#		M O D U L E  T E S T S		#
##################################

if __name__ == "__main__":
	MAX_VOL_PERC = 70
	CLIENTS_CONNECTED = 20
	voteHype(1)
	voteHype(2)
	voteHype(3)
	voteHype(4)
	voteHype(5)
	voteHype(6)
	voteHype(7)
	voteHype(8)
