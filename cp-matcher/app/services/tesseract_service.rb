class TesseractService
    include HTTParty
    base_uri TESSERACT_CONFIG[:base_uri]

    def initialize(images)
        @options = { 
            multipart: true,
            body: {
                images: images
            }
        }
    end

    def process_image
        self.class.post("/tesseract-recognize/process", @options)
    end
end
