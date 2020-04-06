TESSERACT_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join("config", "tesseract.yml"))).result)[Rails.env].symbolize_keys

TESSERACT_CONFIG[:base_uri] = "#{TESSERACT_CONFIG[:host]}:#{TESSERACT_CONFIG[:port]}"

Rails.logger.info("Connection to Tesseract is setup on #{TESSERACT_CONFIG[:base_uri]}")