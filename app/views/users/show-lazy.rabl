object @user

attributes :id,:pseudo, :created_at, :email, :sign_in_count


node do |user|
	if user
		node(:image_url) { |user| user.image_url(:small) }
	end
end
