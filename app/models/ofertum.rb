class Ofertum < ActiveRecord::Base
  attr_accessible :course_code, :description, :end_date, :maximum_subscriptions, :start_date

  validates :description, :presence => true
end
