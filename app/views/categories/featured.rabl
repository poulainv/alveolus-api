object @categories
attributes :id,:name, :description

node do |categories|
	if categories
		child :featured_webapp do
			attributes :id, :rating, :title, :description, :caption, :image, :average_rate

			node(:image_url) { |featured_webapp| featured_webapp.image_url(:medium) }

			node do |featured_webapp| 
				if featured_webapp
					child :tags do
						attributes :id,:name
					end

					child :comments do |t|
						attributes :id
					end
				end
			end
		end
	end
end
