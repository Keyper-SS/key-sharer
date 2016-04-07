require 'json'

# Holds a full configuration document information
class Key
  STORE_DIR = 'db/'.freeze

  attr_accessor :id, :owner, :title, :description, :key	, :value, :shared

  def initialize(new_key)
    @id = new_key['id'] || new_id
    @owner = new_key['owner']
    @title = new_key['title']
    @description = new_key['description']
    @key = new_key['key']
    @value = new_key['value']
    @shared = new_key['shared']
  end

  def new_id
    Base64.urlsafe_encode64(Digest::SHA256.digest(Time.now.to_s))[0..9]
  end

  def to_json(options = {})
    JSON({ id: @id,
           owner: @owner,
           title: @title,
           description: @description,
           key: @key,
           value: @value,
           shared: @shared },
         options)
  end

  def save
    File.open(STORE_DIR + @id + '.txt', 'w') do |file|
      file.write(to_json)
    end

    true
  rescue
    false
  end

  def self.all
    Dir.glob(STORE_DIR + '*.txt').map do |filename|
      filename.match(%r{db\/(.*)\.txt})[1]
    end
  end

  def self.find(find_id)
    key_file = File.read(STORE_DIR + find_id + '.txt')
    Key.new JSON.parse(key_file)
  end

  def self.setup
    Dir.mkdir(Key::STORE_DIR) unless Dir.exist? STORE_DIR
  end

end
