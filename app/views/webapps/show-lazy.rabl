object @webapp
attributes :id, :rating, :title, :description, :caption, :image, :average_rate

node do |webapp|
	if webapp
		child :tags do
			attributes :id, :name
		end

		child webapp.comments do |t|
			attributes *Comment.column_names
			child (:user) do
				attributes :id, :pseudo
			end
		end

		child webapp.category do |t|
			attributes :id, :name
		end

		node(:image_url) { |webapp| webapp.image_url(:medium) }

	end
end
