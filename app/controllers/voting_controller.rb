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
        HateVote.find_by(user_id: current_user.id, song_id: @song.id).touch
        check_hate_threshold
        render nothing: true
    end

    private
        def find_or_create_song
            artist = @mpc.current_song.artist
            album_title = @mpc.current_song.album
            title = @mpc.current_song.title

            # Just return the song if already exists in the database,
            # otherwise create and return it
            album = Album.find_or_create_by title: album_title
            @song = Song.find_or_create_by artist: artist, album_id: album.id, title: title
        end

        def count_users
          users = User.all
          count = 0

          users.each do |user|
            if user.online?
              count = count + 1
            end
          end

          return count
        end


        def vote_threshold
          clients_connected = count_users
          rel_threshold = 0

          # scale relative vote threshold according to number of connected clients
          if clients_connected > 1
            rel_threshold = 1 / Math::log(clients_connected, 2)
          else
            rel_threshold = 1
          end

          # compute absolute vote threshold
          abs_threshold = (rel_threshold * clients_connected).round

          return abs_threshold
        end


        def check_hate_threshold
						votes = HateVote.where(:song_id => @song.id)
						votecount = 0
						votes.each do |vote|
              user = User.where(:id => vote.user_id).first
							if vote.updated_at > 2.hours.ago
								votecount = votecount + 1
							end
						end

            if votecount >= vote_threshold
              render text: @mpc.next
            end

            return
        end
end
