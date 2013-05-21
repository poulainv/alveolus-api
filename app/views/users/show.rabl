object @user
extends 'users/show-lazy'


node do |user|
	if user
		child :comments do
			attributes :id, :body, :rating
		end

		child :webapps do
			attributes :id, :title, :caption, :description
		end

		child :webapps_starred do
			attributes :id, :title, :caption, :description
		end

	end
end