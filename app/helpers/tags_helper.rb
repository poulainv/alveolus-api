module TagsHelper

  def most_used_tags
    @taglist = Tag.most_used(10)
  end

end
