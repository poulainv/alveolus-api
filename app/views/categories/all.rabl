object @categories
attributes :id,:name, :description

node do |categories|
	if categories
		child :webapps do
			attributes :id, :rating, :title, :description, :caption, :image, :average_rate, :validate

			node(:image_url) { |webapps| webapps.image_url(:medium) }

		end
	end
end
