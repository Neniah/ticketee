class Comment < ActiveRecord::Base

  after_create :set_ticket_state

  validates :text, :presence => true
  belongs_to :user
  belongs_to :state
  belongs_to :ticket

  delegate :project, to: => ticket

  before_create :set_previous_state

  belongs_to :previous_state, :class_name => "State"


  private

    def set_previous_state
      self.previous_state = ticket.state
    end

    def set_ticket_state
      self.ticket.state = self.state
      self.ticket.save!
    end

end
