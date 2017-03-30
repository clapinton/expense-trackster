# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  created_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
end
