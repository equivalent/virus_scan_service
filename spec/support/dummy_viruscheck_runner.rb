class DummyViruscheckRunner
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def call
  end

  def result
    'Clean'
  end
end
