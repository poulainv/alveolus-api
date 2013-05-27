object @user
extends 'users/show-lazy'


node do |user|
	if user
		child :comments do
			attributes :id, :body, :rating, :created_at, :updated_at, :webapp_id
			child :webapp do
				attributes :id, :title, :caption, :description
				node(:image_url) { |webapp| webapp.image_url(:medium) }
			end
		end

		child :webapps do
			attributes :id, :title, :caption, :description
			node(:image_url) { |webapp| webapp.image_url(:medium) }
		end

		child :bookmarks do
			child :webapp do
				attributes :id, :title, :caption, :description
				node(:image_url) { |webapp| webapp.image_url(:medium) }
			end
		end

	end
end