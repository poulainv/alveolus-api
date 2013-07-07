class NotificationSerializer < ActiveModel::Serializer
	  attributes :id, :is_readed, :text,:path_action,:created_at
end
