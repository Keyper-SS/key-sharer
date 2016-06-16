# Service object to create new Secret using all columns
class DeleteSharing
  def self.call(sharing_id:)
    sharing = Sharing[sharing_id]
    sharing.delete
  end
end
