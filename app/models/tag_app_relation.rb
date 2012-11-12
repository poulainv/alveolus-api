# == Schema Information
#
# Table name: tag_app_relations
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  webapp_id  :integer
#  coeff      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagAppRelation < ActiveRecord::Base
  attr_accessible :tag_id, :webapp_id
  
  belongs_to :tag, :class_name => "Tag"
  belongs_to :webapp, :class_name => "Webapp"
 
  validates :tag_id, :presence => true
  validates :webapp_id, :presence => true
end
