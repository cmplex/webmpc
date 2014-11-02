class WebsocketController < WebsocketRails::BaseController
	def initialize_session
		#todo: setup
		controller_store[:message_count] = 0
	end
end
