class Feedback
  attr_accessor :subject, :email, :comment, :page

  def initialize(comment, page)
    self.comment = comment
    self.page = page
  end

  def valid?
    self.comment && !self.comment.strip.blank?
  end
end
