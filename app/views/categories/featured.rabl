object @categories
attributes :id,:name

node do |categories|
	if categories
		child :featured_webapp do
			attributes :id, :rating, :title, :description, :caption, :image, :average_rate
			node do |featured_webapp| 
				if featured_webapp
					child :tags do
						attributes :id,:name
					end
				end
			end
		end
	end
end
