class BaselineRequest
  include BaselineEndpoints

  attr_accessor :endpoint, :uri, :options, :parameters
  def initialize(endpoint, options = {})
    raise "#{endpoint} is not a valid endpoint" unless ENDPOINTS[endpoint]
    @endpoint = endpoint
    @api_info = ENDPOINTS[@endpoint]
    @options = options.with_indifferent_access
  end

  def test
    @options = @api_info[:test_params]
    call_api
  end

  def call_api
    path, error_array = construct_path
    query = @options.slice(*@api_info[:query_params])
    @api_info[:required_params].each do |req_group|
      error_array << "Missing one of the following required parameters: #{req_group.to_s}" unless req_group.any? {query.keys.include? _1 }
    end

    return error_array unless error_array.empty?
    HTTParty.get(path, {:query => query})
  end

  def construct_path
    error_array = []
    url = @api_info[:url].dup
    @api_info[:path_params].each do |path_key, value|
      case value[:type]
      when "bool"
        path_value = value[@options[path_key].to_s] || value[value[:default].to_s]
      else
        path_value = @options[path_key] || value[:default]
      end
      error_array << "Missing required path parameter: #{path_key}" if value[:required] && path_value.blank?
      path_value = path_value.to_s
      path_value = "/" + path_value if path_value.present? && value[:leading_slash]
      url.sub! "{#{path_key}}", path_value
    end

    [url, error_array]
  end

  def params
    @api_info[:query_params] + @api_info[:path_params].keys
  end

  def set_option(key, value, overwrite = true)
    raise "#{key} not a valid parameter for #{@endpoint} endpoint" unless params.include? key
    @options[key] = overwrite ? value : @options[key] || value
    self
  end
end