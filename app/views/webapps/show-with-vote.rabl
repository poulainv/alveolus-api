collection @webapps

attributes *Webapp.column_names

node do |webapps|
	if webapps

		child :tags do
		attributes *Tag.column_names
		end

		child :category do |t|
		attributes :id, :name
		end

		node(:image_url) { |webapp| webapp.image_url(:medium) }

		node(:count_positive) { |webapp| webapp.count_positive }

		node(:count_negative) { |webapp| webapp.count_negative }

		node(:my_vote) { |webapp| webapp.vote_user(current_user)}
	end
end