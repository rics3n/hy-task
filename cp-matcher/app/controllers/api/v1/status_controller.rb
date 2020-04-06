class Api::V1::StatusController < ApplicationController
    def index
        render status: 200,
            json: {
                success: 'API-Server is online',
                code: 'ONLINE'
            }
    end
end
