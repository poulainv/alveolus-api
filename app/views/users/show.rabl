object @user
attributes *User.column_names

node do |user|
	if user
		child :comments do
			attributes *Comment.column_names
		end

		child :webapps do
			attributes *Webapp.column_names
		end

		child :webapps_starred do
			attributes *Webapp.column_names
		end

		
	end
end
