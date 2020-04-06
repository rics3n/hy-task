# This controller is made for accepting api request to accept an image
# The image is processed by tesseract to be transformed into text
# The text is matched against the companies in the database
# As a return value the company is returned

class Api::V1::Ocr::Invoice::FindCompanyController < ApplicationController
    class TesseractError < StandardError; end

    def create
        begin
            # send image to tesseract service to process the image
            # extracting the text
            ts = TesseractService.new(params[:images])
            resp = ts.process_image()
            raise TesseractError if resp.code != 200

            # match company found in text with companies in database
            company = CompanyMatcher.fuzzy_search(resp.body)

            # return company as json
            render status: :ok,
                json: {
                    company: company,
                }
        rescue TesseractError
            render status: resp.code, json: JSON.parse(resp.body)
        end
    end
end
