class VotingController < MpdController
    before_action :check_permissions, only: :reset
    before_action :find_or_create_song, except: :reset

    def reset
        # Delete all votes
        HypeVote.delete_all
        HateVote.delete_all
        redirect_to :back, notice: 'Voting system has been reset.'
    end

    def hype
        # Create HypeVote if it doesn't yet exist
        HypeVote.find_or_create_by user_id: current_user.id, song_id: @song.id
        render nothing: true
    end

    def hate
        # Create HateVote if it doesn't yet exist
        HateVote.find_or_create_by user_id: current_user.id, song_id: @song.id
        render nothing: true
    end

    private
        def find_or_create_song
            artist = @mpc.current_song.artist
            album = @mpc.current_song.album
            title = @mpc.current_song.title

            # Just return the song if already exists in the database,
            # otherwise create and return it
            @song = Song.find_or_create_by artist: artist, album: album, title: title
        end
end
