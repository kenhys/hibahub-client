def fixture_path(*elements)
  File.join(File.dirname(__FILE__), "fixtures", *elements)
end

def sandbox
  Dir.mktmpdir do |dir|
    ENV['YOMOU_HOME'] = File.join(dir, '.yomou')
    yield
  end
end
