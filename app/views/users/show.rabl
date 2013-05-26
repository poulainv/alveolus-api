object @user
extends 'users/show-lazy'


node do |user|
	if user
		child :comments do
			attributes :id, :body, :rating, :created_at, :updated_at, :webapp_id
		end

		child :webapps do
			attributes :id, :title, :caption, :description
		end

		child :bookmarks do
			child :webapp do
				attributes :id, :title, :caption, :description
			end
		end

	end
end