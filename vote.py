# vim: tabstop=3 shiftwidth=3 noexpandtab
# @author Cedric Haase

HOST='localhost'
PORT='6600'

ABS_NEXT_THRESHOLD = 2
ABS_HYPE_THRESHOLD = 2

import mpd

client = mpd.MPDClient();

def checkVotes(path):
	client.connect(HOST, PORT)

	stickers = client.sticker_list("song", path)

	# count total amount of next votes
	nextvotes=0
	hypevotes=0
	for sticker in stickers:
		if sticker.split("=")[1] == "next":
			nextvotes+=1
		if sticker.split("=")[1] == "hype":
			hypevotes+=1

	# skip song on skipvote threshold
	if(nextvotes >= ABS_NEXT_THRESHOLD):
		client.sticker_delete("song", path)
		client.next()

	# enqueue song again on hype threshold
	if(hypevotes >= ABS_HYPE_THRESHOLD):
		client.sticker_delete("song", path)
		client.add(path)	

	client.close()
	client.disconnect()


def voteNext(clientid):
	client.connect(HOST, PORT)
	
	# get path of current song
	path = client.currentsong()['file']

	# set 'next' vote for current clientID and song
	client.sticker_set("song", path, clientid, "next")

	retval = client.sticker_get("song", path, clientid)

	client.close()
	client.disconnect()

	checkVotes(path)

	return retval

def voteHype(clientid):
	client.connect(HOST, PORT)

	# get path of current song
	path = client.currentsong()['file']

	# set 'hype' vote for current clientID and song
	client.sticker_set("song", path, clientid, "hype")

	retval = client.sticker_get("song", path, clientid)
	
	client.close()
	client.disconnect()

	checkVotes(path)

	return retval
