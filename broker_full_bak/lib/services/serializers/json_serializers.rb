require 'json'

module JsonSerializers
  def to_base_object(response)
    base_object = JSON.parse(response)
    return unless success?(base_object)

    base_object['response']
  end

  def success?(response_obj)
    response_obj['response']['error'].downcase == 'success' unless response_obj['response']['error'].nil?
  end
end