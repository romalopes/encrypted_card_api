class Log < ApplicationRecord

	belongs_to :user, dependent: :destroy

	validates_presence_of :user_id, :message

	def as_json(options={})
  	{ 
  		message: self.message,
  		description: self.description,
  		created_at: self.created_at.strftime('%d-%m-%Y %H:%M:%S')

  	}
	end
end

